import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';

class FormatToggle extends StatelessWidget {
  final bool isAudioOnly;
  final ValueChanged<bool> onFormatChanged;

  const FormatToggle({
    super.key,
    required this.isAudioOnly,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<bool>(
        segments: [
          ButtonSegment<bool>(
            value: false,
            icon: const Icon(Icons.videocam_outlined),
            label: Text(l10n?.video ?? 'Video'),
          ),
          ButtonSegment<bool>(
            value: true,
            icon: const Icon(Icons.music_note_outlined),
            label: Text(l10n?.audioOnly ?? 'Audio Only'),
          ),
        ],
        selected: {isAudioOnly},
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
        ),
        onSelectionChanged: (Set<bool> newSelection) {
          onFormatChanged(newSelection.first);
        },
      ),
    );
  }
}

