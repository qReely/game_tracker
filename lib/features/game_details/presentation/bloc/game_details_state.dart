import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class GameDetailsState {}

class GameDetailsInitial extends GameDetailsState {}

class GameDetailsLoading extends GameDetailsState {}

class GameDetailsLoaded extends GameDetailsState {
  final GameDetailEntity details;
  final List<GameEntity> seriesGames;
  GameDetailsLoaded(this.details, {this.seriesGames = const []});
}

class GameDetailsError extends GameDetailsState {
  final String message;
  GameDetailsError(this.message);
}