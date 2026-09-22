import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.isValidUrl != curr.isValidUrl || prev.currentUrl != curr.currentUrl,
      builder: (context, state) {
        final isEnabled = state.isValidUrl && state.currentUrl.isNotEmpty;

        return ElevatedButton.icon(
          onPressed: isEnabled
              ? () {
                  context.read<HomeBloc>().add(SubmitUrl());
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          icon: const Icon(Icons.arrow_downward_rounded, size: AppDimensions.iconSm),
          label: Text(l10n?.download ?? 'Download'),
        );
      },
    );
  }
}

