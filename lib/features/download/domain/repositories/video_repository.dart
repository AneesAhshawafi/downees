import '../entities/video_info.dart';

abstract class VideoRepository {
  Future<VideoInfo> fetchVideoInfo(String url);
}

