import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/repositories/discovery_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final LibraryRepository _libraryRepository;
  final DiscoveryRepository _discoveryRepository;

  DashboardBloc({
    required LibraryRepository libraryRepository,
    required DiscoveryRepository discoveryRepository,
  })  : _libraryRepository = libraryRepository,
        _discoveryRepository = discoveryRepository,
        super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(LoadDashboardData event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      // 1. Fetch "Upcoming Releases" (This Week) - Static for this session
      final upcomingReleases = await _discoveryRepository.getDiscoveryGames(
        const DiscoveryFilterState(activeQuickFilterId: 'recent-games-this-week'),
        1,
      );

      // 2. Fetch "Popular in Community" - Static for this session
      final popularCommunity = await _discoveryRepository.getPopularCommunityGames();

      // 3. Listen to Library updates reactively
      await emit.forEach<List<LibraryItem>>(
        _libraryRepository.getMyLibrary(),
        onData: (libraryItems) {
          final currentSessions = libraryItems
              .where((item) => (item.playtimeMinutes ?? 0) > 0 && item.status != GameStatus.completed)
              .map((item) => GameEntity(
                    id: item.gameId,
                    name: item.gameName,
                    backgroundImage: item.posterPath,
                    rating: 0.0,
                    releasedYear: item.releasedYear,
                  ))
              .toList();

          return DashboardLoaded(
            currentSessions: currentSessions,
            upcomingReleases: upcomingReleases,
            popularCommunity: popularCommunity,
          );
        },
      );
    } catch (e) {
      emit(DashboardError("Failed to load dashboard data: ${e.toString()}"));
    }
  }
}
