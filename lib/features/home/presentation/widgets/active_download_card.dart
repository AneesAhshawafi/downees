import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/enums/download_status.dart';
import '../../../download/domain/entities/download_task.dart';

class ActiveDownloadCard extends StatelessWidget {
  final DownloadTask task;
  final VoidCallback? onTogglePause;
  final VoidCallback? onCancel;

  const ActiveDownloadCard({
    super.key,
    required this.task,
    this.onTogglePause,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDownloading = task.status == DownloadStatus.downloading;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.sm),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: Container(
                width: 60,
                height: 48,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: task.thumbnailUrl.isNotEmpty
                    ? Image.network(
                        task.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.video_library_outlined),
                      )
                    : const Icon(Icons.video_library_outlined),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    '${task.platform.displayName} • ${task.quality} • ${task.progressText}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull,
                          ),
                          child: LinearProgressIndicator(
                            value: task.progress > 0 ? task.progress : null,
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        task.progressPercent,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(AppDimensions.xs),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    isDownloading
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  onPressed: onTogglePause,
                ),
                if (onCancel != null) ...[
                  const SizedBox(width: AppDimensions.xs),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(AppDimensions.xs),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: onCancel,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
