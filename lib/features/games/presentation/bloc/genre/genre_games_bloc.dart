import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/domain/repositories/discovery_repository.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

// Events
abstract class GenreGamesEvent {}
class FetchGamesByGenre extends GenreGamesEvent {
  final String genreSlug;
  final DiscoveryFilterState? filters;
  FetchGamesByGenre(this.genreSlug, {this.filters});
}
class LoadMoreGenreGames extends GenreGamesEvent {}

// States
abstract class GenreGamesState {}
class GenreGamesInitial extends GenreGamesState {}
class GenreGamesLoading extends GenreGamesState {}
class GenreGamesLoaded extends GenreGamesState {
  final List<GameEntity> games;
  final bool hasReachedMax;
  final int currentPage;
  final DiscoveryFilterState filters;
  GenreGamesLoaded({
    required this.games, 
    required this.hasReachedMax, 
    required this.currentPage,
    required this.filters,
  });
}
class GenreGamesError extends GenreGamesState {
  final String message;
  GenreGamesError(this.message);
}

class GenreGamesBloc extends Bloc<GenreGamesEvent, GenreGamesState> {
  final DiscoveryRepository repository;
  String? _currentGenre;
  DiscoveryFilterState? _lastFilters;
  bool _isFetching = false;

  GenreGamesBloc({required this.repository}) : super(GenreGamesInitial()) {
    on<FetchGamesByGenre>((event, emit) async {
      _currentGenre = event.genreSlug;
      _lastFilters = event.filters ?? DiscoveryFilterState(genreSlug: event.genreSlug);
      
      emit(GenreGamesLoading());
      try {
        final List<GameEntity> games = await repository.getDiscoveryGames(_lastFilters!, 1);
        emit(GenreGamesLoaded(
          games: games,
          hasReachedMax: games.length < 20,
          currentPage: 1,
          filters: _lastFilters!,
        ));
      } catch (e) {
        emit(GenreGamesError(e.toString()));
      }
    });

    on<LoadMoreGenreGames>((event, emit) async {
      final currentState = state;
      if (_isFetching || currentState is! GenreGamesLoaded || currentState.hasReachedMax || _currentGenre == null) return;

      _isFetching = true;
      try {
        final nextPage = currentState.currentPage + 1;
        final List<GameEntity> newGames = await repository.getDiscoveryGames(_lastFilters!, nextPage);

        if (newGames.isEmpty) {
          emit(GenreGamesLoaded(
            games: currentState.games,
            hasReachedMax: true,
            currentPage: currentState.currentPage,
            filters: _lastFilters!,
          ));
        } else {
          emit(GenreGamesLoaded(
            games: currentState.games + newGames,
            hasReachedMax: newGames.length < 20,
            currentPage: nextPage,
            filters: _lastFilters!,
          ));
        }
      } catch (e) {
        // Silent fail
      } finally {
        _isFetching = false;
      }
    });
  }
}
