import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/responsive.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_card_skeleton.dart';

import 'game_card.dart';

/// A generic card builder signature for GameGrid.
typedef GameCardBuilder = Widget Function(GameEntity game, int crossAxisCount);

class GameGrid extends StatelessWidget {
  final List<GameEntity> games;
  final ScrollController? scrollController;
  final GameCardBuilder? itemBuilder;
  final double childAspectRatio;
  final bool isLoading;
  final int _cardShimmerCount = 20;

  const GameGrid({
    super.key,
    required this.games,
    this.scrollController,
    this.itemBuilder,
    this.childAspectRatio = 0.75,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = Responsive.isDesktop(context)
        ? 6
        : Responsive.isTablet(context)
        ? 4
        : 2;

    return GridView.builder(
      controller: scrollController,
      shrinkWrap: scrollController == null,
      physics: scrollController == null ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.all(Dimens.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: Dimens.md,
        mainAxisSpacing: Dimens.md,
      ),
      itemCount: isLoading ? (games.isEmpty ? _cardShimmerCount : games.length) : games.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return const GameCardSkeleton();
        }
        if (itemBuilder != null) {
          return itemBuilder!(games[index], crossAxisCount);
        }
        return GameCard(
          game: games[index],
          crossAxisCount: crossAxisCount,
        );
      },
    );
  }
}
