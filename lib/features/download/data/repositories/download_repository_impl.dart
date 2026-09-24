import 'dart:async';
import '../../../../core/enums/download_status.dart';
import '../../../../core/services/download_manager.dart';
import '../../domain/entities/download_task.dart';
import '../../domain/repositories/download_repository.dart';
import '../datasources/download_local_datasource.dart';
import '../models/download_task_model.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadManager downloadManager;
  final DownloadLocalDataSource localDataSource;
  StreamSubscription<DownloadTask>? _progressSubscription;

  DownloadRepositoryImpl({
    required this.downloadManager,
    required this.localDataSource,
  }) {
    _progressSubscription = downloadManager.progressStream.listen((task) {
      localDataSource.saveTask(DownloadTaskModel.fromEntity(task));
    });
  }

  @override
  Stream<DownloadTask> get progressStream => downloadManager.progressStream;

  @override
  Future<List<DownloadTask>> getAllTasks() async {
    final tasks = await localDataSource.getAllTasks();
    // إذا كانت هناك مهمة قيد التحميل وتوقف التطبيق، نحوّلها لـ paused حتى يمكن استئنافها
    return tasks.map((task) {
      if (task.status == DownloadStatus.downloading) {
        final pausedTask = task.copyWith(status: DownloadStatus.paused);
        localDataSource.saveTask(DownloadTaskModel.fromEntity(pausedTask));
        return pausedTask;
      }
      return task;
    }).toList();
  }

  @override
  Future<DownloadTask?> getTask(String id) async {
    return localDataSource.getTask(id);
  }

  @override
  Future<void> startDownload(DownloadTask task) async {
    await localDataSource.saveTask(DownloadTaskModel.fromEntity(task));
    await downloadManager.startDownload(task);
  }

  @override
  Future<void> pauseDownload(String taskId) async {
    downloadManager.pauseDownload(taskId);
    final task = await localDataSource.getTask(taskId);
    if (task != null) {
      await localDataSource.saveTask(
        DownloadTaskModel.fromEntity(
          task.copyWith(status: DownloadStatus.paused),
        ),
      );
    }
  }

  @override
  Future<void> resumeDownload(DownloadTask task) async {
    final updatedTask = task.copyWith(status: DownloadStatus.downloading);
    await localDataSource.saveTask(DownloadTaskModel.fromEntity(updatedTask));
    await downloadManager.resumeDownload(task);
  }

  @override
  Future<void> cancelDownload(String taskId, {String? savePath}) async {
    downloadManager.cancelDownload(taskId, savePath: savePath);
    final task = await localDataSource.getTask(taskId);
    if (task != null) {
      await localDataSource.saveTask(
        DownloadTaskModel.fromEntity(
          task.copyWith(status: DownloadStatus.cancelled),
        ),
      );
    }
  }

  @override
  Future<void> retryDownload(DownloadTask task) async {
    final resetTask = task.copyWith(
      status: DownloadStatus.pending,
      receivedBytes: 0,
      retryCount: 0,
      errorMessage: null,
    );
    await localDataSource.saveTask(DownloadTaskModel.fromEntity(resetTask));
    await downloadManager.retryDownload(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    downloadManager.cancelDownload(taskId);
    await localDataSource.deleteTask(taskId);
  }

  void dispose() {
    _progressSubscription?.cancel();
  }
}

