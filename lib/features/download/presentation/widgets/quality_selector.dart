import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/video_quality.dart';
import 'quality_chip.dart';

class QualitySelector extends StatelessWidget {
  final List<VideoQuality> qualities;
  final VideoQuality? selected;
  final ValueChanged<VideoQuality> onQualitySelected;

  const QualitySelector({
    super.key,
    required this.qualities,
    required this.selected,
    required this.onQualitySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (qualities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
        child: Center(
          child: Text(
            'No qualities available for this format',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }

    return Wrap(
      spacing: AppDimensions.sm,
      runSpacing: AppDimensions.sm,
      children: qualities.map((q) {
        return QualityChip(
          quality: q,
          isSelected: q == selected,
          onTap: () => onQualitySelected(q),
        );
      }).toList(),
    );
  }
}

