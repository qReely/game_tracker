import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;
  int currentPage = 1;
  bool isFetching = false;

  GameBloc(this._gameRepository) : super(GamesInitial()) {
    on<FetchGames>((event, emit) async {
      if (state is GamesLoading) return;

      emit(GamesLoading());
      try {
        currentPage = 1;
        final games = await _gameRepository.getTrendingGames(page: currentPage);
        emit(GamesLoaded(games: games, hasReachedMax: false));
      } on GamesLoadingFailure catch (e) {
        emit(GamesError(e.message));
      }
    });

    on<LoadMoreGames>((event, emit) async {
      final currentState = state;
      if (isFetching || currentState is! GamesLoaded || currentState.hasReachedMax) return;

      isFetching = true;
      try {
        currentPage++;
        final newGames = await _gameRepository.getTrendingGames(page: currentPage);

        if (newGames.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(GamesLoaded(
            games: currentState.games + newGames,
            hasReachedMax: false,
          ));
        }
      } catch (e) {
        // Silently fail pagination or show a snackbar
      } finally {
        isFetching = false;
      }
    });
  }
}