import 'package:equatable/equatable.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class GamesByCompanyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GamesByCompanyInitial extends GamesByCompanyState {}

class GamesByCompanyLoading extends GamesByCompanyState {}

class GamesByCompanyLoaded extends GamesByCompanyState {
  final List<GameEntity> games;
  final bool hasReachedMax;
  final int currentPage;

  GamesByCompanyLoaded({
    required this.games,
    required this.hasReachedMax,
    required this.currentPage,
  });

  GamesByCompanyLoaded copyWith({
    List<GameEntity>? games,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return GamesByCompanyLoaded(
      games: games ?? this.games,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [games, hasReachedMax, currentPage];
}

class GamesByCompanyError extends GamesByCompanyState {
  final String message;
  GamesByCompanyError(this.message);

  @override
  List<Object?> get props => [message];
}
