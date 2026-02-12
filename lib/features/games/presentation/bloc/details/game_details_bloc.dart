import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_state.dart';

class GameDetailsBloc extends Bloc<GameDetailsEvent, GameDetailsState> {
  final GameRepository _repository;

  GameDetailsBloc(this._repository) : super(GameDetailsInitial()) {
    on<FetchGameDetails>((event, emit) async {
      emit(GameDetailsLoading());
      try {
        final details = await _repository.getGameDetails(event.id);
        emit(GameDetailsLoaded(details));
      } catch (e) {
        emit(GameDetailsError("Could not load game details."));
      }
    });
  }
}