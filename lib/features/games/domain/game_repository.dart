import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

abstract class GameRepository {
  Future<List<GameEntity>> getTrendingGames({int page = 1});
  Future<List<GameEntity>> getGameCalendar(int year, int month, int page, {String ordering = '-released'});
  Future<List<GameEntity>> getGamesByCompany({
    required String companySlug, 
    required bool isPublisher, 
    DiscoveryFilterState? filters,
    int page = 1,
  });
}