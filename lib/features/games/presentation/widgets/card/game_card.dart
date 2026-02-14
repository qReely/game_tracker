import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:go_router/go_router.dart';

class GameCard extends StatelessWidget {
  final GameEntity game;
  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('game_details', pathParameters: {'id': game.id.toString()}),
      child: Card(
        // CardTheme handles color, shape, elevation
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: game.backgroundImage ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.surfaceLight),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(AppIcons.error, color: AppColors.textTertiary),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimens.md.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimens.xs.h),
                  Row(
                    children: [
                      Icon(AppIcons.star, color: AppColors.warning, size: Dimens.iconSm.r),
                      SizedBox(width: Dimens.xs.w),
                      Text(
                        game.rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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