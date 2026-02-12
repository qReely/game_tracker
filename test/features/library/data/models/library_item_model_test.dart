import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/features/library/data/models/library_item_model.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';

void main() {
  final tLibraryItemModel = LibraryItemModel(
    gameId: 1,
    gameName: 'Cyberpunk 2077',
    status: GameStatus.completed,
    addedAt: DateTime(2023, 1, 1),
    userRating: 4.5,
  );

  test('should be a subclass of LibraryItem entity', () {
    expect(tLibraryItemModel, isA<LibraryItem>());
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
          '''
        {
          "gameId": 1,
          "gameName": "Cyberpunk 2077",
          "posterPath": null,
          "status": "completed",
          "userRating": 4.5,
          "privateNote": null,
          "addedAt": "2023-01-01T00:00:00.000"
        }
        '''
      );
      // Act
      final result = LibraryItemModel.fromJson(jsonMap);
      // Assert
      expect(result.gameId, tLibraryItemModel.gameId);
      expect(result.gameName, tLibraryItemModel.gameName);
      expect(result.status, tLibraryItemModel.status);
      expect(result.userRating, tLibraryItemModel.userRating);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      // Act
      final result = tLibraryItemModel.toJson();
      // Assert
      final expectedMap = {
        'gameId': 1,
        'gameName': 'Cyberpunk 2077',
        'posterPath': null,
        'status': 'completed',
        'userRating': 4.5,
        'privateNote': null,
        'addedAt': '2023-01-01T00:00:00.000',
      };
      expect(result, expectedMap);
    });
  });
}
