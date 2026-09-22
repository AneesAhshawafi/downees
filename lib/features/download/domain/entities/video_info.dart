import 'package:equatable/equatable.dart';

import '../../../../core/enums/platform_type.dart';
import 'video_quality.dart';

class VideoInfo extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelName;
  final String channelAvatarUrl;
  final Duration duration;
  final int viewCount;
  final DateTime? publishDate;
  final PlatformType platform;
  final List<VideoQuality> qualities;
  final List<VideoQuality> audioQualities;

  const VideoInfo({
    required this.id,
    required this.title,
    this.description = '',
    required this.thumbnailUrl,
    this.channelName = '',
    this.channelAvatarUrl = '',
    this.duration = Duration.zero,
    this.viewCount = 0,
    this.publishDate,
    required this.platform,
    this.qualities = const [],
    this.audioQualities = const [],
  });

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedViews {
    if (viewCount >= 1000000000) {
      return '${(viewCount / 1000000000).toStringAsFixed(1)}B';
    }
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    }
    if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  VideoQuality? get defaultQuality {
    if (qualities.isEmpty) return null;
    for (final quality in qualities) {
      if (quality.isRecommended) return quality;
    }
    return qualities.first;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    thumbnailUrl,
    channelName,
    channelAvatarUrl,
    duration,
    viewCount,
    publishDate,
    platform,
    qualities,
    audioQualities,
  ];
}
