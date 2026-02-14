import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum GameStatus { backlog, playing, completed, dropped, wishlist }

extension GameIcons on GameStatus{
  Color get color {
    switch (this) {
      case GameStatus.playing: return Colors.green;
      case GameStatus.completed: return Colors.blue;
      case GameStatus.backlog: return Colors.orange;
      case GameStatus.wishlist: return Colors.pink;
      case GameStatus.dropped: return Colors.red;
    }
  }

  Icon get icon {
    switch (this) {
      case GameStatus.playing: return Icon(Icons.play_arrow, color: color);
      case GameStatus.completed: return Icon(Icons.check_circle, color: color);
      case GameStatus.backlog: return Icon(Icons.inventory_2, color: color);
      case GameStatus.wishlist: return Icon(Icons.favorite, color: color);
      case GameStatus.dropped: return Icon(Icons.delete_forever, color: color);
    }
  }
}

class LibraryItem extends Equatable {
  final int gameId;
  final String gameName;
  final String? posterPath;
  final GameStatus status;
  final double? userRating; // 1-5 stars
  final String? privateNote; // The "Self Note"
  final DateTime addedAt;

  const LibraryItem({
    required this.gameId,
    required this.gameName,
    this.posterPath,
    required this.status,
    this.userRating,
    this.privateNote,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
    gameId,
    gameName,
    posterPath,
    status,
    userRating,
    privateNote,
    addedAt,
  ];
}