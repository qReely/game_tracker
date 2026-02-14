import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

abstract class GameRepository {
  Future<List<GameEntity>> getTrendingGames({int page});
  Future<GameDetailEntity> getGameDetails(int id);
  Future<List<FilterEntity>> getFilterMetadata(String endpoint);
  Future<List<GameEntity>> getDiscoveryGames(DiscoveryFilterState filters, int page);
}