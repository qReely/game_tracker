import 'package:equatable/equatable.dart';
import '../../domain/entities/library_item.dart';

class LibraryFilterState extends Equatable {
  final Set<GameStatus> selectedStatuses;
  final String searchQuery;
  final List<String> platforms;
  final int? minYear;
  final int? maxYear;

  const LibraryFilterState({
    this.selectedStatuses = const {},
    this.searchQuery = '',
    this.platforms = const [],
    this.minYear,
    this.maxYear,
  });

  int get activeFilterCount {
    int count = 0;
    if (selectedStatuses.isNotEmpty) count++;
    if (platforms.isNotEmpty) count++;
    if (minYear != null && maxYear != null) count++;
    return count;
  }

  LibraryFilterState copyWith({
    Set<GameStatus>? selectedStatuses,
    String? searchQuery,
    List<String>? platforms,
    int? minYear,
    int? maxYear,
    bool clearYearRange = false,
  }) {
    return LibraryFilterState(
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
      searchQuery: searchQuery ?? this.searchQuery,
      platforms: platforms ?? this.platforms,
      minYear: clearYearRange ? null : (minYear ?? this.minYear),
      maxYear: clearYearRange ? null : (maxYear ?? this.maxYear),
    );
  }

  @override
  List<Object?> get props => [selectedStatuses, searchQuery, platforms, minYear, maxYear];
}