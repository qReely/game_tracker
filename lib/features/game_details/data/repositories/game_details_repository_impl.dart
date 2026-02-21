import 'package:flutter/foundation.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:game_tracker/features/game_details/data/models/game_detail_model.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/game_details/domain/repositories/game_details_repository.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import '../datasources/game_details_local_data_source.dart';

class GameDetailsRepositoryImpl implements GameDetailsRepository {
  final ApiClient _api;
  final GameDetailsLocalDataSource _localDataSource;

  GameDetailsRepositoryImpl(this._api, this._localDataSource);

  @override
  Future<GameDetailEntity?> getCachedGameDetails(int id) async {
    final cached = await _localDataSource.getGameDetail(id);
    return cached?.toEntity();
  }

  @override
  Future<GameDetailEntity> getGameDetails(int id) async {
    try {
      final cacheKey = 'game_details_$id';
      final lastUpdated = await _localDataSource.getLastUpdated(cacheKey);

      if (lastUpdated != null && DateTime.now().difference(lastUpdated).inHours < 24) {
        final cached = await _localDataSource.getGameDetail(id);
        if (cached != null) return cached.toEntity();
      }

      final response = await _api.get('/games/$id');
      final screenshotsResponse = await _api.get('/games/$id/screenshots');

      final detailModel = GameDetailModel.fromJson(response.data, screenshotsResponse.data);

      await _localDataSource.cacheGameDetail(detailModel.toLocal());
      await _localDataSource.updateCacheTimestamp(cacheKey);

      return detailModel;
    } catch (e) {
      debugPrint("API Error in getGameDetails: $e");
      final cached = await _localDataSource.getGameDetail(id);
      if (cached != null) return cached.toEntity();
      rethrow;
    }
  }

  @override
  Future<List<GameEntity>> getGameSeries(int id) async {
    try {
      final response = await _api.get('/games/$id/game-series');
      final List results = response.data['results'];
      final List<LocalGame> localGames = results.map((json) {
        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..releasedYear = json['released'] != null && json['released'].isNotEmpty
              ? json['released'].split('-').first
              : null
          ..rating = (json['rating'] as num).toDouble();
      }).toList();

      return localGames.map((e) => e.toEntity()).toList();
    } catch (e) {
      debugPrint("API Error in getGameSeries: $e");
      rethrow;
    }
  }
}
