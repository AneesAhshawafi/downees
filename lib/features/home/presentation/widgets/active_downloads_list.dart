import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'active_download_card.dart';

class ActiveDownloadsList extends StatelessWidget {
  const ActiveDownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) => prev.activeDownloads != curr.activeDownloads,
      builder: (context, state) {
        if (state.activeDownloads.isEmpty) {
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
                    'Active Downloads (${state.activeDownloads.length})',
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
              itemCount: state.activeDownloads.length,
              itemBuilder: (context, index) {
                final task = state.activeDownloads[index];
                return ActiveDownloadCard(task: task);
              },
            ),
          ],
        );
      },
    );
  }
}

