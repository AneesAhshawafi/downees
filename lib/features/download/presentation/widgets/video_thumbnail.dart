import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/video_info.dart';

class VideoThumbnail extends StatelessWidget {
  final VideoInfo videoInfo;

  const VideoThumbnail({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: videoInfo.thumbnailUrl.isNotEmpty
                  ? Image.network(
                      videoInfo.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image_outlined, size: 48),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.video_library_outlined, size: 48),
                    ),
            ),
          ),
          if (videoInfo.duration > Duration.zero)
            Container(
              margin: const EdgeInsets.all(AppDimensions.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: AppDimensions.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    videoInfo.formattedDuration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

