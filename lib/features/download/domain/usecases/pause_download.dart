import '../repositories/download_repository.dart';

class PauseDownloadUseCase {
  final DownloadRepository repository;

  PauseDownloadUseCase(this.repository);

  Future<void> call(String taskId) {
    return repository.pauseDownload(taskId);
  }
}
