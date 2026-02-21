import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_state.dart';
import 'package:game_tracker/core/widgets/app_search_bar.dart';
import 'dart:async';
import 'package:game_tracker/features/games/presentation/widgets/card/game_grid.dart';
import 'package:game_tracker/features/games/presentation/widgets/discovery/discovery_filter_sheet.dart';
import 'package:game_tracker/features/games/presentation/widgets/discovery/discovery_quick_filters.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
// ...
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<DiscoveryBloc>().add(LoadNextDiscoveryPage());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<DiscoveryFilterCubit>().setSearch(query);
      context.read<DiscoveryBloc>().add(RefreshDiscovery());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Discover Games"),
      ),
      body: Column(
        children: [
          BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
            builder: (context, filterState) {
              return AppSearchBar(
                hintText: "Find your next adventure...",
                initialValue: filterState.searchQuery,
                activeFilterCount: filterState.activeFilterCount,
                onChanged: _onSearchChanged,
                onFilterPressed: () => _showFilterSheet(context),
              );
            },
          ),
          const DiscoveryQuickFilters(), // Added Quick Filters
          _buildFilterSummary(context),
          Expanded(
            child: BlocBuilder<DiscoveryBloc, DiscoveryState>(
              builder: (context, state) {
                if (state is DiscoveryInitial || state is DiscoveryLoading) {
                  return const GameGrid(games: [], isLoading: true);
                }

                if (state is DiscoveryLoaded) {
                  if (state.games.isEmpty) {
                    return const Center(child: Text("No games found with these filters"));
                  }
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        GameGrid(games: state.games),
                        if (!state.hasReachedMax)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text("An error occurred. Please try again."));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSummary(BuildContext context) {
    return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
      builder: (context, state) {
        if (state.activeFilterCount == 0) return const SizedBox();

        final parts = <String>[];
        if (state.platform != null) parts.add(state.platform!.name);
        if (state.genres.isNotEmpty) parts.add(state.genres.map((e) => e.name).join(", "));
        if (state.tags.isNotEmpty) parts.add(state.tags.map((e) => e.name).join(", "));
        
        String summary = "Games";
        if (parts.isNotEmpty) {
          summary = "${parts.join(" / ")} games";
        }

        if (state.minYear != null && state.maxYear != null) {
          summary += " of ${state.minYear}-${state.maxYear}";
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.sm.h),
          color: AppColors.surface,
          child: Text(
            summary,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    final discoveryBloc = context.read<DiscoveryBloc>();
    final filterCubit = context.read<DiscoveryFilterCubit>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: Dimens.sheetMaxWidth,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: filterCubit),
            BlocProvider.value(value: discoveryBloc),
          ],
          child: DiscoveryFilterSheet(
            onApply: () => discoveryBloc.add(RefreshDiscovery()),
          ),
        );
      },
    );
  }
}