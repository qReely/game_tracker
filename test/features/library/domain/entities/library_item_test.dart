import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';

void main() {
  group('LibraryItem', () {
    final tLibraryItem = LibraryItem(
      gameId: 1,
      gameName: 'The Legend of Zelda',
      posterPath: '/path/to/poster.jpg',
      status: GameStatus.playing,
      userRating: 5.0,
      privateNote: 'A masterpiece!',
      addedAt: DateTime(2023, 10, 27),
    );

    test('should create a LibraryItem instance with correct properties', () {
      // Assert
      expect(tLibraryItem.gameId, 1);
      expect(tLibraryItem.gameName, 'The Legend of Zelda');
      expect(tLibraryItem.posterPath, '/path/to/poster.jpg');
      expect(tLibraryItem.status, GameStatus.playing);
      expect(tLibraryItem.userRating, 5.0);
      expect(tLibraryItem.privateNote, 'A masterpiece!');
      expect(tLibraryItem.addedAt, DateTime(2023, 10, 27));
    });

    test('should support value equality', () {
      // Arrange
      final anotherLibraryItem = LibraryItem(
        gameId: 1,
        gameName: 'The Legend of Zelda',
        posterPath: '/path/to/poster.jpg',
        status: GameStatus.playing,
        userRating: 5.0,
        privateNote: 'A masterpiece!',
        addedAt: DateTime(2023, 10, 27),
      );
      // Assert - Assuming you override equals and hashCode or use a package like Equatable
      expect(tLibraryItem, equals(anotherLibraryItem));
    });
  });

  group('GameStatus Extensions', () {
    test('GameIcons extension should return correct icon and color for each status', () {
      // Playing
      expect(GameStatus.playing.icon.icon, equals(Icons.play_arrow));
      expect(GameStatus.playing.color, equals(Colors.green));

      // Completed
      expect(GameStatus.completed.icon.icon, equals(Icons.check_circle));
      expect(GameStatus.completed.color, equals(Colors.blue));

      // Backlog
      expect(GameStatus.backlog.icon.icon, equals(Icons.inventory_2));
      expect(GameStatus.backlog.color, equals(Colors.orange));

      // Wishlist
      expect(GameStatus.wishlist.icon.icon, equals(Icons.favorite));
      expect(GameStatus.wishlist.color, equals(Colors.pink));

      // Dropped
      expect(GameStatus.dropped.icon.icon, equals(Icons.delete_forever));
      expect(GameStatus.dropped.color, equals(Colors.red));
    });
  });
}
