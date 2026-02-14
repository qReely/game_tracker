import 'package:flutter/foundation.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:game_tracker/features/games/data/datasources/game_local_data_source.dart';
import 'package:game_tracker/features/games/data/models/game_detail_model.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_state.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

class GameRepositoryImpl implements GameRepository {
  final ApiClient _api;
  final GameLocalDataSource _localDataSource;

  GameRepositoryImpl(this._api, this._localDataSource);

  @override
  Future<List<GameEntity>> getTrendingGames({int page = 1}) async {
    try {
      final response = await _api.get('/games', queryParameters: {
        'page': page,
        'page_size': 20, // Increased for better UX
      });

      final List results = response.data['results'];
      final List<LocalGame> localGames = results.map((json) {
        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..rating = (json['rating'] as num).toDouble();
      }).toList();

      // Only cache the first page for offline fallback to save space
      if (page == 1) {
        await _localDataSource.cacheGames(localGames);
      }
      debugPrint("loaded games: ${results.length}");
      return localGames.map((e) => e.toEntity()).toList();
    } catch (e) {
      // If we are on page 1 and network fails, show cache
      if (page == 1) {
        final cached = await _localDataSource.getGames();
        if (cached.isEmpty) {
          throw GamesLoadingFailure();
        }
        return cached.map((e) => e.toEntity()).toList();
      }
      rethrow;
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

  @override
  Future<List<FilterEntity>> getFilterMetadata(String endpoint) async {
    // 1. Define the cache key based on the endpoint
    final String cacheKey = endpoint.replaceAll('/', '_');

    // 2. Check if data exists in Isar (Safely)
    List<FilterEntity> cachedData = [];
    DateTime? lastUpdate;

    try {
      cachedData = await _localDataSource.getCachedMetadata(endpoint);
      lastUpdate = await _localDataSource.getLastUpdated(cacheKey);
    } catch (e) {
      debugPrint('Cache read invalid: $e');
      // Continue to fetch from network if cache fails
    }

    // 4. Define your TTL (e.g., 7 days for platforms/tags as they rarely change)
    const Duration cacheTTL = Duration(days: 7);
    final bool isCacheExpired = lastUpdate == null ||
        DateTime.now().difference(lastUpdate) > cacheTTL;

    // 5. If data exists and is NOT expired, return cached data immediately
    if (cachedData.isNotEmpty && !isCacheExpired) {
      return cachedData;
    }

    try {
      // 6. Otherwise, fetch fresh data from API
      final response = await _api.get('/$endpoint');
      final List results = response.data['results'];
      final freshData = results.map((json) => FilterEntity.fromJson(json)).toList();

      // 7. Update Isar with fresh data and new timestamp
      await _localDataSource.saveMetadata(endpoint, freshData);
      await _localDataSource.updateCacheTimestamp(cacheKey);

      return freshData;
    } catch (e) {
      // 8. Fallback: If API fails, return whatever we have in cache, even if expired
      if (cachedData.isNotEmpty) return cachedData;
      rethrow;
    }
  }

  @override
  Future<List<GameEntity>> getDiscoveryGames(DiscoveryFilterState filters, int page) async {
    final queryParams = filters.toQueryParameters(page);

    try {
      final response = await _api.get('/games', queryParameters: queryParams);
      final List results = response.data['results'];
      final List<LocalGame> localGames = results.map((json) {
        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..rating = (json['rating'] as num).toDouble();
      }).toList();

      // Only cache the first page for offline fallback to save space
      if (page == 1) {
        await _localDataSource.cacheGames(localGames);
      }
      debugPrint("loaded games: ${results.length}");
      return localGames.map((e) => e.toEntity()).toList();
    } catch (e) {
      // If we are on page 1 and network fails, show cache
      if (page == 1) {
        final cached = await _localDataSource.getGames();
        return cached.map((e) => e.toEntity()).toList();
      }
      rethrow;
    }
  }

}