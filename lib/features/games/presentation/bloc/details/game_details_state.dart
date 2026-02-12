import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';

abstract class GameDetailsState {}

class GameDetailsInitial extends GameDetailsState {}

class GameDetailsLoading extends GameDetailsState {}

class GameDetailsLoaded extends GameDetailsState {
  GameDetailEntity details;
  GameDetailsLoaded(this.details);
}

class GameDetailsError extends GameDetailsState {
  final String message;
  GameDetailsError(this.message);
}