import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/features/download/data/datasources/youtube_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late YoutubeRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = YoutubeRemoteDataSourceImpl();
  });

  group('YoutubeRemoteDataSourceImpl Live Test', () {
    test('fetches YouTube Shorts with query parameters successfully', () async {
      const url = 'https://youtube.com/shorts/pZp57oDlVTI?si=FsZvUpSum6n3iBrk';
      final result = await dataSource.fetchVideoInfo(url);

      expect(result.id, 'pZp57oDlVTI');
      expect(result.title, contains('غيرة البنت'));
      expect(result.channelName, contains('يمن شباب'));
      expect(result.platform, PlatformType.youtube);
      expect(result.qualities, isNotEmpty);
      expect(result.audioQualities, isNotEmpty);
    });
  });
}
