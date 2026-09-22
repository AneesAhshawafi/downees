import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/video_info.dart';

class VideoInfoSection extends StatelessWidget {
  final VideoInfo videoInfo;

  const VideoInfoSection({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          videoInfo.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Row(
          children: [
            if (videoInfo.channelAvatarUrl.isNotEmpty) ...[
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(videoInfo.channelAvatarUrl),
              ),
              const SizedBox(width: AppDimensions.sm),
            ],
            if (videoInfo.channelName.isNotEmpty) ...[
              Flexible(
                child: Text(
                  videoInfo.channelName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(
                '•',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
              const SizedBox(width: AppDimensions.sm),
            ],
            Text(
              '${videoInfo.formattedViews} views',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

