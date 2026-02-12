import 'package:game_tracker/features/library/domain/entities/library_item.dart';

class LibraryFilterState {
  final GameStatus? status;
  final String searchQuery;

  LibraryFilterState({this.status, this.searchQuery = ''});

  // Tip: Add a copyWith for easy updates
  LibraryFilterState copyWith({GameStatus? status, String? searchQuery, bool clearStatus = false}) {
    return LibraryFilterState(
      status: clearStatus ? null : (status ?? this.status),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}