import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class SmartPasteBanner extends StatelessWidget {
  const SmartPasteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.showSmartPaste != curr.showSmartPaste ||
          prev.smartPasteUrl != curr.smartPasteUrl ||
          prev.smartPastePlatform != curr.smartPastePlatform,
      builder: (context, state) {
        if (!state.showSmartPaste) {
          return const SizedBox.shrink();
        }

        final platformName = state.smartPastePlatform?.displayName ?? '';
        final message = l10n?.linkDetected(platformName) ?? 'Link detected';

        return AnimatedSlide(
          offset: state.showSmartPaste ? Offset.zero : const Offset(0, -0.5),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: state.showSmartPaste ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.sm,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.sm,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    state.smartPastePlatform?.emoji ?? '🔗',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        if (state.smartPasteUrl != null)
                          Text(
                            state.smartPasteUrl!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(SubmitUrl());
                    },
                    child: Text(
                      l10n?.downloadNow ?? 'Download Now',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: AppDimensions.iconSm),
                    tooltip: l10n?.ignore ?? 'Ignore',
                    onPressed: () {
                      context.read<HomeBloc>().add(SmartPasteDismissed());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

