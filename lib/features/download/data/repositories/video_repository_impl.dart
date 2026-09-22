import '../../../../core/enums/platform_type.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/url_parser.dart';
import '../../domain/entities/video_info.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/demo_datasource.dart';
import '../datasources/video_api_datasource.dart';
import '../datasources/youtube_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;
  final YoutubeRemoteDataSource youtubeDataSource;

  VideoRepositoryImpl({
    required this.remoteDataSource,
    YoutubeRemoteDataSource? youtubeDataSource,
  }) : youtubeDataSource = youtubeDataSource ?? YoutubeRemoteDataSourceImpl();

  @override
  Future<VideoInfo> fetchVideoInfo(String url) async {
    final platform = UrlParser.detectPlatform(url);

    // 1. YouTube direct extraction on-device
    if (platform == PlatformType.youtube) {
      try {
        return await youtubeDataSource.fetchVideoInfo(url);
      } catch (e) {
        // Fallback to backend API if direct extraction fails
        try {
          return await remoteDataSource.fetchVideoInfo(url);
        } catch (_) {
          if (e is ServerException || e is NetworkException) rethrow;
          throw ServerException('تعذر جلب فيديو يوتيوب: $e');
        }
      }
    }

    // 2. Non-YouTube platforms: attempt remote backend API first
    try {
      return await remoteDataSource.fetchVideoInfo(url);
    } catch (e) {
      // If remote backend is unreachable / placeholder, fallback to demo mode
      if (e is NetworkException) {
        return DemoVideoDataSource.getDemoVideo(url);
      }
      rethrow;
    }
  }
}
