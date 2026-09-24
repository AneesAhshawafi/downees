import '../entities/download_task.dart';
import '../repositories/download_repository.dart';

class ResumeDownloadUseCase {
  final DownloadRepository repository;

  ResumeDownloadUseCase(this.repository);

  Future<void> call(DownloadTask task) {
    return repository.resumeDownload(task);
  }
}
