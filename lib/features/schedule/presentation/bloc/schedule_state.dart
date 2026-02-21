import 'package:equatable/equatable.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<GameEntity> games;
  final int year;
  final int month;
  final String ordering;
  final bool hasReachedMax;

  const ScheduleLoaded({
    required this.games,
    required this.year,
    required this.month,
    this.ordering = '-released',
    this.hasReachedMax = false,
  });

  ScheduleLoaded copyWith({
    List<GameEntity>? games,
    int? year,
    int? month,
    String? ordering,
    bool? hasReachedMax,
  }) {
    return ScheduleLoaded(
      games: games ?? this.games,
      year: year ?? this.year,
      month: month ?? this.month,
      ordering: ordering ?? this.ordering,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [games, year, month, ordering, hasReachedMax];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object> get props => [message];
}
