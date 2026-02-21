import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository _repository;

  LibraryBloc(this._repository) : super(LibraryInitial()) {
    on<WatchLibrary>((event, emit) async {
      emit(LibraryLoading());
      // Listen to the stream of items (Isar handles real-time updates)
      await emit.forEach<List<LibraryItem>>(
        _repository.getMyLibrary(),
        onData: (items) => LibraryLoaded(List<LibraryItem>.from(items)),
      );
    });

    on<AddGameToLibrary>((event, emit) async {
      await _repository.addToLibrary(event.item);
    });

    on<RemoveGameFromLibrary>((event, emit) async {
      await _repository.removeFromLibrary(event.gameId);
    });

    on<UpdateStatus>((event, emit) async {
      await _repository.updateGameStatus(event.gameId, event.status);
    });

    on<UpdateUserRating>((event, emit) async {
      await _repository.updateUserRating(event.gameId, event.rating);
    });

    on<UpdatePrivateNote>((event, emit) async {
      await _repository.updatePrivateNote(event.gameId, event.note);
    });

    on<UpdatePlaytime>((event, emit) async {
      await _repository.updatePlaytime(event.gameId, event.minutes);
    });
  }
}