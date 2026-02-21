import 'package:game_tracker/core/cache/cache_metadata.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/game_details/data/models/local_game_detail.dart';
import 'package:isar_community/isar.dart';
import 'package:game_tracker/features/games/data/models/local_filter.dart';
import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';

abstract class GameLocalDataSource {
  Future<List<LocalGame>> getGames();
  Future<void> cacheGames(List<LocalGame> games);

  Future<LocalGameDetail?> getGameDetail(int rawgId);
  Future<void> cacheGameDetail(LocalGameDetail detail);
  Future<void> updateCacheTimestamp(String key);
  Future<DateTime?> getLastUpdated(String key);

  Future<void> saveMetadata(String endpoint, List<FilterEntity> freshData);
  Future<List<FilterEntity>> getCachedMetadata(String endpoint);
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  final Isar isar;
  GameLocalDataSourceImpl(this.isar);

  @override
  Future<List<LocalGame>> getGames() async {
    return await isar.localGames.where().findAll();
  }

  @override
  Future<void> cacheGames(List<LocalGame> games) async {
    await isar.writeTxn(() async {
      await isar.localGames.putAll(games);
    });
  }

  @override
  Future<LocalGameDetail?> getGameDetail(int rawgId) async {
    return await isar.localGameDetails.filter().rawgIdEqualTo(rawgId).findFirst();
  }

  @override
  Future<void> cacheGameDetail(LocalGameDetail detail) async {
    await isar.writeTxn(() async {
      await isar.localGameDetails.put(detail);
    });
  }

  @override
  Future<void> updateCacheTimestamp(String key) async {
    final metadata = CacheMetadata()
      ..cacheKey = key
      ..lastUpdated = DateTime.now();

    await isar.writeTxn(() async {
      await isar.cacheMetadatas.put(metadata);
    });
  }

  @override
  Future<DateTime?> getLastUpdated(String key) async {
    final metadata = await isar.cacheMetadatas.filter().cacheKeyEqualTo(key).findFirst();
    return metadata?.lastUpdated;
  }

  @override
  Future<void> saveMetadata(String endpoint, List<FilterEntity> freshData) async {
    await isar.writeTxn(() async {
      // 1. Clear old data for this endpoint to avoid stale entries
      await isar.localFilters.filter().endpointEqualTo(endpoint).deleteAll();

      // 2. Convert and save new data
      final localFilters = freshData.map((e) {
        return LocalFilter()
          ..endpoint = endpoint
          ..filterId = e.id
          ..name = e.name
          ..slug = e.slug;
      }).toList();

      await isar.localFilters.putAll(localFilters);
    });
  }

  @override
  Future<List<FilterEntity>> getCachedMetadata(String endpoint) async {
    final localFilters = await isar.localFilters.filter().endpointEqualTo(endpoint).findAll();
    return localFilters.map((e) => e.toEntity()).toList();
  }
}