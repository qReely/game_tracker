import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class DiscoveryState {}

class DiscoveryInitial extends DiscoveryState {}

class DiscoveryLoading extends DiscoveryState {}

class DiscoveryLoaded extends DiscoveryState {
  final List<GameEntity> games;
  final bool hasReachedMax;

  DiscoveryLoaded({required this.games, this.hasReachedMax = false});

  DiscoveryLoaded copyWith({List<GameEntity>? games, bool? hasReachedMax}) {
    return DiscoveryLoaded(
      games: games ?? this.games,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class DiscoveryError extends DiscoveryState {
  final String message;
  DiscoveryError(this.message);
}