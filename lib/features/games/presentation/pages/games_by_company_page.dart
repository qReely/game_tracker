import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/presentation/bloc/company/games_by_company_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/company/games_by_company_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/company/games_by_company_state.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_grid.dart';
import 'package:game_tracker/features/games/presentation/widgets/discovery/discovery_filter_sheet.dart';
import 'package:game_tracker/core/widgets/app_search_bar.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';

class GamesByCompanyPage extends StatefulWidget {
  final String companySlug;
  final String companyName;
  final bool isPublisher;

  const GamesByCompanyPage({
    super.key,
    required this.companySlug,
    required this.companyName,
    required this.isPublisher,
  });

  @override
  State<GamesByCompanyPage> createState() => _GamesByCompanyPageState();
}

class _GamesByCompanyPageState extends State<GamesByCompanyPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  late final GamesByCompanyBloc _bloc;
  late final DiscoveryFilterCubit _filterCubit;

  @override
  void initState() {
    super.initState();
    _filterCubit = DiscoveryFilterCubit();
    _bloc = sl.get<GamesByCompanyBloc>(param1: _filterCubit)
      ..add(FetchGamesByCompany(
        companySlug: widget.companySlug,
        isPublisher: widget.isPublisher,
      ));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      _bloc.add(LoadMoreGamesByCompany(
        companySlug: widget.companySlug,
        isPublisher: widget.isPublisher,
      ));
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
      _filterCubit.setSearch(query);
      _bloc.add(RefreshGamesByCompany());
    });
  }

  void _showFilterSheet() {
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
            BlocProvider.value(value: _filterCubit),
            BlocProvider.value(value: _bloc),
          ],
          child: DiscoveryFilterSheet(
            onApply: () => _bloc.add(RefreshGamesByCompany()),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bloc),
        BlocProvider.value(value: _filterCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            widget.companyName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          leading: IconButton(
            icon: Icon(AppIcons.back, color: Colors.white, size: Dimens.iconMd.sp),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
              builder: (context, filterState) {
                return AppSearchBar(
                  hintText: "Search in ${widget.companyName}...",
                  initialValue: filterState.searchQuery,
                  activeFilterCount: filterState.activeFilterCount,
                  onChanged: _onSearchChanged,
                  onFilterPressed: _showFilterSheet,
                );
              },
            ),
            _buildFilterSummary(),
            Expanded(
              child: BlocBuilder<GamesByCompanyBloc, GamesByCompanyState>(
                builder: (context, state) {
                  if (state is GamesByCompanyLoading) {
                    return GameGrid(games: [], isLoading: true,);
                  }

                  if (state is GamesByCompanyError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  if (state is GamesByCompanyLoaded) {
                    if (state.games.isEmpty) {
                      return Center(
                        child: Text(
                          "No games found",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimens.md.w),
                            child: GameGrid(games: state.games),
                          ),
                          if (!state.hasReachedMax)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: CircularProgressIndicator(color: AppColors.primary),
                            ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSummary() {
    return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
      builder: (context, state) {
        if (state.activeFilterCount == 0) return const SizedBox.shrink();

        final parts = <String>[];
        if (state.platform != null) parts.add(state.platform!.name);
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
}
