import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:game_tracker/core/theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor: AppColors.surfaceLight,
      highlightColor: AppColors.surfaceLight.withValues(alpha: 0.5),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}
