import 'package:flutter/material.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/constants/app_icons.dart';

class GameAverageRating extends StatelessWidget {
  final int gameId;

  const GameAverageRating({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: sl<LibraryRepository>().getAverageRating(gameId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;
        final average = (data['average'] as num?)?.toDouble() ?? 0.0;
        final count = (data['totalVotes'] as int?) ?? 0;

        if (count == 0) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(Dimens.md.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
            border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Dimens.sm.w),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(AppIcons.star, color: AppColors.warning, size: 24.sp),
              ),
              SizedBox(width: Dimens.md.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        average.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ),
                      Text(
                        " / 5.0",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Community Rating ($count votes)",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
