import '../entities/download_task.dart';
import '../repositories/download_repository.dart';

class RetryDownloadUseCase {
  final DownloadRepository repository;

  RetryDownloadUseCase(this.repository);

  Future<void> call(DownloadTask task) {
    return repository.retryDownload(task);
  }
}
