import 'package:game_tracker/features/games/domain/entities/filter_entity.dart';
import 'package:game_tracker/features/games/domain/entities/game_ordering.dart';

class DiscoveryFilterState {
  final GameOrdering ordering;
  final FilterEntity? platform;
  final int? minYear;
  final int? maxYear;
  final List<FilterEntity> tags;

  const DiscoveryFilterState({
    this.ordering = GameOrdering.popularity,
    this.platform,
    this.minYear,
    this.maxYear,
    this.tags = const [],
  });

  Map<String, dynamic> toQueryParameters(int page) {
    final Map<String, dynamic> params = {
      'page': page,
      'page_size': 20,
      'ordering': ordering.value,
    };

    if (platform != null) {
      params['parent_platforms'] = platform!.id;
    }

    if (minYear != null && maxYear != null) {
      params['dates'] = '$minYear-01-01,$maxYear-12-31';
    }

    if (tags.isNotEmpty) {
      params['tags'] = tags.map((t) => t.id).join(',');
    }

    return params;
  }

  int get activeFilterCount {
    int count = 0;
    if (platform != null) count++;
    if (minYear != null && maxYear != null) count++;
    if (tags.isNotEmpty) count++;
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
  }) {
    return DiscoveryFilterState(
      ordering: ordering ?? this.ordering,
      platform: clearPlatform ? null : (platform ?? this.platform),
      minYear: clearYearRange ? null : (minYear ?? this.minYear),
      maxYear: clearYearRange ? null : (maxYear ?? this.maxYear),
      tags: tags ?? this.tags,
    );
  }
}