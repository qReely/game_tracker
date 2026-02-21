import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/widgets/app_search_bar.dart';
import 'package:game_tracker/features/games/presentation/bloc/genre/genre_games_bloc.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_grid.dart';
import 'package:game_tracker/features/games/presentation/widgets/discovery/discovery_filter_sheet.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';
import 'dart:async';

class GenreGamesPage extends StatefulWidget {
  final String genreSlug;
  final String genreName;

  const GenreGamesPage({
    super.key, 
    required this.genreSlug, 
    required this.genreName
  });

  @override
  State<GenreGamesPage> createState() => _GenreGamesPageState();
}

class _GenreGamesPageState extends State<GenreGamesPage> {
  final ScrollController _scrollController = ScrollController();
  final DiscoveryFilterCubit _filterCubit = DiscoveryFilterCubit();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Initialize filters with the current genre
    _filterCubit.setGenreSlug(widget.genreSlug);
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<GenreGamesBloc>().add(LoadMoreGenreGames());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterCubit.setSearch(query);
      context.read<GenreGamesBloc>().add(FetchGamesByGenre(widget.genreSlug, filters: _filterCubit.state));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    _filterCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _filterCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text("${widget.genreName} Games"),
          centerTitle: false,
          actions: [
            BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showFilterSheet(context),
                    ),
                    if (state.activeFilterCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '${state.activeFilterCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(width: Dimens.md.w),
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
              builder: (context, state) {
                return AppSearchBar(
                  hintText: "Search in ${widget.genreName}...",
                  initialValue: state.searchQuery,
                  onChanged: _onSearchChanged,
                  onFilterPressed: () => _showFilterSheet(context),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<GenreGamesBloc, GenreGamesState>(
                builder: (context, state) {
                  if (state is GenreGamesInitial || state is GenreGamesLoading) {
                    return const GameGrid(games: [], isLoading: true);
                  }
  
                  if (state is GenreGamesError) {
                    return Center(child: Text(state.message));
                  }
  
                  if (state is GenreGamesLoaded) {
                    if (state.games.isEmpty) {
                      return const Center(child: Text("No games found."));
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
  
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
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
      builder: (innerContext) {
        return BlocProvider.value(
          value: _filterCubit,
          child: DiscoveryFilterSheet(
            showGenres: false,
            onApply: () {
              context.read<GenreGamesBloc>().add(FetchGamesByGenre(widget.genreSlug, filters: _filterCubit.state));
            },
          ),
        );
      },
    );
  }
}
