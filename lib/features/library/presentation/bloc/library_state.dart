import 'package:game_tracker/features/library/domain/entities/library_item.dart';

abstract class LibraryState {}
class LibraryInitial extends LibraryState {}
class LibraryLoading extends LibraryState {}
class LibraryLoaded extends LibraryState {
  final List<LibraryItem> items;
  LibraryLoaded(this.items);
}
class LibraryLoadingError extends LibraryState {
  final String message;
  LibraryLoadingError(this.message);
}