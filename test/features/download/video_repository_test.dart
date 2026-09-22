import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/core/errors/exceptions.dart';
import 'package:downees/features/download/data/datasources/video_api_datasource.dart';
import 'package:downees/features/download/data/datasources/youtube_datasource.dart';
import 'package:downees/features/download/data/models/video_info_model.dart';
import 'package:downees/features/download/data/repositories/video_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVideoRemoteDataSource extends Mock implements VideoRemoteDataSource {}

class MockYoutubeRemoteDataSource extends Mock
    implements YoutubeRemoteDataSource {}

void main() {
  late MockVideoRemoteDataSource mockRemoteDataSource;
  late MockYoutubeRemoteDataSource mockYoutubeDataSource;
  late VideoRepositoryImpl repository;

  final testYtVideo = VideoInfoModel(
    id: 'dQw4w9WgXcQ',
    title: 'Never Gonna Give You Up',
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
    platform: PlatformType.youtube,
  );

  final testInstagramVideo = VideoInfoModel(
    id: 'reel123',
    title: 'Instagram Reel',
    thumbnailUrl: 'https://instagram.com/thumb.jpg',
    platform: PlatformType.instagram,
  );

  setUp(() {
    mockRemoteDataSource = MockVideoRemoteDataSource();
    mockYoutubeDataSource = MockYoutubeRemoteDataSource();
    repository = VideoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      youtubeDataSource: mockYoutubeDataSource,
    );
  });

  group('VideoRepositoryImpl', () {
    test('routes YouTube URL to YoutubeRemoteDataSource', () async {
      const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
      when(() => mockYoutubeDataSource.fetchVideoInfo(url))
          .thenAnswer((_) async => testYtVideo);

      final result = await repository.fetchVideoInfo(url);

      expect(result.id, 'dQw4w9WgXcQ');
      expect(result.platform, PlatformType.youtube);
      verify(() => mockYoutubeDataSource.fetchVideoInfo(url)).called(1);
      verifyNever(() => mockRemoteDataSource.fetchVideoInfo(any()));
    });

    test('routes Non-YouTube URL to VideoRemoteDataSource', () async {
      const url = 'https://www.instagram.com/reel/ABC123xyz/';
      when(() => mockRemoteDataSource.fetchVideoInfo(url))
          .thenAnswer((_) async => testInstagramVideo);

      final result = await repository.fetchVideoInfo(url);

      expect(result.id, 'reel123');
      expect(result.platform, PlatformType.instagram);
      verify(() => mockRemoteDataSource.fetchVideoInfo(url)).called(1);
      verifyNever(() => mockYoutubeDataSource.fetchVideoInfo(any()));
    });

    test(
      'falls back to demo video when remoteDataSource throws NetworkException',
      () async {
        const url = 'https://www.instagram.com/reel/ABC123xyz/';
        when(() => mockRemoteDataSource.fetchVideoInfo(url))
            .thenThrow(const NetworkException('Network error'));

        final result = await repository.fetchVideoInfo(url);

        expect(result, isNotNull);
        expect(result.platform, PlatformType.instagram);
        expect(result.qualities, isNotEmpty);
      },
    );
  });
}
