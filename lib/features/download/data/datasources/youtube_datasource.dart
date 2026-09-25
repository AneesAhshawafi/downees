import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/enums/platform_type.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/url_parser.dart';
import '../models/video_info_model.dart';

abstract class YoutubeRemoteDataSource {
  Future<VideoInfoModel> fetchVideoInfo(String url);
}

class YoutubeRemoteDataSourceImpl implements YoutubeRemoteDataSource {
  @override
  Future<VideoInfoModel> fetchVideoInfo(String url) async {
    final yt = YoutubeExplode();
    try {
      final parsed = UrlParser.parse(url);
      final videoIdOrUrl = parsed.videoId ?? url;
      final video = await yt.videos.get(videoIdOrUrl);
      final manifest = await yt.videos.streamsClient.getManifest(video.id);

      // Find best audio stream for muxing (prefer MP4 container AAC audio for native MediaMuxer)
      final sortedAudioForMux = manifest.audioOnly.toList()
        ..sort((a, b) {
          if (a.container.name == 'mp4' && b.container.name != 'mp4') return -1;
          if (a.container.name != 'mp4' && b.container.name == 'mp4') return 1;
          return b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond);
        });
      final defaultAudioStream = sortedAudioForMux.isNotEmpty
          ? sortedAudioForMux.first
          : null;

      final qualitiesMap = <String, VideoQualityModel>{};

      // 1. إضافة البث المدمج (صوت وصورة معاً في ملف واحد)
      for (final stream in manifest.muxed) {
        final label = stream.qualityLabel;
        qualitiesMap[label] = VideoQualityModel(
          label: label,
          resolution:
              '${stream.videoResolution.width}x${stream.videoResolution.height}',
          fileSizeBytes: stream.size.totalBytes,
          downloadUrl: stream.url.toString(),
          format: stream.container.name,
          hasAudio: true,
          isAudioOnly: false,
          audioDownloadUrl: null, // مدمج بالفعل
        );
      }

      // 2. إضافة الجودات العالية (1080p, 720p, 480p, إلخ) مع ربطها بمسار الصوت للدمج
      final sortedVideoOnly = manifest.videoOnly.toList()
        ..sort((a, b) {
          if (a.container.name == 'mp4' && b.container.name != 'mp4') {
            return -1;
          }
          if (a.container.name != 'mp4' && b.container.name == 'mp4') {
            return 1;
          }
          return b.size.totalBytes.compareTo(a.size.totalBytes);
        });

      for (final stream in sortedVideoOnly) {
        final label = stream.qualityLabel;
        // إذا كانت الجودة موجودة بالفعل كبث مدمج لا نستبدلها
        if (!qualitiesMap.containsKey(label)) {
          final audioBytes = defaultAudioStream?.size.totalBytes ?? 0;
          qualitiesMap[label] = VideoQualityModel(
            label: label,
            resolution:
                '${stream.videoResolution.width}x${stream.videoResolution.height}',
            fileSizeBytes: stream.size.totalBytes + audioBytes,
            downloadUrl: stream.url.toString(),
            format: 'mp4',
            hasAudio: true,
            isAudioOnly: false,
            audioDownloadUrl: defaultAudioStream?.url.toString(),
          );
        }
      }

      // Sort video qualities in descending resolution order
      const standardOrder = [
        '2160p',
        '1440p',
        '1080p',
        '720p',
        '480p',
        '360p',
        '240p',
        '144p',
      ];

      final qualities = qualitiesMap.values.toList()
        ..sort((a, b) {
          int indexA = standardOrder.indexWhere((o) => a.label.contains(o));
          int indexB = standardOrder.indexWhere((o) => b.label.contains(o));
          if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
          if (indexA != -1) return -1;
          if (indexB != -1) return 1;
          return b.fileSizeBytes.compareTo(a.fileSizeBytes);
        });

      // 3. مسارات الصوت (Audio streams)
      final audioQualities = <VideoQualityModel>[];
      if (manifest.muxed.isNotEmpty) {
        final bestMuxed = manifest.muxed.first;
        audioQualities.add(
          VideoQualityModel(
            label: '128 kbps (Audio)',
            resolution: null,
            fileSizeBytes: (bestMuxed.size.totalBytes * 0.25).round(),
            downloadUrl: bestMuxed.url.toString(),
            format: 'm4a',
            hasAudio: true,
            isAudioOnly: true,
          ),
        );
      }

      final seenAudioBitrates = <int>{};
      final sortedAudioStreams = manifest.audioOnly.toList()
        ..sort(
          (a, b) => b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond),
        );

      for (final stream in sortedAudioStreams) {
        final kbps = (stream.bitrate.bitsPerSecond / 1000).round();
        if (!seenAudioBitrates.contains(kbps)) {
          seenAudioBitrates.add(kbps);
          audioQualities.add(
            VideoQualityModel(
              label: '$kbps kbps',
              resolution: null,
              fileSizeBytes: stream.size.totalBytes,
              downloadUrl: stream.url.toString(),
              format: stream.container.name == 'mp4'
                  ? 'm4a'
                  : stream.container.name,
              hasAudio: true,
              isAudioOnly: true,
            ),
          );
        }
      }

      // Fallback quality if none discovered
      if (qualities.isEmpty) {
        qualities.add(
          const VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            fileSizeBytes: 25000000,
            downloadUrl: '',
            format: 'mp4',
            hasAudio: true,
            isAudioOnly: false,
          ),
        );
      }

      return VideoInfoModel(
        id: video.id.value,
        title: video.title,
        description: video.description,
        thumbnailUrl: video.thumbnails.highResUrl,
        channelName: video.author,
        channelAvatarUrl: '',
        duration: video.duration ?? Duration.zero,
        viewCount: video.engagement.viewCount,
        publishDate: video.uploadDate,
        platform: PlatformType.youtube,
        qualities: qualities,
        audioQualities: audioQualities,
      );
    } on VideoUnplayableException catch (e) {
      throw ServerException('الفيديو غير متاح للتشغيل: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('فشل في جلب معلومات يوتيوب: $e');
    } finally {
      yt.close();
    }
  }
}
