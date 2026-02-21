import 'package:flutter/material.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class GameStatsRow extends StatelessWidget {
  final GameDetailEntity game;

  const GameStatsRow({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.lg.h, horizontal: Dimens.md.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
        border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, "CRITIC", game.metacritic.toString(), Colors.blueAccent),
          _buildStatItem(context, "RELEASED", game.released.split('-').first, AppColors.textPrimary),
          _buildStatItem(context, "PLAYTIME", "${game.playtime}h+", AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2.w),
          ),
          child: Text(
            value, 
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color, 
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(height: Dimens.sm.h),
        Text(
          label, 
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary, 
            letterSpacing: 1.2,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}