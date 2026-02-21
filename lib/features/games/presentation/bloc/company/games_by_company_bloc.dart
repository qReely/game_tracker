import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';

import 'games_by_company_event.dart';
import 'games_by_company_state.dart';

class GamesByCompanyBloc extends Bloc<GamesByCompanyEvent, GamesByCompanyState> {
  final GameRepository _repository;
  final DiscoveryFilterCubit filterCubit;
  
  String? _companySlug;
  bool? _isPublisher;

  GamesByCompanyBloc(this._repository, this.filterCubit) : super(GamesByCompanyInitial()) {
    on<FetchGamesByCompany>(_onFetchGames);
    on<LoadMoreGamesByCompany>(_onLoadMore);
    on<RefreshGamesByCompany>((event, emit) {
      if (_companySlug != null && _isPublisher != null) {
        add(FetchGamesByCompany(companySlug: _companySlug!, isPublisher: _isPublisher!));
      }
    });
  }

  Future<void> _onFetchGames(FetchGamesByCompany event, Emitter<GamesByCompanyState> emit) async {
    _companySlug = event.companySlug;
    _isPublisher = event.isPublisher;
    
    emit(GamesByCompanyLoading());
    try {
      final games = await _repository.getGamesByCompany(
        companySlug: _companySlug!,
        isPublisher: _isPublisher!,
        filters: filterCubit.state,
        page: 1,
      );
      emit(GamesByCompanyLoaded(
        games: games,
        hasReachedMax: games.length < 20,
        currentPage: 1,
      ));
    } catch (e) {
      emit(GamesByCompanyError(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreGamesByCompany event, Emitter<GamesByCompanyState> emit) async {
    if (state is! GamesByCompanyLoaded || _companySlug == null || _isPublisher == null) return;
    final currentState = state as GamesByCompanyLoaded;
    if (currentState.hasReachedMax) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final newGames = await _repository.getGamesByCompany(
        companySlug: _companySlug!,
        isPublisher: _isPublisher!,
        filters: filterCubit.state,
        page: nextPage,
      );

      emit(currentState.copyWith(
        games: List.of(currentState.games)..addAll(newGames),
        hasReachedMax: newGames.length < 20,
        currentPage: nextPage,
      ));
    } catch (e) {
      // Keep existing data on error
    }
  }
}
