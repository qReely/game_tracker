import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/series_game_card.dart';

class GameSeriesBlock extends StatelessWidget {
  final List<GameEntity> games;

  const GameSeriesBlock({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GameBlockHeader(headerTitle: "Games in the series"),
        SizedBox(height: 12.h),
        SizedBox(
          height: 220.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w),
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            clipBehavior: Clip.none,
            separatorBuilder: (context, index) => SizedBox(width: Dimens.md.w),
            itemBuilder: (context, index) {
              final game = games[index];
              return SizedBox(
                width: 160.w,
                child: SeriesGameCard(game: game),
              );
            },
          ),
        ),
      ],
    );
  }
}
