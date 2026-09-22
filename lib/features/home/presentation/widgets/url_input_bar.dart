import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'platform_icon.dart';

class UrlInputBar extends StatefulWidget {
  final TextEditingController controller;

  const UrlInputBar({
    super.key,
    required this.controller,
  });

  @override
  State<UrlInputBar> createState() => _UrlInputBarState();
}

class _UrlInputBarState extends State<UrlInputBar> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (prev, curr) => prev.currentUrl != curr.currentUrl,
      listener: (context, state) {
        if (widget.controller.text != state.currentUrl) {
          widget.controller.text = state.currentUrl;
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          );
        }
      },
      builder: (context, state) {
        final outlineColor = state.isValidUrl
            ? AppColors.success
            : Theme.of(context).colorScheme.outlineVariant;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: outlineColor,
              width: state.isValidUrl ? 2 : 1,
            ),
            boxShadow: [
              if (state.isValidUrl)
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
          child: Row(
            children: [
              if (state.detectedPlatform != null)
                Padding(
                  padding: const EdgeInsets.only(left: AppDimensions.xs, right: AppDimensions.xs),
                  child: PlatformIcon(platform: state.detectedPlatform!),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
                  child: Icon(
                    Icons.link,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onChanged: (value) {
                    context.read<HomeBloc>().add(UrlChanged(value));
                  },
                  onSubmitted: (_) {
                    if (state.isValidUrl) {
                      context.read<HomeBloc>().add(SubmitUrl());
                    }
                  },
                  decoration: InputDecoration(
                    hintText: l10n?.pasteLink ?? 'Paste video link here...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.md,
                    ),
                  ),
                ),
              ),
              if (widget.controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: AppDimensions.iconSm),
                  tooltip: 'Clear',
                  onPressed: () {
                    widget.controller.clear();
                    context.read<HomeBloc>().add(const UrlChanged(''));
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

