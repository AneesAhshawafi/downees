import '../entities/download_task.dart';

abstract class DownloadRepository {
  Stream<DownloadTask> get progressStream;
  Future<List<DownloadTask>> getAllTasks();
  Future<DownloadTask?> getTask(String id);
  Future<void> startDownload(DownloadTask task);
  Future<void> pauseDownload(String taskId);
  Future<void> resumeDownload(DownloadTask task);
  Future<void> cancelDownload(String taskId, {String? savePath});
  Future<void> retryDownload(DownloadTask task);
  Future<void> deleteTask(String taskId);
}

