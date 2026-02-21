import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GameRepository repository;
  int _currentPage = 1;
  bool _isFetching = false;
  String _currentOrdering = '-released';

  ScheduleBloc({required this.repository}) : super(ScheduleInitial()) {
    on<FetchScheduleGames>(_onFetchScheduleGames);
    on<LoadNextSchedulePage>(_onLoadNextSchedulePage);
  }

  Future<void> _onFetchScheduleGames(
    FetchScheduleGames event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    _currentPage = 1;
    _currentOrdering = event.ordering;
    try {
      final games = await repository.getGameCalendar(
        event.year,
        event.month,
        _currentPage,
        ordering: _currentOrdering,
      );
      emit(ScheduleLoaded(
        games: games,
        year: event.year,
        month: event.month,
        ordering: _currentOrdering,
        hasReachedMax: games.length < 20,
      ));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadNextSchedulePage(
    LoadNextSchedulePage event,
    Emitter<ScheduleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ScheduleLoaded || currentState.hasReachedMax || _isFetching) return;

    _isFetching = true;
    try {
      final nextPage = _currentPage + 1;
      final newGames = await repository.getGameCalendar(
        currentState.year,
        currentState.month,
        nextPage,
        ordering: _currentOrdering,
      );

      if (newGames.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        _currentPage = nextPage;
        emit(currentState.copyWith(
          games: List.of(currentState.games)..addAll(newGames),
          hasReachedMax: newGames.length < 20,
        ));
      }
    } catch (_) {
      // Silently handle pagination errors
    } finally {
      _isFetching = false;
    }
  }
}
