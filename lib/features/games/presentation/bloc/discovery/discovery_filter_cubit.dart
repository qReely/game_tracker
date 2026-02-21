import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/domain/entities/game_ordering.dart';
import 'discovery_filter_state.dart';
import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';

class DiscoveryFilterCubit extends Cubit<DiscoveryFilterState> {
  DiscoveryFilterCubit() : super(const DiscoveryFilterState());

  void setOrdering(GameOrdering ordering) => emit(state.copyWith(ordering: ordering));

  void setPlatform(FilterEntity? platform) {
    if (state.platform?.id == platform?.id) {
       emit(state.copyWith(clearPlatform: true));
    } else {
       emit(state.copyWith(platform: platform));
    }
  }

  void setYearRange(int min, int max) => emit(state.copyWith(minYear: min, maxYear: max));
  
  void clearYearRange() => emit(state.copyWith(clearYearRange: true));

  void toggleTag(FilterEntity tag) {
    final newTags = List<FilterEntity>.from(state.tags);
    if (newTags.any((t) => t.id == tag.id)) {
      newTags.removeWhere((t) => t.id == tag.id);
    } else {
      newTags.add(tag);
    }
    emit(state.copyWith(tags: newTags));
  }

  void setSearch(String query) => emit(state.copyWith(searchQuery: query));

  // Quick Filters
  // We use specific IDs to identify them in the Repo
  
  void clearQuickFilter() {
    emit(state.copyWith(clearQuickFilter: true));
  }

  void toggleQuickFilter(String id) {
    if (state.activeQuickFilterId == id) {
      clearQuickFilter();
    } else {
      emit(state.copyWith(activeQuickFilterId: id));
    }
  }

  // Convenience methods now just toggle specific IDs
  // The IDs must match what the Repository expects
  void setLast30Days() => toggleQuickFilter('recent-games-past');
  void setThisWeek() => toggleQuickFilter('recent-games-this-week'); // Not standard API, will handle in Repo
  void setBestOfYear() => toggleQuickFilter('greatest');
  void setPopularThisYear() => toggleQuickFilter('popular-2026');
  void setAllTimeTop() => toggleQuickFilter('popular');

  void setGenre(FilterEntity genre) {
    emit(state.copyWith(genres: [genre], clearQuickFilter: true));
  }

  void setGenreSlug(String slug) {
    emit(state.copyWith(genreSlug: slug, clearQuickFilter: true));
  }

}