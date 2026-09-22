import '../../../../core/enums/platform_type.dart';
import '../../domain/entities/video_info.dart';
import '../../domain/entities/video_quality.dart';

class VideoQualityModel extends VideoQuality {
  const VideoQualityModel({
    required super.label,
    super.resolution,
    required super.fileSizeBytes,
    required super.downloadUrl,
    required super.format,
    super.hasAudio = true,
    super.isAudioOnly = false,
  });

  factory VideoQualityModel.fromJson(Map<String, dynamic> json) {
    final vcodec = json['vcodec'] as String?;
    final acodec = json['acodec'] as String?;
    final isAudio = (vcodec == null || vcodec == 'none') &&
        (acodec != null && acodec != 'none');

    return VideoQualityModel(
      label: json['label'] as String? ?? (isAudio ? 'Audio' : 'Video'),
      resolution: json['resolution'] as String?,
      fileSizeBytes: (json['filesize'] as num?)?.toInt() ??
          (json['file_size'] as num?)?.toInt() ??
          0,
      downloadUrl: json['url'] as String? ?? '',
      format: json['format'] as String? ?? (isAudio ? 'mp3' : 'mp4'),
      hasAudio: json['has_audio'] as bool? ?? (acodec != null && acodec != 'none'),
      isAudioOnly: isAudio || (json['is_audio_only'] as bool? ?? false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'resolution': resolution,
      'filesize': fileSizeBytes,
      'url': downloadUrl,
      'format': format,
      'has_audio': hasAudio,
      'is_audio_only': isAudioOnly,
    };
  }
}

class VideoInfoModel extends VideoInfo {
  const VideoInfoModel({
    required super.id,
    required super.title,
    super.description = '',
    required super.thumbnailUrl,
    super.channelName = '',
    super.channelAvatarUrl = '',
    super.duration = Duration.zero,
    super.viewCount = 0,
    super.publishDate,
    required super.platform,
    super.qualities = const [],
    super.audioQualities = const [],
  });

  factory VideoInfoModel.fromJson(Map<String, dynamic> json) {
    final rawFormats = (json['formats'] as List<dynamic>?) ?? [];

    final allFormats = rawFormats
        .whereType<Map<String, dynamic>>()
        .map((f) => VideoQualityModel.fromJson(f))
        .toList();

    final videoQualities =
        allFormats.where((f) => !f.isAudioOnly).toList();
    final audioQualities =
        allFormats.where((f) => f.isAudioOnly).toList();

    final platformStr = (json['platform'] as String?)?.toLowerCase() ?? '';
    final platform = PlatformType.values.firstWhere(
      (p) => p.name.toLowerCase() == platformStr,
      orElse: () => PlatformType.unknown,
    );

    final durationSeconds = (json['duration'] as num?)?.toInt() ?? 0;

    DateTime? publishDate;
    final uploadDateStr = json['upload_date'] as String?;
    if (uploadDateStr != null && uploadDateStr.isNotEmpty) {
      publishDate = DateTime.tryParse(uploadDateStr);
    }

    return VideoInfoModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      thumbnailUrl: json['thumbnail'] as String? ??
          json['thumbnail_url'] as String? ??
          '',
      channelName: json['channel'] as String? ??
          json['channel_name'] as String? ??
          json['uploader'] as String? ??
          '',
      channelAvatarUrl: json['channel_avatar'] as String? ?? '',
      duration: Duration(seconds: durationSeconds),
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      publishDate: publishDate,
      platform: platform,
      qualities: videoQualities,
      audioQualities: audioQualities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnailUrl,
      'channel': channelName,
      'channel_avatar': channelAvatarUrl,
      'duration': duration.inSeconds,
      'view_count': viewCount,
      'upload_date': publishDate?.toIso8601String(),
      'platform': platform.name,
      'formats': [
        ...qualities.map((q) => (q as VideoQualityModel).toJson()),
        ...audioQualities.map((q) => (q as VideoQualityModel).toJson()),
      ],
    };
  }
}

