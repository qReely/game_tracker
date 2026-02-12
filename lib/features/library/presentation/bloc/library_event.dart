import 'package:game_tracker/features/library/domain/entities/library_item.dart';

abstract class LibraryEvent {}
class WatchLibrary extends LibraryEvent {}
class AddGameToLibrary extends LibraryEvent {
  final LibraryItem item;
  AddGameToLibrary(this.item);
}

class RemoveGameFromLibrary extends LibraryEvent {
  final int gameId;
  RemoveGameFromLibrary(this.gameId);
}

class UpdateStatus extends LibraryEvent {
  final int gameId;
  final GameStatus status;
  UpdateStatus(this.gameId, this.status);
}

class UpdateUserRating extends LibraryEvent {
  final int gameId;
  final double rating;
  UpdateUserRating(this.gameId, this.rating);
}

class UpdatePrivateNote extends LibraryEvent {
  final int gameId;
  final String note;
  UpdatePrivateNote(this.gameId, this.note);
}