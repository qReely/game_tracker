import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/data/models/local_game_detail.dart';
import 'package:isar_community/isar.dart';

abstract class GameLocalDataSource {
  Future<List<LocalGame>> getGames();
  Future<void> cacheGames(List<LocalGame> games);

  Future<LocalGameDetail?> getGameDetail(int rawgId);
  Future<void> cacheGameDetail(LocalGameDetail detail);
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
}