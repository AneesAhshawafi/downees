import '../entities/video_info.dart';
import '../repositories/video_repository.dart';

class FetchVideoInfo {
  final VideoRepository repository;

  FetchVideoInfo(this.repository);

  Future<VideoInfo> call(String url) async {
    return await repository.fetchVideoInfo(url);
  }
}

