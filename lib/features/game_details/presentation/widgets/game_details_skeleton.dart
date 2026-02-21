import 'package:flutter/material.dart';
import 'package:game_tracker/core/presentation/widgets/app_shimmer.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class GameDetailsSkeleton extends StatelessWidget {
  const GameDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Image Placeholder
          AppShimmer(
            child: Container(
              height: 300.h,
              width: double.infinity,
              color: Colors.white10,
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(Dimens.lg.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Platform Tags
                AppShimmer(
                  child: Row(
                    children: List.generate(3, (index) => Padding(
                      padding: EdgeInsets.only(right: Dimens.sm.w),
                      child: Container(
                        width: 60.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
                        ),
                      ),
                    )),
                  ),
                ),
                SizedBox(height: Dimens.md.h),
                
                // 3. Title
                AppShimmer(
                  child: Container(
                    width: double.infinity,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.lg.h),
                
                // 4. Action Buttons
                AppShimmer(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Dimens.radiusXl.r),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimens.md.w),
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimens.radiusXl.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimens.xl.h),
                
                // 5. Stats Row
                AppShimmer(
                  child: Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.xl.h),
                
                // 6. About Section
                AppShimmer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: Dimens.md.h),
                      ...List.generate(4, (index) => Padding(
                        padding: EdgeInsets.only(bottom: Dimens.sm.h),
                        child: Container(
                          width: double.infinity,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
