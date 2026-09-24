import 'dart:async';
import 'dart:io';
import 'dart:math' show min;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../features/download/domain/entities/download_task.dart';
import '../enums/download_status.dart';
import '../enums/platform_type.dart';
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
    debugPrint(
      '📥 [Downees] startDownload: id=${task.id}, quality=${task.quality}',
    );
    debugPrint(
      '📥 [Downees] URL: ${task.url.substring(0, min(80, task.url.length))}...',
    );
    debugPrint(
      '📥 [Downees] audioUrl: ${task.audioUrl != null ? "present" : "null"}',
    );
    debugPrint('📥 [Downees] savePath: ${task.savePath}');

    // إذا كانت المهمة قيد التحميل بالفعل لا نبدأها مرة أخرى
    if (_cancelTokens.containsKey(task.id)) {
      debugPrint('⏭️ [Downees] Already downloading, skipping');
      return;
    }

    // التحقق من حدود التزامن
    if (!_queue.canStartNext && !_queue.isActive(task.id)) {
      _queue.enqueue(task);
      _emitUpdate(task.copyWith(status: DownloadStatus.pending));
      debugPrint(
        '⏳ [Downees] Queued (active: ${_queue.activeCount}, pending: ${_queue.pendingCount})',
      );
      return;
    }

    _queue.markActive(task.id);
    await _executeDownload(task);
  }

  Future<void> _executeDownload(DownloadTask task) async {
    String effectiveSavePath = task.savePath;

    // تحضير مسار الحفظ (مرة واحدة)
    try {
      if (effectiveSavePath.isNotEmpty) {
        final parentDir = File(effectiveSavePath).parent;
        if (!parentDir.existsSync()) {
          parentDir.createSync(recursive: true);
        }
      }
    } catch (e) {
      debugPrint('⚠️ [Downees] Cannot create save dir: $e, using fallback');
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

    // حلقة إعادة المحاولات (بدلاً من الاستدعاء العودي)
    for (int attempt = task.retryCount; attempt <= maxRetries; attempt++) {
      final cancelToken = CancelToken();
      _cancelTokens[task.id] = cancelToken;
      _isPaused[task.id] = false;

      _emitUpdate(
        task.copyWith(
          status: DownloadStatus.downloading,
          savePath: effectiveSavePath,
        ),
      );

      try {
        final isYouTube = task.platform == PlatformType.youtube &&
            (task.url.contains('googlevideo.com') ||
                task.url.contains('youtube.com')) &&
            !task.url.contains('example.com');

        if (isYouTube) {
          if (task.audioUrl != null && task.audioUrl!.isNotEmpty) {
            debugPrint(
              '🔀 [Downees] YouTube Muxed download (attempt ${attempt + 1}/${maxRetries + 1})',
            );
            await _executeYoutubeMuxedDownload(
              task,
              cancelToken,
              effectiveSavePath,
            );
          } else {
            debugPrint(
              '⬇️ [Downees] YouTube Direct download (attempt ${attempt + 1}/${maxRetries + 1})',
            );
            await _executeYoutubeDirectDownload(
              task,
              cancelToken,
              effectiveSavePath,
            );
          }
        } else {
          if (task.audioUrl != null && task.audioUrl!.isNotEmpty) {
            debugPrint(
              '🔀 [Downees] Muxed download (attempt ${attempt + 1}/${maxRetries + 1})',
            );
            await _executeMuxedDownload(task, cancelToken, effectiveSavePath);
          } else {
            debugPrint(
              '⬇️ [Downees] Direct download (attempt ${attempt + 1}/${maxRetries + 1})',
            );
            await _executeDirectDownload(task, cancelToken, effectiveSavePath);
          }
        }
        // نجح التحميل — نخرج من الحلقة
        debugPrint('✅ [Downees] Download completed: ${task.id}');
        break;
      } on DioException catch (e) {
        if (CancelToken.isCancel(e) || e.type == DioExceptionType.cancel) {
          if (_isPaused[task.id] == true) {
            final pausedBytes =
                _pausedBytes[task.id] ?? _lastReceivedBytes[task.id] ?? 0;
            debugPrint('⏸️ [Downees] Download paused at $pausedBytes bytes');
            _emitUpdate(
              task.copyWith(
                status: DownloadStatus.paused,
                receivedBytes: pausedBytes,
                savePath: effectiveSavePath,
              ),
            );
          } else {
            _pausedBytes.remove(task.id);
            debugPrint('🚫 [Downees] Download cancelled');
            _emitUpdate(
              task.copyWith(
                status: DownloadStatus.cancelled,
                savePath: effectiveSavePath,
              ),
            );
          }
          // تنظيف وخروج — لا retry عند الإيقاف/الإلغاء
          _cancelTokens.remove(task.id);
          _queue.markCompleted(task.id);
          _checkNextInQueue();
          return;
        }

        _cancelTokens.remove(task.id);
        debugPrint(
          '❌ [Downees] DioException (attempt ${attempt + 1}/${maxRetries + 1}): ${e.type}',
        );
        debugPrint(
          '❌ [Downees] Status: ${e.response?.statusCode}, Message: ${e.message}',
        );

        if (attempt < maxRetries) {
          final delay = Duration(seconds: (attempt + 1) * 2);
          debugPrint('🔄 [Downees] Retrying in ${delay.inSeconds}s...');
          _emitUpdate(
            task.copyWith(
              status: DownloadStatus.downloading,
              errorMessage:
                  'إعادة المحاولة ${attempt + 2}/${maxRetries + 1}...',
              savePath: effectiveSavePath,
            ),
          );
          await Future.delayed(delay);
          continue;
        }

        debugPrint('💀 [Downees] All retries exhausted, marking as failed');
        _emitUpdate(
          task.copyWith(
            status: DownloadStatus.failed,
            errorMessage: _mapError(e),
            savePath: effectiveSavePath,
          ),
        );
      } catch (e) {
        _cancelTokens.remove(task.id);
        debugPrint(
          '❌ [Downees] Error (attempt ${attempt + 1}/${maxRetries + 1}): $e',
        );

        if (attempt < maxRetries) {
          final delay = Duration(seconds: (attempt + 1) * 2);
          debugPrint('🔄 [Downees] Retrying in ${delay.inSeconds}s...');
          await Future.delayed(delay);
          continue;
        }

        debugPrint('💀 [Downees] All retries exhausted, marking as failed');
        _emitUpdate(
          task.copyWith(
            status: DownloadStatus.failed,
            errorMessage: e.toString(),
            savePath: effectiveSavePath,
          ),
        );
      }
    }

    // تنظيف — يُنفذ مرة واحدة فقط
    _cancelTokens.remove(task.id);
    _queue.markCompleted(task.id);
    _checkNextInQueue();
  }

  /// تحميل مباشر عبر YoutubeExplode لتجنب حظر الخادم 403
  Future<void> _executeYoutubeDirectDownload(
    DownloadTask task,
    CancelToken cancelToken,
    String effectiveSavePath,
  ) async {
    final yt = YoutubeExplode();
    try {
      final videoIdOrUrl =
          task.originalUrl.isNotEmpty ? task.originalUrl : task.url;
      final videoId = VideoId(videoIdOrUrl);
      final manifest = await yt.videos.streamsClient.getManifest(videoId);

      StreamInfo? stream;
      if (task.format == 'm4a' || task.format == 'mp3') {
        final sortedAudio = manifest.audioOnly.toList()
          ..sort((a, b) =>
              b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond));
        stream = sortedAudio.where((a) => a.container.name == 'mp4').firstOrNull ??
            (sortedAudio.isNotEmpty ? sortedAudio.first : null);
      } else {
        stream = manifest.muxed
                .where((s) => s.qualityLabel.contains(task.quality))
                .firstOrNull ??
            (manifest.muxed.isNotEmpty ? manifest.muxed.first : null);
      }

      if (stream == null) {
        throw Exception('لم يتم العثور على بث مناسب للفيديو');
      }

      final file = File(effectiveSavePath);
      final sink = file.openWrite();
      int receivedBytes = 0;
      final totalBytes = stream.size.totalBytes > 0
          ? stream.size.totalBytes
          : task.totalBytes;

      try {
        await for (final chunk in yt.videos.streamsClient.get(stream)) {
          if (cancelToken.isCancelled) {
            break;
          }
          sink.add(chunk);
          receivedBytes += chunk.length;
          _lastReceivedBytes[task.id] = receivedBytes;
          _emitUpdate(
            task.copyWith(
              receivedBytes: receivedBytes,
              totalBytes: totalBytes,
              status: DownloadStatus.downloading,
              savePath: effectiveSavePath,
            ),
          );
        }
      } finally {
        await sink.flush();
        await sink.close();
      }

      if (cancelToken.isCancelled) {
        if (_isPaused[task.id] == true) {
          _emitUpdate(
            task.copyWith(
              status: DownloadStatus.paused,
              receivedBytes: receivedBytes,
            ),
          );
        } else {
          _emitUpdate(task.copyWith(status: DownloadStatus.cancelled));
        }
        return;
      }

      await _mediaMuxerService.scanFile(effectiveSavePath);

      _pausedBytes.remove(task.id);
      _isPaused.remove(task.id);
      _lastReceivedBytes.remove(task.id);

      _emitUpdate(
        task.copyWith(
          status: DownloadStatus.completed,
          completedAt: DateTime.now(),
          receivedBytes: receivedBytes,
          totalBytes: receivedBytes,
          savePath: effectiveSavePath,
        ),
      );
    } finally {
      yt.close();
    }
  }

  /// تحميل الجودات العالية (1080p, 720p) ودمج الصوت عبر YoutubeExplode + MediaMuxer
  Future<void> _executeYoutubeMuxedDownload(
    DownloadTask task,
    CancelToken cancelToken,
    String effectiveSavePath,
  ) async {
    final yt = YoutubeExplode();
    final videoTmpPath = '$effectiveSavePath.video.tmp';
    final audioTmpPath = '$effectiveSavePath.audio.tmp';

    try {
      final videoIdOrUrl =
          task.originalUrl.isNotEmpty ? task.originalUrl : task.url;
      final videoId = VideoId(videoIdOrUrl);
      final manifest = await yt.videos.streamsClient.getManifest(videoId);

      final matchingVideos = manifest.videoOnly
          .where((s) => s.qualityLabel.contains(task.quality))
          .toList()
        ..sort((a, b) {
          if (a.container.name == 'mp4' && b.container.name != 'mp4') return -1;
          if (a.container.name != 'mp4' && b.container.name == 'mp4') return 1;
          return b.size.totalBytes.compareTo(a.size.totalBytes);
        });

      final videoStream = matchingVideos.isNotEmpty
          ? matchingVideos.first
          : manifest.videoOnly.first;

      final sortedAudio = manifest.audioOnly.toList()
        ..sort((a, b) {
          if (a.container.name == 'mp4' && b.container.name != 'mp4') return -1;
          if (a.container.name != 'mp4' && b.container.name == 'mp4') return 1;
          return b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond);
        });
      final audioStream = sortedAudio.first;

      final totalExpected =
          videoStream.size.totalBytes + audioStream.size.totalBytes;
      int videoReceived = 0;
      int audioReceived = 0;

      void updateProgress() {
        final totalReceived = videoReceived + audioReceived;
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

      // 1. تنزيل مسار الفيديو
      debugPrint(
        '📥 [Downees] Streaming YouTube video (${videoStream.qualityLabel}, ${videoStream.container.name})...',
      );
      final vFile = File(videoTmpPath);
      final vSink = vFile.openWrite();
      try {
        await for (final chunk in yt.videos.streamsClient.get(videoStream)) {
          if (cancelToken.isCancelled) break;
          vSink.add(chunk);
          videoReceived += chunk.length;
          updateProgress();
        }
      } finally {
        await vSink.flush();
        await vSink.close();
      }

      if (cancelToken.isCancelled) {
        if (_isPaused[task.id] == true) {
          _emitUpdate(
            task.copyWith(
              status: DownloadStatus.paused,
              receivedBytes: videoReceived,
            ),
          );
        } else {
          _emitUpdate(task.copyWith(status: DownloadStatus.cancelled));
        }
        return;
      }

      // 2. تنزيل مسار الصوت
      debugPrint(
        '📥 [Downees] Streaming YouTube audio (${audioStream.bitrate}, ${audioStream.container.name})...',
      );
      final aFile = File(audioTmpPath);
      final aSink = aFile.openWrite();
      try {
        await for (final chunk in yt.videos.streamsClient.get(audioStream)) {
          if (cancelToken.isCancelled) break;
          aSink.add(chunk);
          audioReceived += chunk.length;
          updateProgress();
        }
      } finally {
        await aSink.flush();
        await aSink.close();
      }

      if (cancelToken.isCancelled) {
        if (_isPaused[task.id] == true) {
          _emitUpdate(
            task.copyWith(
              status: DownloadStatus.paused,
              receivedBytes: videoReceived + audioReceived,
            ),
          );
        } else {
          _emitUpdate(task.copyWith(status: DownloadStatus.cancelled));
        }
        return;
      }

      // 3. دمج الفيديو والصوت عتادياً عبر MediaMuxer
      debugPrint('🔀 [Downees] Muxing video and audio with MediaMuxer...');
      await _mediaMuxerService.muxVideoAndAudio(
        videoPath: videoTmpPath,
        audioPath: audioTmpPath,
        outputPath: effectiveSavePath,
      );

      // تنظيف الملفات المؤقتة
      try {
        if (vFile.existsSync()) vFile.deleteSync();
        if (aFile.existsSync()) aFile.deleteSync();
      } catch (_) {}

      // 4. فهرسة الملف في وسائط النظام
      await _mediaMuxerService.scanFile(effectiveSavePath);

      _pausedBytes.remove(task.id);
      _isPaused.remove(task.id);
      _lastReceivedBytes.remove(task.id);

      final finalFile = File(effectiveSavePath);
      final finalSize = finalFile.existsSync()
          ? finalFile.lengthSync()
          : totalExpected;

      debugPrint('🎉 [Downees] YouTube Muxed Download Completed Successfully!');
      _emitUpdate(
        task.copyWith(
          status: DownloadStatus.completed,
          completedAt: DateTime.now(),
          receivedBytes: finalSize,
          totalBytes: finalSize,
          savePath: effectiveSavePath,
        ),
      );
    } finally {
      yt.close();
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
