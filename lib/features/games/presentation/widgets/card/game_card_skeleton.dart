import 'package:flutter/material.dart';
import 'package:game_tracker/core/presentation/widgets/app_shimmer.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class GameCardSkeleton extends StatelessWidget {
  const GameCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
        color: AppColors.surface,
      ),
      child: AppShimmer(
        child: Stack(
          children: [
            // Placeholder for background image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                color: Colors.white,
              ),
            ),
            // Placeholder for title and rating
            Positioned(
              bottom: Dimens.md.h,
              left: Dimens.md.w,
              right: Dimens.md.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimens.sm.w),
                      Container(
                        width: 40.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.xs.h),
                  Container(
                    width: 60.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
