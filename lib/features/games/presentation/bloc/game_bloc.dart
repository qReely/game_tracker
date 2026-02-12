import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;

  GameBloc(this._gameRepository) : super(GamesInitial()) {
    on<FetchTrendingGames>((event, emit) async {
      if (state is GamesLoading) return;

      emit(GamesLoading());
      try {
        final games = await _gameRepository.getTrendingGames();
        emit(GamesLoaded(games));
      } on GamesLoadingFailure catch (e) {
        emit(GamesError(e.message));
      }
    });
  }
}