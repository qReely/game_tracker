import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_ordering.dart';

class DiscoveryFilterState {
  final GameOrdering ordering;
  final FilterEntity? platform;
  final int? minYear;
  final int? maxYear;
  final List<FilterEntity> tags;
  final String searchQuery;
  final String? dates; // e.g. "2023-01-01,2023-12-31"
  final String? activeQuickFilterId;
  final List<FilterEntity> genres;
  final String? genreSlug;

  const DiscoveryFilterState({
    this.ordering = GameOrdering.popularity,
    this.platform,
    this.minYear,
    this.maxYear,
    this.tags = const [],
    this.searchQuery = '',
    this.dates,
    this.activeQuickFilterId,
    this.genres = const [],
    this.genreSlug,
  });

  Map<String, dynamic> toQueryParameters(int page) {
    // If a quick filter is active, we might return a special map
    // or the repository will handle the endpoint switching based on activeQuickFilterId.
    // For now, let's include it in the params so the Repo knows what to do.
    // BUT, if it is standalone, we still might need paging.
    
    final Map<String, dynamic> params = {
      'page': page,
      'page_size': 20,
    };

    // If Standalone Quick Filter is ACTIVE, we generally ignore other filters
    // UNLESS we want to allow searching within a quick list (optional, but user said "filtering and search will not apply")
    // So we just return the basics + the ID for the Repo to use.
    if (activeQuickFilterId != null) {
      params['quick_filter'] = activeQuickFilterId;
      // We might need to pass partial params if the logic is hybrid, 
      // but based on "filtering and search will not apply", we return clean params.
      return params; 
    }

    // Normal behavior
    params['ordering'] = ordering.value;

    if (searchQuery.isNotEmpty) {
      params['search'] = searchQuery;
    }

    if (platform != null) {
      params['parent_platforms'] = platform!.id;
    }

    if (dates != null) {
      params['dates'] = dates;
    } else if (minYear != null && maxYear != null) {
      params['dates'] = '$minYear-01-01,$maxYear-12-31';
    }

    if (genres.isNotEmpty) {
      params['genres'] = genres.map((g) => g.id).join(',');
    } else if (genreSlug != null) {
      params['genres'] = genreSlug;
    }

    return params;
  }

  int get activeFilterCount {
    if (activeQuickFilterId != null) return 0; // Quick filter doesn't count as a "filter" in the bar? Or maybe it does?
    // User said: "filtering and search will not apply to them". 
    // So if quick filter is on, the search bar filter count should probably be 0 or show the chip separately.
    
    int count = 0;
    if (platform != null) count++;
    if (minYear != null && maxYear != null) count++;
    if (dates != null) count++;
    if (tags.isNotEmpty) count++;
    if (genres.isNotEmpty) count++;
    if (searchQuery.isNotEmpty) count++;
    return count;
  }

  DiscoveryFilterState copyWith({
    GameOrdering? ordering,
    FilterEntity? platform,
    bool clearPlatform = false,
    int? minYear,
    int? maxYear,
    bool clearYearRange = false,
    List<FilterEntity>? tags,
    String? searchQuery,
    String? dates,
    bool clearDates = false,
    String? activeQuickFilterId,
    bool clearQuickFilter = false,
    List<FilterEntity>? genres,
    String? genreSlug,
  }) {
    return DiscoveryFilterState(
      ordering: ordering ?? this.ordering,
      platform: clearPlatform ? null : (platform ?? this.platform),
      minYear: clearYearRange ? null : (minYear ?? this.minYear),
      maxYear: clearYearRange ? null : (maxYear ?? this.maxYear),
      tags: tags ?? this.tags,
      searchQuery: searchQuery ?? this.searchQuery,
      dates: clearDates ? null : (dates ?? this.dates),
      activeQuickFilterId: clearQuickFilter ? null : (activeQuickFilterId ?? this.activeQuickFilterId),
      genres: genres ?? this.genres,
      genreSlug: genreSlug ?? this.genreSlug,
    );
  }
}