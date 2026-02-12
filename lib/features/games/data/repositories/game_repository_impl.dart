import 'package:flutter/foundation.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:game_tracker/features/games/data/datasources/game_local_data_source.dart';
import 'package:game_tracker/features/games/data/models/game_detail_model.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_state.dart';

class GameRepositoryImpl implements GameRepository {
  final ApiClient _api;
  final GameLocalDataSource _localDataSource;

  GameRepositoryImpl(this._api, this._localDataSource);

  @override
  Future<List<GameEntity>> getTrendingGames() async {
    try {
      // 1. Fetch from API
      final response = await _api.get('/games', queryParameters: {'page_size': 10});
      final List results = response.data['results'];

      final List<LocalGame> localGames = results.map((json) {
        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..rating = (json['rating'] as num).toDouble();
      }).toList();

      // 2. Save to Local Storage
      await _localDataSource.cacheGames(localGames);

      return localGames.map((e) => e.toEntity()).toList();
    } catch (e) {
      // 3. Fallback: If network fails, return what's in Isar
      final cached = await _localDataSource.getGames();
      if (cached.isNotEmpty) {
        return cached.map((e) => e.toEntity()).toList();
      } else {
        debugPrint(e.toString());
        throw GamesLoadingFailure();
      }
    }
  }

  @override
  Future<GameDetailEntity> getGameDetails(int id) async {
    final cached = await _localDataSource.getGameDetail(id);
    if (cached != null) {
      return cached.toEntity();
    }

    try {
      // 2. Parallel Fetch if not in cache
      final results = await Future.wait([
        _api.get('/games/$id'),
        _api.get('/games/$id/screenshots'),
      ]);

      final detailModel = GameDetailModel.fromJson(results[0].data, results[1].data);

      await _localDataSource.cacheGameDetail(detailModel.toLocal());

      return detailModel;
    } catch (e) {
      debugPrint(e.toString());
      throw GameDetailsError(e.toString());
    }
  }
}