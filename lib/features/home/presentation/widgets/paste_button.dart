import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

class PasteButton extends StatelessWidget {
  final TextEditingController? controller;

  const PasteButton({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return OutlinedButton.icon(
      onPressed: () {
        context.read<HomeBloc>().add(PasteFromClipboard());
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      icon: const Icon(Icons.paste_outlined, size: AppDimensions.iconSm),
      label: Text(l10n?.paste ?? 'Paste'),
    );
  }
}

