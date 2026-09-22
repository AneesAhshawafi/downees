import 'package:downees/core/enums/platform_type.dart';
import 'package:downees/features/download/data/models/video_info_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoInfoModel', () {
    final sampleJson = {
      'id': 'dQw4w9WgXcQ',
      'title': 'Never Gonna Give You Up',
      'description': 'Music video',
      'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'channel': 'Rick Astley',
      'channel_avatar': 'https://yt3.ggpht.com/avatar.jpg',
      'duration': 212,
      'view_count': 1500000000,
      'upload_date': '2009-10-25T00:00:00Z',
      'platform': 'youtube',
      'formats': [
        {
          'label': '360p',
          'resolution': '640x360',
          'filesize': 12582912,
          'url': 'https://download.com/360.mp4',
          'format': 'mp4',
          'vcodec': 'avc1',
          'acodec': 'mp4a',
        },
        {
          'label': '720p',
          'resolution': '1280x720',
          'filesize': 36700160,
          'url': 'https://download.com/720.mp4',
          'format': 'mp4',
          'vcodec': 'avc1',
          'acodec': 'mp4a',
        },
        {
          'label': 'MP3 128kbps',
          'resolution': null,
          'filesize': 4194304,
          'url': 'https://download.com/audio.mp3',
          'format': 'mp3',
          'vcodec': 'none',
          'acodec': 'mp4a',
        },
      ],
    };

    test('should parse json correctly into VideoInfoModel', () {
      final model = VideoInfoModel.fromJson(sampleJson);

      expect(model.id, 'dQw4w9WgXcQ');
      expect(model.title, 'Never Gonna Give You Up');
      expect(model.channelName, 'Rick Astley');
      expect(model.platform, PlatformType.youtube);
      expect(model.duration, const Duration(seconds: 212));
      expect(model.formattedDuration, '03:32');
      expect(model.formattedViews, '1.5B');
      expect(model.qualities.length, 2);
      expect(model.audioQualities.length, 1);
    });

    test('defaultQuality prefers 720p recommended format', () {
      final model = VideoInfoModel.fromJson(sampleJson);
      final defaultQ = model.defaultQuality;

      expect(defaultQ, isNotNull);
      expect(defaultQ!.label, '720p');
      expect(defaultQ.isRecommended, true);
      expect(defaultQ.fileSizeMB, '35.0');
    });

    test('audio quality has isAudioOnly = true and format mp3', () {
      final model = VideoInfoModel.fromJson(sampleJson);
      final audioQ = model.audioQualities.first;

      expect(audioQ.isAudioOnly, true);
      expect(audioQ.format, 'mp3');
      expect(audioQ.fileSizeMB, '4.0');
    });
  });
}

