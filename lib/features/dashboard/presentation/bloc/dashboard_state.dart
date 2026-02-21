import 'package:equatable/equatable.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<GameEntity> currentSessions;
  final List<GameEntity> upcomingReleases;
  final List<GameEntity> popularCommunity;

  DashboardLoaded({
    required this.currentSessions,
    required this.upcomingReleases,
    required this.popularCommunity,
  });

  @override
  List<Object?> get props => [currentSessions, upcomingReleases, popularCommunity];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
