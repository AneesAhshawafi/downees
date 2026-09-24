import '../entities/download_task.dart';
import '../repositories/download_repository.dart';

class StartDownloadUseCase {
  final DownloadRepository repository;

  StartDownloadUseCase(this.repository);

  Future<void> call(DownloadTask task) {
    return repository.startDownload(task);
  }
}
