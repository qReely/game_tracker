import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_state.dart';

class LibraryFilterCubit extends Cubit<LibraryFilterState> {
  LibraryFilterCubit() : super(const LibraryFilterState());

  void toggleStatus(GameStatus status) {
    final newStatuses = Set<GameStatus>.from(state.selectedStatuses);
    if (newStatuses.contains(status)) {
      newStatuses.remove(status);
    } else {
      newStatuses.add(status);
    }
    emit(state.copyWith(selectedStatuses: newStatuses));
  }

  void setSearch(String query) => emit(state.copyWith(searchQuery: query));

  void setYearRange(int min, int max) => emit(state.copyWith(minYear: min, maxYear: max));
  
  void clearYearRange() => emit(state.copyWith(clearYearRange: true));

  void togglePlatform(String platform) {
    final newPlatforms = List<String>.from(state.platforms);
    if (newPlatforms.contains(platform)) {
      newPlatforms.remove(platform);
    } else {
      newPlatforms.add(platform);
    }
    emit(state.copyWith(platforms: newPlatforms));
  }

  void reset() => emit(const LibraryFilterState());
}