import 'package:flutter/foundation.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:game_tracker/core/domain/entities/genre_entity.dart';
import 'package:game_tracker/features/games/data/datasources/game_local_data_source.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/repositories/discovery_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final ApiClient _api;
  final GameLocalDataSource _localDataSource;
  final FirebaseFirestore _firestore;

  DiscoveryRepositoryImpl(this._api, this._localDataSource, this._firestore);

  @override
  Future<List<FilterEntity>> getFilterMetadata(String endpoint) async {
    final String cacheKey = endpoint.replaceAll('/', '_');
    List<FilterEntity> cachedData = [];
    DateTime? lastUpdate;

    try {
      cachedData = await _localDataSource.getCachedMetadata(endpoint);
      lastUpdate = await _localDataSource.getLastUpdated(cacheKey);
    } catch (e) {
      debugPrint('Cache read invalid: $e');
    }

    const Duration cacheTTL = Duration(days: 1);
    final bool isCacheExpired = lastUpdate == null ||
        DateTime.now().difference(lastUpdate) > cacheTTL;

    if (cachedData.isNotEmpty && !isCacheExpired) {
      return cachedData;
    }

    try {
      final response = await _api.get('/$endpoint');
      final List results = response.data['results'];
      final freshData = results.map((json) => FilterEntity.fromJson(json)).toList();

      await _localDataSource.saveMetadata(endpoint, freshData);
      await _localDataSource.updateCacheTimestamp(cacheKey);

      return freshData;
    } catch (e) {
      if (cachedData.isNotEmpty) return cachedData;
      rethrow;
    }
  }

  @override
  Future<List<GameEntity>> getDiscoveryGames(DiscoveryFilterState filters, int page) async {
    final queryParams = filters.toQueryParameters(page);
    String endpoint = '/games';

    if (queryParams.containsKey('quick_filter')) {
      final String filterId = queryParams['quick_filter'];
      queryParams.remove('quick_filter');
      
      queryParams['discover'] = 'true';
      queryParams['page_size'] = 20;

      switch (filterId) {
        case 'recent-games-past':
          endpoint = '/games/lists/recent-games-past';
          queryParams['ordering'] = '-added';
          break;
        case 'greatest':
          endpoint = '/games/lists/greatest';
          queryParams['ordering'] = '-added';
          break;
        case 'popular':
          endpoint = '/games/lists/popular';
          break;
        case 'popular-2026':
          endpoint = '/games/lists/greatest';
          queryParams['year'] = '2025';
          queryParams['ordering'] = '-added';
          break;
        case 'recent-games-this-week':
          endpoint = '/games';
          final now = DateTime.now();
          final start = now.subtract(Duration(days: now.weekday - 1));
          final end = start.add(const Duration(days: 6));
          queryParams['dates'] = "${start.toIso8601String().split('T')[0]},${end.toIso8601String().split('T')[0]}";
          queryParams['ordering'] = '-released';
          break;
      }
    }

    try {
      final response = await _api.get(endpoint, queryParameters: queryParams);
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
      if (page == 1) {
         final cached = await _localDataSource.getGames();
         return cached.map((e) => e.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<GenreEntity>> getGenres() async {
    try {
      final response = await _api.get('/genres');
      final List results = response.data['results'];
      return results.map((json) => GenreEntity.fromJson(json)).toList();
    } catch (e) {
      debugPrint("API Error in getGenres: $e");
      rethrow;
    }
  }

  @override
  Future<List<GameEntity>> getPopularCommunityGames() async {
    try {
      // 1. Get top 20 game IDs by votes from Firestore
      final snapshot = await _firestore
          .collection('ratings')
          .orderBy('totalVotes', descending: true)
          .limit(20)
          .get();

      if (snapshot.docs.isEmpty) return [];

      final gameIds = snapshot.docs.map((doc) => doc.id).join(',');

      // 2. Fetch game details from RAWG using the IDs
      final response = await _api.get('/games', queryParameters: {
        'ids': gameIds,
        'page_size': 20,
      });

      final List results = response.data['results'];
      
      // Sort results back to match the order from Firestore if needed, 
      // but RAWG doesn't strictly guarantee order by 'ids' list.
      // However, for "Popular in community", the Firestore order is the source of truth.
      final List<int> orderedIds = snapshot.docs.map((doc) => int.parse(doc.id)).toList();
      
      final List<GameEntity> games = results.map((json) {
        return (LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..releasedYear = json['released'] != null && json['released'].isNotEmpty
            ? json['released'].split('-').first
            : null
          ..rating = (json['rating'] as num).toDouble())
        .toEntity();
      }).toList();

      // Sort according to Firestore order
      games.sort((a, b) {
        final indexA = orderedIds.indexOf(a.id);
        final indexB = orderedIds.indexOf(b.id);
        return indexA.compareTo(indexB);
      });

      return games;
    } catch (e) {
      debugPrint("Error in getPopularCommunityGames: $e");
      return [];
    }
  }
}


