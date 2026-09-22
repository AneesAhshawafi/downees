import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/video_quality.dart';

class QualityChip extends StatelessWidget {
  final VideoQuality quality;
  final bool isSelected;
  final VoidCallback onTap;

  const QualityChip({
    super.key,
    required this.quality,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 2)
              : Border.all(color: colorScheme.outlineVariant),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quality.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.white : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${quality.fileSizeMB} MB',
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white70 : colorScheme.outline,
              ),
            ),
            if (quality.isRecommended) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '⭐ أفضل',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.amberAccent : Colors.amber[800],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

