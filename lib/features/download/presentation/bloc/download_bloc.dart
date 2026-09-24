import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/download_status.dart';
import '../../../../core/services/file_namer.dart';
import '../../domain/entities/download_task.dart';
import '../../domain/repositories/download_repository.dart';
import '../../domain/usecases/cancel_download.dart';
import '../../domain/usecases/pause_download.dart';
import '../../domain/usecases/resume_download.dart';
import '../../domain/usecases/retry_download.dart';
import '../../domain/usecases/start_download.dart';
import 'download_event.dart';
import 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadRepository downloadRepository;
  final StartDownloadUseCase startDownloadUseCase;
  final PauseDownloadUseCase pauseDownloadUseCase;
  final ResumeDownloadUseCase resumeDownloadUseCase;
  final CancelDownloadUseCase cancelDownloadUseCase;
  final RetryDownloadUseCase retryDownloadUseCase;

  StreamSubscription<DownloadTask>? _progressSubscription;

  DownloadBloc({
    required this.downloadRepository,
    required this.startDownloadUseCase,
    required this.pauseDownloadUseCase,
    required this.resumeDownloadUseCase,
    required this.cancelDownloadUseCase,
    required this.retryDownloadUseCase,
  }) : super(const DownloadState()) {
    on<LoadDownloads>(_onLoadDownloads);
    on<StartNewDownload>(_onStartNewDownload);
    on<PauseDownload>(_onPauseDownload);
    on<ResumeDownload>(_onResumeDownload);
    on<CancelDownload>(_onCancelDownload);
    on<RetryDownload>(_onRetryDownload);
    on<DeleteDownload>(_onDeleteDownload);
    on<DownloadProgressUpdated>(_onDownloadProgressUpdated);

    _progressSubscription = downloadRepository.progressStream.listen((task) {
      add(DownloadProgressUpdated(task));
    });
  }

  Future<void> _onLoadDownloads(
    LoadDownloads event,
    Emitter<DownloadState> emit,
  ) async {
    final tasksList = await downloadRepository.getAllTasks();
    final tasksMap = <String, DownloadTask>{};
    for (final task in tasksList) {
      tasksMap[task.id] = task;
    }
    emit(state.copyWith(tasks: tasksMap));
  }

  Future<void> _onStartNewDownload(
    StartNewDownload event,
    Emitter<DownloadState> emit,
  ) async {
    final fileName = FileNamer.generateFileName(
      title: event.videoInfo.title,
      quality: event.quality.label,
      format: event.quality.format,
      platform: event.videoInfo.platform,
    );

    final savePath = await FileNamer.getFullSavePath(fileName: fileName);
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final task = DownloadTask(
      id: id,
      url: event.quality.downloadUrl,
      originalUrl: event.videoInfo.id,
      title: event.videoInfo.title,
      thumbnailUrl: event.videoInfo.thumbnailUrl,
      platform: event.videoInfo.platform,
      quality: event.quality.label,
      format: event.quality.format,
      totalBytes: event.quality.fileSizeBytes,
      receivedBytes: 0,
      status: DownloadStatus.pending,
      savePath: savePath,
      createdAt: DateTime.now(),
    );

    final updatedTasks = Map<String, DownloadTask>.from(state.tasks)
      ..[task.id] = task;
    emit(state.copyWith(tasks: updatedTasks));

    await startDownloadUseCase(task);
  }

  Future<void> _onPauseDownload(
    PauseDownload event,
    Emitter<DownloadState> emit,
  ) async {
    await pauseDownloadUseCase(event.taskId);
    final task = state.tasks[event.taskId];
    if (task != null) {
      final updated = task.copyWith(status: DownloadStatus.paused);
      final updatedTasks = Map<String, DownloadTask>.from(state.tasks)
        ..[task.id] = updated;
      emit(state.copyWith(tasks: updatedTasks));
    }
  }

  Future<void> _onResumeDownload(
    ResumeDownload event,
    Emitter<DownloadState> emit,
  ) async {
    final task = state.tasks[event.taskId];
    if (task != null) {
      await resumeDownloadUseCase(task);
    }
  }

  Future<void> _onCancelDownload(
    CancelDownload event,
    Emitter<DownloadState> emit,
  ) async {
    final task = state.tasks[event.taskId];
    await cancelDownloadUseCase(event.taskId, savePath: task?.savePath);
    if (task != null) {
      final updated = task.copyWith(status: DownloadStatus.cancelled);
      final updatedTasks = Map<String, DownloadTask>.from(state.tasks)
        ..[task.id] = updated;
      emit(state.copyWith(tasks: updatedTasks));
    }
  }

  Future<void> _onRetryDownload(
    RetryDownload event,
    Emitter<DownloadState> emit,
  ) async {
    final task = state.tasks[event.taskId];
    if (task != null) {
      await retryDownloadUseCase(task);
    }
  }

  Future<void> _onDeleteDownload(
    DeleteDownload event,
    Emitter<DownloadState> emit,
  ) async {
    await downloadRepository.deleteTask(event.taskId);
    final updatedTasks = Map<String, DownloadTask>.from(state.tasks)
      ..remove(event.taskId);
    emit(state.copyWith(tasks: updatedTasks));
  }

  void _onDownloadProgressUpdated(
    DownloadProgressUpdated event,
    Emitter<DownloadState> emit,
  ) {
    final updatedTasks = Map<String, DownloadTask>.from(state.tasks)
      ..[event.task.id] = event.task;
    emit(state.copyWith(tasks: updatedTasks));
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }
}
