import '../../../../core/utils/url_parser.dart';
import '../models/video_info_model.dart';

class DemoVideoDataSource {
  static VideoInfoModel getDemoVideo(String url) {
    final parsed = UrlParser.parse(url);
    final platform = parsed.platform;

    return VideoInfoModel(
      id: parsed.videoId ?? 'demo_video',
      title: 'فيديو تجريبي من منصة ${platform.displayName}',
      description: 'معاينة تجريبية لاختبار واجهة التحميل واختيار الجودة في Downees',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&auto=format&fit=crop&q=80',
      channelName: '${platform.displayName} Creator',
      channelAvatarUrl: '',
      duration: const Duration(minutes: 2, seconds: 45),
      viewCount: 125000,
      publishDate: DateTime.now().subtract(const Duration(days: 2)),
      platform: platform,
      qualities: const [
        VideoQualityModel(
          label: '360p',
          resolution: '640x360',
          fileSizeBytes: 12582912,
          downloadUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          format: 'mp4',
          hasAudio: true,
          isAudioOnly: false,
        ),
        VideoQualityModel(
          label: '720p',
          resolution: '1280x720',
          fileSizeBytes: 36700160,
          downloadUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          format: 'mp4',
          hasAudio: true,
          isAudioOnly: false,
        ),
        VideoQualityModel(
          label: '1080p',
          resolution: '1920x1080',
          fileSizeBytes: 85983232,
          downloadUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          format: 'mp4',
          hasAudio: true,
          isAudioOnly: false,
        ),
      ],
      audioQualities: const [
        VideoQualityModel(
          label: '128 kbps',
          resolution: null,
          fileSizeBytes: 3145728,
          downloadUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          format: 'mp3',
          hasAudio: true,
          isAudioOnly: true,
        ),
        VideoQualityModel(
          label: '256 kbps',
          resolution: null,
          fileSizeBytes: 6291456,
          downloadUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          format: 'mp3',
          hasAudio: true,
          isAudioOnly: true,
        ),
      ],
    );
  }
}
