import 'package:flutter/foundation.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:game_tracker/features/games/data/datasources/game_local_data_source.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
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
        final String? released = json['released'];
        final String? year = released != null && released.isNotEmpty
            ? released
            .split('-')
            .first
            : null;

        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..rating = (json['rating'] as num).toDouble()
          ..releasedYear = year;
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
  Future<List<GameEntity>> getGameCalendar(int year, int month, int page,
      {String ordering = '-released'}) async {
    try {
      final response = await _api.get(
        '/games/calendar/$year/$month',
        queryParameters: {
          'page': page,
          'page_size': 20,
          'ordering': ordering,
          'popular': 'false',
        },
      );

      final List results = response.data['results'];
      final List<LocalGame> localGames = results.map((json) {
        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..rating = (json['rating'] as num).toDouble()
          ..releasedDate = json['released']
          ..releasedYear = json['released'] != null &&
              json['released'].isNotEmpty
              ? json['released']
              .split('-')
              .first
              : null;
      }).toList();

      return localGames.map((e) => e.toEntity()).toList();
    } catch (e) {
      debugPrint("API Error in getGameCalendar: $e");
      rethrow;
    }
  }

  @override
  Future<List<GameEntity>> getGamesByCompany({
    required String companySlug,
    required bool isPublisher,
    DiscoveryFilterState? filters,
    int page = 1,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        isPublisher ? 'publishers' : 'developers': companySlug,
        'page': page,
        'page_size': 20,
      };

      if (filters != null) {
        final filterParams = filters.toQueryParameters(page);
        queryParameters.addAll(filterParams);
        // Ensure the company filter is preserved and not overridden by filter state
        queryParameters[isPublisher ? 'publishers' : 'developers'] =
            companySlug;
      }

      final response = await _api.get(
          '/games', queryParameters: queryParameters);

      final List results = response.data['results'];
      final List<LocalGame> localGames = results.map((json) {
        return LocalGame()
          ..rawgId = json['id']
          ..name = json['name']
          ..backgroundImage = json['background_image']
          ..releasedYear = json['released'] != null &&
              json['released'].isNotEmpty
              ? json['released']
              .split('-')
              .first
              : null
          ..rating = (json['rating'] as num).toDouble();
      }).toList();

      return localGames.map((e) => e.toEntity()).toList();
    } catch (e) {
      debugPrint("API Error in getGamesByCompany: $e");
      rethrow;
    }
  }
}
