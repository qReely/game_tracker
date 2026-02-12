import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class GameState {}

class GamesInitial extends GameState {}

class GamesLoading extends GameState {}

class GamesLoaded extends GameState {
  List<GameEntity> games;
  GamesLoaded(this.games);
}

class GamesError extends GameState {
  final String message;
  GamesError(this.message);
}