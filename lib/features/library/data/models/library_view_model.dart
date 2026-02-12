import 'package:game_tracker/features/library/domain/entities/library_item.dart';

class LibraryViewModel {
  final List<LibraryItem> items;
  final GameStatus? activeFilter;

  LibraryViewModel(this.items, this.activeFilter);
}