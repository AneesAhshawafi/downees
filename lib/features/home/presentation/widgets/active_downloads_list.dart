import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/enums/download_status.dart';
import '../../../download/presentation/bloc/download_bloc.dart';
import '../../../download/presentation/bloc/download_event.dart';
import '../../../download/presentation/bloc/download_state.dart';
import 'active_download_card.dart';

class ActiveDownloadsList extends StatelessWidget {
  const ActiveDownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        final activeDownloads = state.activeTasks;
        if (activeDownloads.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.sm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.downloading, size: AppDimensions.iconSm),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    'Active Downloads (${activeDownloads.length})',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeDownloads.length,
              itemBuilder: (context, index) {
                final task = activeDownloads[index];
                return ActiveDownloadCard(
                  task: task,
                  onTogglePause: () {
                    if (task.status == DownloadStatus.downloading) {
                      context.read<DownloadBloc>().add(PauseDownload(task.id));
                    } else if (task.status == DownloadStatus.paused) {
                      context.read<DownloadBloc>().add(ResumeDownload(task.id));
                    }
                  },
                  onCancel: () {
                    context.read<DownloadBloc>().add(CancelDownload(task.id));
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
