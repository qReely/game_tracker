import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum GameStatus { playing, backlog, completed, wishlist, dropped, none }

extension GameIcons on GameStatus{
  Color get color {
    switch (this) {
      case GameStatus.playing: return Colors.green;
      case GameStatus.completed: return Colors.blue;
      case GameStatus.backlog: return Colors.orange;
      case GameStatus.wishlist: return Colors.pink;
      case GameStatus.dropped: return Colors.red;
      case GameStatus.none: return Colors.transparent;
    }
  }

  Icon get icon {
    switch (this) {
      case GameStatus.playing: return Icon(Icons.play_arrow, color: color);
      case GameStatus.completed: return Icon(Icons.check_circle, color: color);
      case GameStatus.backlog: return Icon(Icons.inventory_2, color: color);
      case GameStatus.wishlist: return Icon(Icons.favorite, color: color);
      case GameStatus.dropped: return Icon(Icons.delete_forever, color: color);
      case GameStatus.none: return Icon(Icons.help_outline, color: color);
    }
  }

  String get description {
    switch (this) {
      case GameStatus.playing: return "Currently enjoying";
      case GameStatus.completed: return "Finished the game";
      case GameStatus.backlog: return "Plan to play";
      case GameStatus.wishlist: return "Want to buy";
      case GameStatus.dropped: return "Stopped playing";
      case GameStatus.none: return "Not in library";
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
  final List<String>? platforms;
  final String? releasedYear;
  final int? playtimeMinutes;
  final DateTime addedAt;

  const LibraryItem({
    required this.gameId,
    required this.gameName,
    this.posterPath,
    required this.status,
    this.userRating,
    this.privateNote,
    this.platforms,
    this.releasedYear,
    this.playtimeMinutes,
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
    platforms,
    releasedYear,
    playtimeMinutes,
    addedAt,
  ];
}