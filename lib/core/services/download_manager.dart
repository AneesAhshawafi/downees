import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/download/domain/entities/download_task.dart';
import '../enums/download_status.dart';
import 'download_queue.dart';
import 'media_muxer_service.dart';

class DownloadManager {
  final Dio dio;
  final DownloadQueue _queue;
  final MediaMuxerService _mediaMuxerService;
  final int maxConcurrent;
  final int maxRetries;

  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, int> _pausedBytes = {};
  final Map<String, bool> _isPaused = {};
  final Map<String, int> _lastReceivedBytes = {};

  final StreamController<DownloadTask> _progressController =
      StreamController<DownloadTask>.broadcast();

  Stream<DownloadTask> get progressStream => _progressController.stream;
  DownloadQueue get queue => _queue;

  DownloadManager({
    required this.dio,
    DownloadQueue? queue,
    MediaMuxerService? mediaMuxerService,
    this.maxConcurrent = 3,
    this.maxRetries = 3,
  }) : _queue = queue ?? DownloadQueue(maxConcurrent),
       _mediaMuxerService = mediaMuxerService ?? MediaMuxerService();

  /// بدء تحميل جديد مع مراعاة إدارة الطابور
  Future<void> startDownload(DownloadTask task) async {
    // إذا كانت المهمة قيد التحميل بالفعل لا نبدأها مرة أخرى
    if (_cancelTokens.containsKey(task.id)) {
      return;
    }

    // التحقق من حدود التزامن
    if (!_queue.canStartNext && !_queue.isActive(task.id)) {
      _queue.enqueue(task);
      _emitUpdate(task.copyWith(status: DownloadStatus.pending));
      return;
    }

    _queue.markActive(task.id);
    await _executeDownload(task);
  }

