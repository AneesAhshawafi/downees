import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/enums/platform_type.dart';

class PlatformIcon extends StatelessWidget {
  final PlatformType platform;
  final double size;

  const PlatformIcon({
    super.key,
    required this.platform,
    this.size = 28,
  });

  Color _getPlatformColor() {
    return switch (platform) {
      PlatformType.youtube => AppColors.youtube,
      PlatformType.instagram => AppColors.instagram,
      PlatformType.tiktok => AppColors.tiktok,
      PlatformType.twitter => AppColors.twitter,
      PlatformType.facebook => AppColors.facebook,
      PlatformType.unknown => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
      decoration: BoxDecoration(
        color: _getPlatformColor().withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        platform.emoji,
        style: TextStyle(fontSize: size * 0.55),
      ),
    );
  }
}

