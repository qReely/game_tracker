import 'package:isar_community/isar.dart';

import '../../domain/entities/library_item.dart';

part 'local_library_item.g.dart';

@collection
class LocalLibraryItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int gameId;

  late String gameName;
  String? posterPath;

  @enumerated
  late GameStatus status;

  double? userRating;
  String? privateNote;
  List<String>? platforms;
  String? releasedYear;
  int? playtimeMinutes;
  late DateTime addedAt;

  LibraryItem toEntity() {
    return LibraryItem(
      gameId: gameId,
      gameName: gameName,
      posterPath: posterPath,
      status: status,
      userRating: userRating,
      privateNote: privateNote,
      platforms: platforms,
      releasedYear: releasedYear,
      playtimeMinutes: playtimeMinutes,
      addedAt: addedAt,
    );
  }

  static LocalLibraryItem fromEntity(LibraryItem entity) {
    return LocalLibraryItem()
      ..gameId = entity.gameId
      ..gameName = entity.gameName
      ..posterPath = entity.posterPath
      ..status = entity.status
      ..userRating = entity.userRating
      ..privateNote = entity.privateNote
      ..platforms = entity.platforms
      ..releasedYear = entity.releasedYear
      ..playtimeMinutes = entity.playtimeMinutes
      ..addedAt = entity.addedAt;
  }
}