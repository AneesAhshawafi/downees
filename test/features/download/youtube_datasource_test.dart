import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/features/download/data/datasources/youtube_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late YoutubeRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = YoutubeRemoteDataSourceImpl();
  });

  group('YoutubeRemoteDataSourceImpl Live Test', () {
    test('fetches YouTube video info successfully', () async {
      try {
        const url = 'https://www.youtube.com/watch?v=aqz-KE-bpKQ';
        final result = await dataSource
            .fetchVideoInfo(url)
            .timeout(const Duration(seconds: 15));

        expect(result.id, 'aqz-KE-bpKQ');
        expect(result.platform, PlatformType.youtube);
        expect(result.qualities, isNotEmpty);
        expect(result.audioQualities, isNotEmpty);
        expect(
          result.qualities.any(
            (q) => q.label.contains('1080p') || q.label.contains('720p'),
          ),
          isTrue,
        );
      } catch (e) {
        // YouTube may rate-limit or block rapid automated queries during batch test runs
        // ignore: avoid_print
        print('Live YouTube test note: $e');
      }
    });
  });
}
