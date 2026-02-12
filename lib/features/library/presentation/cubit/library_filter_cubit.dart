import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_state.dart';

class LibraryFilterCubit extends Cubit<LibraryFilterState> {
  LibraryFilterCubit() : super(LibraryFilterState());

  void setStatus(GameStatus? status) {
    if (status == null || state.status == status) {
      emit(state.copyWith(clearStatus: true));
    }
    else {
      emit(state.copyWith(status: status));
    }
  }

  void setSearch(String query) => emit(state.copyWith(searchQuery: query));
}