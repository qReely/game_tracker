import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/widgets/app_filter_chip.dart';
import 'package:game_tracker/features/library/data/models/library_view_model.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_cubit.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_state.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_grid.dart';
import 'package:rxdart/rxdart.dart';
import 'package:game_tracker/core/widgets/app_search_bar.dart';
import 'package:game_tracker/features/library/presentation/widgets/library_filter_sheet.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Library"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<LibraryViewModel>(
        stream: Rx.combineLatest2<LibraryState, LibraryFilterState, LibraryViewModel>(
          context.read<LibraryBloc>().stream.startWith(context.read<LibraryBloc>().state),
          context.read<LibraryFilterCubit>().stream.startWith(context.read<LibraryFilterCubit>().state),
          (libState, filterState) {
            if (libState is LibraryLoaded) {
              final items = libState.items.where((item) {
                // 1. Status Filter (Multi-select)
                final matchesStatus = filterState.selectedStatuses.isEmpty || 
                    filterState.selectedStatuses.contains(item.status);
                
                // 2. Search Query
                final matchesSearch = filterState.searchQuery.isEmpty || 
                    item.gameName.toLowerCase().contains(filterState.searchQuery.toLowerCase());
                
                // 3. Platform Filter
                final matchesPlatform = filterState.platforms.isEmpty || 
                    (item.platforms != null && filterState.platforms.any((p) => item.platforms!.contains(p)));
                
                // 4. Year Filter
                bool matchesYear = true;
                if (filterState.minYear != null && filterState.maxYear != null && item.releasedYear != null) {
                  final year = int.tryParse(item.releasedYear!);
                  if (year != null) {
                    matchesYear = year >= filterState.minYear! && year <= filterState.maxYear!;
                  }
                }

                return matchesStatus && matchesSearch && matchesPlatform && matchesYear;
              }).toList();

              return LibraryViewModel(items); // Status is now handled via Cubit state
            }
            return LibraryViewModel([]);
          },
        ),
        builder: (context, snapshot) {
          final viewModel = snapshot.data;

          if (viewModel == null || context.read<LibraryBloc>().state is LibraryLoading) {
            return GameGrid(games: [], isLoading: true,);
          }

          return Column(
            children: [
              // Search & Filter Bar
              BlocBuilder<LibraryFilterCubit, LibraryFilterState>(
                builder: (context, filterState) {
                  return AppSearchBar(
                    hintText: "Search in library...",
                    initialValue: filterState.searchQuery,
                    activeFilterCount: filterState.activeFilterCount,
                    onChanged: (query) => context.read<LibraryFilterCubit>().setSearch(query),
                    onFilterPressed: () => _showFilterSheet(context),
                  );
                },
              ),

              // Status Chips (Multi-select)
              _buildStatusChips(context),

              // Library Grid
              Expanded(
                child: viewModel.items.isEmpty
                    ? Center(child: Text("No games found here.", style: Theme.of(context).textTheme.bodyLarge))
                    : GameGrid(
                        games: viewModel.items.map((item) => GameEntity(
                          id: item.gameId,
                          name: item.gameName,
                          backgroundImage: item.posterPath,
                          rating: item.userRating ?? 0.0,
                          releasedYear: item.releasedYear,
                        )).toList(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusChips(BuildContext context) {
    return BlocBuilder<LibraryFilterCubit, LibraryFilterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.sm.h),
          child: Row(
            children: GameStatus.values.where((s) => s != GameStatus.none).map((status) {
              final isSelected = state.selectedStatuses.contains(status);
              return Padding(
                padding: EdgeInsets.only(right: Dimens.sm.w),
                child: AppFilterChip(
                  label: status.name[0].toUpperCase() + status.name.substring(1),
                  isSelected: isSelected,
                  onSelected: (_) => context.read<LibraryFilterCubit>().toggleStatus(status),
                  selectedColor: status.color,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: Dimens.sheetMaxWidth,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<LibraryFilterCubit>()),
            BlocProvider.value(value: context.read<LibraryBloc>()),
          ],
          child: const LibraryFilterSheet(),
        );
      },
    );
  }
}