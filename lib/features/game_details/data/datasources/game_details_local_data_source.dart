import 'package:game_tracker/core/cache/cache_metadata.dart';
import 'package:game_tracker/features/game_details/data/models/local_game_detail.dart';
import 'package:isar_community/isar.dart';

abstract class GameDetailsLocalDataSource {
  Future<LocalGameDetail?> getGameDetail(int rawgId);
  Future<void> cacheGameDetail(LocalGameDetail detail);
  Future<void> updateCacheTimestamp(String key);
  Future<DateTime?> getLastUpdated(String key);
}

class GameDetailsLocalDataSourceImpl implements GameDetailsLocalDataSource {
  final Isar isar;
  GameDetailsLocalDataSourceImpl(this.isar);

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
}
