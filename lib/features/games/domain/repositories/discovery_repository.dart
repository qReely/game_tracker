import 'package:game_tracker/core/domain/entities/genre_entity.dart';
import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

abstract class DiscoveryRepository {
  Future<List<FilterEntity>> getFilterMetadata(String endpoint);
  Future<List<GameEntity>> getDiscoveryGames(DiscoveryFilterState filters, int page);
  Future<List<GenreEntity>> getGenres();
  Future<List<GameEntity>> getPopularCommunityGames();
}
