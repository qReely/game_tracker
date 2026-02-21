import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class GamePlatformsTags extends StatelessWidget {
  final List<String> platforms;
  const GamePlatformsTags({super.key, required this.platforms});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12,),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: platforms.map((p) => _buildTag(context, p)).toList(),
        ),
      ),
    );
  }
  Widget _buildTag(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.only(right: Dimens.sm.w),
      padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w, vertical: Dimens.xs.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
      ),
      child: Text(
        text, 
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary, 
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
