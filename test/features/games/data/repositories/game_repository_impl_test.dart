import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/core/network/api_client.dart';
import 'package:game_tracker/features/games/data/datasources/game_local_data_source.dart';
import 'package:game_tracker/features/games/data/models/local_game.dart';
import 'package:game_tracker/features/games/data/repositories/game_repository_impl.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockLocalDataSource extends Mock implements GameLocalDataSource {}

void main() {
  late GameRepositoryImpl repository;
  late MockApiClient mockApi;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockApi = MockApiClient();
    mockLocalDataSource = MockLocalDataSource();
    repository = GameRepositoryImpl(mockApi, mockLocalDataSource);
  });

  group('getTrendingGames', () {
    final tGameModel = LocalGame()..rawgId = 1..name = 'Test Game'..rating = 5.0..backgroundImage = 'img.jpg';
    final tGameList = [tGameModel];
    final tJson = {'results': [{'id': 1, 'name': 'Test Game', 'rating': 5.0, 'background_image': 'img.jpg'}]};

    test('should return remote data when the call to API is successful', () async {
      // Arrange
      when(() => mockApi.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(data: tJson, statusCode: 200, requestOptions: RequestOptions()));

      when(() => mockLocalDataSource.cacheGames(any())).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getTrendingGames();

      // Assert
      expect(result, isA<List<GameEntity>>());
      verify(() => mockApi.get('/games', queryParameters: any(named: 'queryParameters'))).called(1);
      verify(() => mockLocalDataSource.cacheGames(any())).called(1);
    });

    test('should return cached data when API fails', () async {
      // Arrange
      when(() => mockApi.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(Exception());
      when(() => mockLocalDataSource.getGames()).thenAnswer((_) async => tGameList);

      // Act
      final result = await repository.getTrendingGames();

      // Assert
      verify(() => mockLocalDataSource.getGames()).called(1);
      expect(result.first.name, 'Test Game');
    });

    test('should throw GamesLoadingFailure when API fails AND Cache is empty', () async {
      // Arrange
      when(() => mockApi.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(Exception());
      when(() => mockLocalDataSource.getGames()).thenAnswer((_) async => []);

      // Act & Assert
      expect(() => repository.getTrendingGames(), throwsA(isA<GamesLoadingFailure>()));
    });
  });
}