import 'package:game_tracker/features/library/domain/entities/library_item.dart';

abstract class LibraryRepository {
  // Local/Private Actions
  Future<void> addToLibrary(LibraryItem item);
  Future<void> updateGameStatus(int gameId, GameStatus newStatus);
  Future<void> updatePrivateNote(int gameId, String note);
  Future<void> removeFromLibrary(int gameId);
  Future<void> updateUserRating(int gameId, double rating);
  Future<void> syncLocalToRemote();


  // Public/Social Actions
  Stream<List<LibraryItem>> getMyLibrary();
  Future<List<LibraryItem>> getUserLibrary(String userId);


}