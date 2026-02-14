import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class GameState {}

class GamesInitial extends GameState {}

class GamesLoading extends GameState {}

class GamesLoaded extends GameState {
  List<GameEntity> games;
  bool hasReachedMax;
  GamesLoaded({required this.games, required this.hasReachedMax});

  GameState copyWith({required bool hasReachedMax}) {
    return GamesLoaded(
      games: games,
      hasReachedMax: hasReachedMax,
    );
  }
}

class GamesError extends GameState {
  final String message;
  GamesError(this.message);
}