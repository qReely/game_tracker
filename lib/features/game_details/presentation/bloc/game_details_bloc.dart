import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/game_details/domain/repositories/game_details_repository.dart';
import 'package:game_tracker/features/game_details/presentation/bloc/game_details_event.dart';
import 'package:game_tracker/features/game_details/presentation/bloc/game_details_state.dart';

class GameDetailsBloc extends Bloc<GameDetailsEvent, GameDetailsState> {
  final GameDetailsRepository _repository;

  GameDetailsBloc(this._repository) : super(GameDetailsInitial()) {
    on<FetchGameDetails>((event, emit) async {
      // 1. Try Cache First
      final cached = await _repository.getCachedGameDetails(event.id);
      if (cached != null) {
        emit(GameDetailsLoaded(cached));
      } else {
        emit(GameDetailsLoading());
      }
      
      // 2. Background Refresh
      try {
        final results = await Future.wait([
          _repository.getGameDetails(event.id),
          _repository.getGameSeries(event.id),
        ]);
        
        final details = results[0] as GameDetailEntity;
        final series = results[1] as List<GameEntity>;
        
        emit(GameDetailsLoaded(details, seriesGames: series));
      } catch (e) {
        // Only error if we have nothing at all
        if (state is! GameDetailsLoaded) {
          emit(GameDetailsError("Could not load game details."));
        }
      }
    });
  }
}