  Future<void> _executeDownload(DownloadTask task) async {
    final cancelToken = CancelToken();
    _cancelTokens[task.id] = cancelToken;
    _isPaused[task.id] = false;

    _emitUpdate(task.copyWith(status: DownloadStatus.downloading));

    String effectiveSavePath = task.savePath;
    try {
      if (effectiveSavePath.isNotEmpty) {
        final parentDir = File(effectiveSavePath).parent;
        if (!parentDir.existsSync()) {
          parentDir.createSync(recursive: true);
        }
      }
    } catch (_) {
      try {
        final docs = await getApplicationDocumentsDirectory();
        final fileName = effectiveSavePath.split(RegExp(r'[/\\]')).last;
        final safeDir = Directory('${docs.path}/Downees');
        if (!safeDir.existsSync()) {
          safeDir.createSync(recursive: true);
        }
        effectiveSavePath = '${safeDir.path}/$fileName';
      } catch (_) {}
    }

    try {
      if (task.audioUrl != null && task.audioUrl!.isNotEmpty) {
        await _executeMuxedDownload(task, cancelToken, effectiveSavePath);
      } else {
        await _executeDirectDownload(task, cancelToken, effectiveSavePath);
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e) || e.type == DioExceptionType.cancel) {
        if (_isPaused[task.id] == true) {
          final pausedBytes =
              _pausedBytes[task.id] ?? _lastReceivedBytes[task.id] ?? 0;
          _emitUpdate(
            task.copyWith(
              status: DownloadStatus.paused,
              receivedBytes: pausedBytes,
              savePath: effectiveSavePath,
            ),
          );
        } else {
          _pausedBytes.remove(task.id);
          _emitUpdate(
            task.copyWith(
              status: DownloadStatus.cancelled,
              savePath: effectiveSavePath,
            ),
          );
        }
        return;
      }

      // إزالة رمز الإلغاء قبل إعادة المحاولة حتى لا تُرفض المحاولة
      _cancelTokens.remove(task.id);

      // خطأ شبكة أو خادم — إعادة المحاولة تلقائياً
      if (task.retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: (task.retryCount + 1) * 2));
        await startDownload(
          task.copyWith(
            retryCount: task.retryCount + 1,
            savePath: effectiveSavePath,
          ),
        );
      } else {
        _emitUpdate(
          task.copyWith(
            status: DownloadStatus.failed,
            errorMessage: _mapError(e),
            savePath: effectiveSavePath,
          ),
        );
      }
    } catch (e) {
      _cancelTokens.remove(task.id);

      if (task.retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: (task.retryCount + 1) * 2));
        await startDownload(
          task.copyWith(
            retryCount: task.retryCount + 1,
            savePath: effectiveSavePath,
          ),
        );
      } else {
        _emitUpdate(
          task.copyWith(
            status: DownloadStatus.failed,
            errorMessage: e.toString(),
            savePath: effectiveSavePath,
          ),
        );
      }
    } finally {
      _cancelTokens.remove(task.id);
      _queue.markCompleted(task.id);
      _checkNextInQueue();
    }
  }

  /// تحميل مباشر للبث المدمج (صوت وصورة مسبقاً) أو ملفات الصوت المستقلة
  Future<void> _executeDirectDownload(
    DownloadTask task,
    CancelToken cancelToken,
    String effectiveSavePath,
  ) async {
    final hasResume = _pausedBytes.containsKey(task.id);
    final startByte = _pausedBytes[task.id] ?? 0;
    int latestReceived = startByte;
    int latestTotal = task.totalBytes;

    await dio.download(
      task.url,
      effectiveSavePath,
      cancelToken: cancelToken,
      deleteOnError: false,
      options: Options(
        headers: hasResume ? {'Range': 'bytes=$startByte-'} : null,
        responseType: ResponseType.stream,
        followRedirects: true,
      ),
      onReceiveProgress: (received, total) {
        latestReceived = startByte + received;
        if (total > 0) {
          latestTotal = startByte + total;
        }
        _lastReceivedBytes[task.id] = latestReceived;

        _emitUpdate(
          task.copyWith(
            receivedBytes: latestReceived,
            totalBytes: latestTotal > 0 ? latestTotal : task.totalBytes,
            status: DownloadStatus.downloading,
            savePath: effectiveSavePath,
          ),
        );
      },
    );

    // فهرسة الملف في مشغل الوسائط بالنظام
    await _mediaMuxerService.scanFile(effectiveSavePath);

    // اكتمال التحميل بنجاح
    _pausedBytes.remove(task.id);
    _isPaused.remove(task.id);
    _lastReceivedBytes.remove(task.id);

    final finalTotal = latestTotal > 0 ? latestTotal : latestReceived;
    _emitUpdate(
      task.copyWith(
        status: DownloadStatus.completed,
        completedAt: DateTime.now(),
        receivedBytes: finalTotal,
        totalBytes: finalTotal,
        savePath: effectiveSavePath,
      ),
    );
  }

  /// تحميل الجودات العالية (1080p, 720p...) مع دمج مسار الصوت تلقائياً
  Future<void> _executeMuxedDownload(
    DownloadTask task,
    CancelToken cancelToken,
    String effectiveSavePath,
  ) async {
    final videoTmpPath = '$effectiveSavePath.video.tmp';
    final audioTmpPath = '$effectiveSavePath.audio.tmp';

    int videoStartByte = 0;
    int audioStartByte = 0;
    try {
      final vFile = File(videoTmpPath);
      if (vFile.existsSync()) videoStartByte = vFile.lengthSync();
      final aFile = File(audioTmpPath);
      if (aFile.existsSync()) audioStartByte = aFile.lengthSync();
    } catch (_) {}

    int videoReceived = videoStartByte;
    int videoTotal = 0;
    int audioReceived = audioStartByte;
    int audioTotal = 0;

    void updateCombinedProgress() {
      final totalReceived = videoReceived + audioReceived;
      final totalExpected = (videoTotal > 0 && audioTotal > 0)
          ? (videoTotal + audioTotal)
          : (task.totalBytes > 0 ? task.totalBytes : totalReceived);

      _lastReceivedBytes[task.id] = totalReceived;
      _emitUpdate(
        task.copyWith(
          receivedBytes: totalReceived,
          totalBytes: totalExpected,
          status: DownloadStatus.downloading,
          savePath: effectiveSavePath,
        ),
      );
    }

    // تنزيل مسار الفيديو ومسار الصوت بالتوازي وبأقصى سرعة
    await Future.wait([
      dio.download(
        task.url,
        videoTmpPath,
        cancelToken: cancelToken,
        deleteOnError: false,
        options: Options(
          headers: videoStartByte > 0
              ? {'Range': 'bytes=$videoStartByte-'}
              : null,
          responseType: ResponseType.stream,
          followRedirects: true,
        ),
        onReceiveProgress: (received, total) {
          videoReceived = videoStartByte + received;
          if (total > 0) videoTotal = videoStartByte + total;
          updateCombinedProgress();
        },
      ),
      dio.download(
        task.audioUrl!,
        audioTmpPath,
        cancelToken: cancelToken,
        deleteOnError: false,
        options: Options(
          headers: audioStartByte > 0
              ? {'Range': 'bytes=$audioStartByte-'}
              : null,
          responseType: ResponseType.stream,
          followRedirects: true,
        ),
        onReceiveProgress: (received, total) {
          audioReceived = audioStartByte + received;
          if (total > 0) audioTotal = audioStartByte + total;
          updateCombinedProgress();
        },
      ),
    ]);

    // دمج مسار الصوت ومسار الفيديو عتادياً بدون إعادة ترميز
    await _mediaMuxerService.muxVideoAndAudio(
      videoPath: videoTmpPath,
      audioPath: audioTmpPath,
      outputPath: effectiveSavePath,
    );

    // تنظيف الملفات المؤقتة بعد اكتمال الدمج بنجاح
    try {
      final vFile = File(videoTmpPath);
      if (vFile.existsSync()) vFile.deleteSync();
      final aFile = File(audioTmpPath);
      if (aFile.existsSync()) aFile.deleteSync();
    } catch (_) {}

    // فهرسة الملف في مشغل وسائط النظام
    await _mediaMuxerService.scanFile(effectiveSavePath);

    // اكتمال التحميل بنجاح
    _pausedBytes.remove(task.id);
    _isPaused.remove(task.id);
    _lastReceivedBytes.remove(task.id);

    final finalFile = File(effectiveSavePath);
    final finalSize = finalFile.existsSync()
        ? finalFile.lengthSync()
        : (videoReceived + audioReceived);

    _emitUpdate(
      task.copyWith(
        status: DownloadStatus.completed,
        completedAt: DateTime.now(),
        receivedBytes: finalSize,
        totalBytes: finalSize,
        savePath: effectiveSavePath,
      ),
    );
  }

  void _checkNextInQueue() {
    final nextTask = _queue.processNext();
    if (nextTask != null) {
      startDownload(nextTask);
    }
  }

  /// إيقاف مؤقت للتحميل
  void pauseDownload(String taskId, {int? currentBytes}) {
    _isPaused[taskId] = true;
    if (currentBytes != null) {
      _pausedBytes[taskId] = currentBytes;
    } else if (_lastReceivedBytes.containsKey(taskId)) {
      _pausedBytes[taskId] = _lastReceivedBytes[taskId]!;
    }
    _cancelTokens[taskId]?.cancel('paused');
  }

  /// استئناف التحميل
  Future<void> resumeDownload(DownloadTask task) async {
    int bytesToResume = _pausedBytes[task.id] ?? task.receivedBytes;
    if (task.savePath.isNotEmpty) {
      try {
        if (task.audioUrl != null && task.audioUrl!.isNotEmpty) {
          final vFile = File('${task.savePath}.video.tmp');
          final aFile = File('${task.savePath}.audio.tmp');
          int total = 0;
          if (vFile.existsSync()) total += vFile.lengthSync();
          if (aFile.existsSync()) total += aFile.lengthSync();
          if (total > 0) bytesToResume = total;
        } else {
          final file = File(task.savePath);
          if (file.existsSync()) {
            bytesToResume = file.lengthSync();
          }
        }
      } catch (_) {}
    }
    _pausedBytes[task.id] = bytesToResume;
    await startDownload(
      task.copyWith(
        status: DownloadStatus.downloading,
        receivedBytes: bytesToResume,
      ),
    );
  }

  /// إلغاء التحميل وحذف الملف الجزئي
  void cancelDownload(String taskId, {String? savePath}) {
    _isPaused[taskId] = false;
    _cancelTokens[taskId]?.cancel('cancelled');
    _pausedBytes.remove(taskId);
    _lastReceivedBytes.remove(taskId);
    _queue.removeFromQueue(taskId);

    if (savePath != null && savePath.isNotEmpty) {
      try {
        final file = File(savePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
        final vFile = File('$savePath.video.tmp');
        if (vFile.existsSync()) {
          vFile.deleteSync();
        }
        final aFile = File('$savePath.audio.tmp');
        if (aFile.existsSync()) {
          aFile.deleteSync();
        }
      } catch (_) {}
    }
  }

  /// إعادة المحاولة من البداية
  Future<void> retryDownload(DownloadTask task) async {
    _pausedBytes.remove(task.id);
    _lastReceivedBytes.remove(task.id);
    _isPaused.remove(task.id);

    if (task.savePath.isNotEmpty) {
      try {
        final file = File(task.savePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
        final vFile = File('${task.savePath}.video.tmp');
        if (vFile.existsSync()) {
          vFile.deleteSync();
        }
        final aFile = File('${task.savePath}.audio.tmp');
        if (aFile.existsSync()) {
          aFile.deleteSync();
        }
      } catch (_) {}
    }

    await startDownload(
      task.copyWith(
        status: DownloadStatus.pending,
        receivedBytes: 0,
        retryCount: 0,
        errorMessage: null,
      ),
    );
  }

  int? getPausedBytes(String taskId) => _pausedBytes[taskId];
  bool isDownloading(String taskId) => _cancelTokens.containsKey(taskId);

  void _emitUpdate(DownloadTask task) {
    if (!_progressController.isClosed) {
      _progressController.add(task);
    }
  }

  String _mapError(DioException e) {
    if (e.error is FileSystemException) {
      return 'تعذر حفظ الملف (يرجى التحقق من أذونات التخزين)';
    }
    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'انتهت مهلة الاتصال',
      DioExceptionType.receiveTimeout => 'انتهت مهلة الاستقبال',
      DioExceptionType.sendTimeout => 'انتهت مهلة الإرسال',
      DioExceptionType.connectionError => 'لا يوجد اتصال بالإنترنت',
      DioExceptionType.badResponse =>
        'خطأ من الخادم (${e.response?.statusCode})',
      _ => 'حدث خطأ أثناء التحميل',
    };
  }

  void dispose() {
    for (final token in _cancelTokens.values) {
      token.cancel('disposed');
    }
    _cancelTokens.clear();
    _queue.clear();
    _progressController.close();
  }
}
