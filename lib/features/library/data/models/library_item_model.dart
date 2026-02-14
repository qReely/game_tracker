import 'package:game_tracker/features/library/domain/entities/library_item.dart';

class LibraryItemModel extends LibraryItem {
  const LibraryItemModel({
    required super.gameId,
    required super.gameName,
    super.posterPath,
    required super.status,
    super.userRating,
    super.privateNote,
    required super.addedAt,
  });

  factory LibraryItemModel.fromJson(Map<String, dynamic> json) {
    return LibraryItemModel(
      gameId: json['gameId'],
      gameName: json['gameName'],
      posterPath: json['posterPath'],
      status: GameStatus.values.byName(json['status']),
      userRating: json['userRating'],
      privateNote: json['privateNote'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'gameName': gameName,
      'posterPath': posterPath,
      'status': status.name,
      'userRating': userRating,
      'privateNote': privateNote,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
