import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

class PreviewShimmerSkeleton extends StatefulWidget {
  const PreviewShimmerSkeleton({super.key});

  @override
  State<PreviewShimmerSkeleton> createState() => _PreviewShimmerSkeletonState();
}

class _PreviewShimmerSkeletonState extends State<PreviewShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double borderRadius = AppDimensions.radiusMd,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
        final highlightColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0.0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0.0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail skeleton (16:9)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildShimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppDimensions.radiusLg,
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Title lines skeleton
          _buildShimmerBox(width: double.infinity, height: 20),
          const SizedBox(height: AppDimensions.sm),
          _buildShimmerBox(width: 220, height: 16),
          const SizedBox(height: AppDimensions.lg),

          // Format toggle skeleton
          _buildShimmerBox(
            width: double.infinity,
            height: 48,
            borderRadius: AppDimensions.radiusMd,
          ),
          const SizedBox(height: AppDimensions.lg),

          // Quality section header skeleton
          _buildShimmerBox(width: 140, height: 18),
          const SizedBox(height: AppDimensions.md),

          // Quality chips skeleton
          Row(
            children: [
              _buildShimmerBox(width: 80, height: 56),
              const SizedBox(width: AppDimensions.sm),
              _buildShimmerBox(width: 80, height: 56),
              const SizedBox(width: AppDimensions.sm),
              _buildShimmerBox(width: 80, height: 56),
            ],
          ),
        ],
      ),
    );
  }
}

