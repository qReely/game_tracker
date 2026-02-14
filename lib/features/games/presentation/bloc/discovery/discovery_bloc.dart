import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';
import 'discovery_filter_cubit.dart';

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final GameRepository repository;
  final DiscoveryFilterCubit filterCubit;
  int _currentPage = 1;
  bool _isFetching = false;

  DiscoveryBloc({required this.repository, required this.filterCubit}) : super(DiscoveryInitial()) {
    on<RefreshDiscovery>((event, emit) async {
      emit(DiscoveryLoading());
      _currentPage = 1;
      try {
        final games = await repository.getDiscoveryGames(filterCubit.state, _currentPage);
        emit(DiscoveryLoaded(games: games, hasReachedMax: games.length < 20));
      } catch (e) {
        emit(DiscoveryError(e.toString()));
      }
    });

    on<LoadNextDiscoveryPage>((event, emit) async {
      final currentState = state;
      if (_isFetching || currentState is! DiscoveryLoaded || currentState.hasReachedMax) return;

      _isFetching = true;
      try {
        _currentPage++;
        final newGames = await repository.getDiscoveryGames(filterCubit.state, _currentPage);

        if (newGames.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(DiscoveryLoaded(
            games: currentState.games + newGames,
            hasReachedMax: newGames.length < 20,
          ));
        }
      } catch (e) {
        // Silently fail pagination errors or emit a transient error state
      } finally {
        _isFetching = false;
      }
    });
  }
}