import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/widgets/app_cached_image.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/core/extensions/num_extensions.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:go_router/go_router.dart';

class SeriesGameCard extends StatelessWidget {
  final GameEntity game;

  const SeriesGameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. BACKGROUND IMAGE
            AppCachedImage(
              imageUrl: game.backgroundImage ?? '',
              fit: BoxFit.cover,
            ),

            // 2. GRADIENT OVERLAY
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // 3. TEXT CONTENT (Bottom)
            Positioned(
              bottom: Dimens.sm.h,
              left: Dimens.sm.w,
              right: Dimens.sm.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    game.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: Dimens.xs.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        game.releasedYear ?? 'TBA',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10.sp,
                        ),
                      ),
                      if (game.rating > 0)
                        _buildRating(context, game.rating),
                    ],
                  ),
                ],
              ),
            ),

            // 4. TOUCH RIPPLE
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pushNamed('game_details', pathParameters: {'id': game.id.toString()}),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context, double rating) {
    final Color color = rating.ratingColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.xs.w, vertical: Dimens.xs.h / 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Dimens.radiusXs.r),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.star, color: color, size: 10.r),
          SizedBox(width: Dimens.xs.w),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
