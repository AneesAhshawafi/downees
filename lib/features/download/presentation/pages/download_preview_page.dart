import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../bloc/preview_bloc.dart';
import '../bloc/preview_event.dart';
import '../bloc/preview_state.dart';
import '../widgets/download_start_button.dart';
import '../widgets/format_toggle.dart';
import '../widgets/preview_shimmer_skeleton.dart';
import '../widgets/quality_selector.dart';
import '../widgets/video_info_section.dart';
import '../widgets/video_thumbnail.dart';

class DownloadPreviewPage extends StatelessWidget {
  final String url;

  const DownloadPreviewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<PreviewBloc>()..add(FetchVideoInfoEvent(url)),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n?.preview ?? 'Preview')),
        body: _DownloadPreviewView(url: url),
      ),
    );
  }
}

class _DownloadPreviewView extends StatelessWidget {
  final String url;

  const _DownloadPreviewView({required this.url});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<PreviewBloc, PreviewState>(
      listener: (context, state) {
        if (state.downloadStatus.name == 'downloading') {
          AppSnackBar.showSuccess(
            context,
            'Starting download: ${state.videoInfo?.title ?? ""}',
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const PreviewShimmerSkeleton();
        }

        if (state.error != null) {
          return AppErrorWidget(
            message: state.error!,
            onRetry: () {
              context.read<PreviewBloc>().add(FetchVideoInfoEvent(url));
            },
          );
        }

        final videoInfo = state.videoInfo;
        if (videoInfo == null) {
          return const Center(child: Text('No video information found'));
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VideoThumbnail(videoInfo: videoInfo),
                      const SizedBox(height: AppDimensions.md),
                      VideoInfoSection(videoInfo: videoInfo),
                      const SizedBox(height: AppDimensions.lg),
                      FormatToggle(
                        isAudioOnly: state.isAudioOnly,
                        onFormatChanged: (isAudio) {
                          context.read<PreviewBloc>().add(
                            SelectFormatEvent(isAudio),
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      Text(
                        l10n?.quality ?? 'Quality',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      QualitySelector(
                        qualities: state.currentQualities,
                        selected: state.selectedQuality,
                        onQualitySelected: (quality) {
                          context.read<PreviewBloc>().add(
                            SelectQualityEvent(quality),
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.md),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: DownloadStartButton(
                  selectedQuality: state.selectedQuality,
                  onStartDownload: () {
                    context.read<PreviewBloc>().add(const StartDownloadEvent());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
