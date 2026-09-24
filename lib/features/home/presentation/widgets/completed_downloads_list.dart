import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../download/presentation/bloc/download_bloc.dart';
import '../../../download/presentation/bloc/download_event.dart';
import '../../../download/presentation/bloc/download_state.dart';
import 'completed_download_card.dart';

class CompletedDownloadsList extends StatelessWidget {
  const CompletedDownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        final completedDownloads = state.completedTasks;
        if (completedDownloads.isEmpty) {
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
                  const Icon(Icons.check_circle_outline, size: AppDimensions.iconSm),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    'Completed (${completedDownloads.length})',
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
              itemCount: completedDownloads.length,
              itemBuilder: (context, index) {
                final task = completedDownloads[index];
                return CompletedDownloadCard(
                  task: task,
                  onOpen: () {
                    _openFile(task.savePath);
                  },
                  onDelete: () {
                    context.read<DownloadBloc>().add(DeleteDownload(task.id));
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _openFile(String path) {
    try {
      if (path.isNotEmpty && File(path).existsSync()) {
        Process.run('am', ['start', '-t', 'video/*', '-d', 'file://$path']);
      }
    } catch (_) {}
  }
}
