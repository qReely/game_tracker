import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_card.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_card_skeleton.dart';

class GameCarousel extends StatelessWidget {
  final List<GameEntity> games;
  final bool isLoading;
  final double height;
  final double cardWidth;
  final String sectionId;

  const GameCarousel({
    super.key,
    required this.games,
    this.isLoading = false,
    this.height = 220,
    this.cardWidth = 150,
    required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimens.md.w),
        itemCount: isLoading ? 5 : games.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimens.md.w),
            child: SizedBox(
              width: cardWidth.w,
              child: isLoading
                  ? const GameCardSkeleton()
                  : GameCard(
                      game: games[index],
                      crossAxisCount: 1, // Not used in single card mode, but required by API
                      heroTag: 'hero_${sectionId}_${games[index].id}',
                    ),
            ),
          );
        },
      ),
    );
  }
}
