import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:isar_community/isar.dart';

class GameRepositoryImpl implements GameRepository {
  final ApiClient _api;
  final Isar _isar;

  GameRepositoryImpl(this._api, this._isar);

  @override
  Future<List<GameEntity>> getTrendingGames() async {
    try {
      // 1. Fetch from RAWG
      final response = await _api.get('/games', queryParameters: {'page_size': 10});
      final List results = response.data['results'];

      final List<LocalGame> localGames = results.map((json) {
        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..rating = (json['rating'] as num).toDouble();
      }).toList();

      // 2. Save to Local Storage (Isar)
      await _isar.writeTxn(() async {
        await _isar.localGames.putAll(localGames);
      });

      return localGames.map((e) => e.toEntity()).toList();
    } catch (e) {
      // 3. Fallback: If network fails, return what's in Isar
      final cached = await _isar.localGames.where().findAll();

      if (cached.isNotEmpty) {
        return cached.map((e) => e.toEntity()).toList();
      } else {
        // 4. Extensive Error: If cache is also empty, throw specific failure
        throw GamesLoadingFailure();
      }
    }
  }
}