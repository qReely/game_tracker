import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/widgets/app_filter_chip.dart';
import 'package:game_tracker/core/widgets/app_search_bar.dart';
import 'package:game_tracker/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:game_tracker/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:game_tracker/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_card.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_grid.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final ScrollController _scrollController;
  late int _selectedMonth; // 1-12
  final int _year = DateTime.now().year;
  String _searchQuery = '';
  String _ordering = '-released';

  static const _orderingOptions = [
    {'label': 'Release Date', 'value': '-released'},
    {'label': 'Name', 'value': 'name'},
    {'label': 'Popularity', 'value': '-added'},
    {'label': 'Rating', 'value': '-rating'},
    {'label': 'Date Added', 'value': '-created'},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _selectedMonth = DateTime.now().month;
    _fetchSelectedMonth();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ScheduleBloc>().add(LoadNextSchedulePage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _fetchSelectedMonth() {
    context.read<ScheduleBloc>().add(
      FetchScheduleGames(year: _year, month: _selectedMonth, ordering: _ordering),
    );
  }

  int get _activeFilterCount => _ordering != '-released' ? 1 : 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Schedule $_year"),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search Bar with filter button
          AppSearchBar(
            hintText: "Search upcoming games...",
            activeFilterCount: _activeFilterCount,
            onChanged: (query) => setState(() => _searchQuery = query),
            onFilterPressed: () => _showOrderSheet(context),
          ),

          // Month Chips
          _buildMonthChips(),

          // Game Grid
          Expanded(
            child: BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                  if (state is ScheduleInitial || state is ScheduleLoading) {
                  return GameGrid(games: [], isLoading: true);
                }

                if (state is ScheduleError) {
                  return Center(
                    child: Text('Error: ${state.message}', style: TextStyle(color: AppColors.error)),
                  );
                }

                if (state is ScheduleLoaded) {
                  // Apply local search filter
                  final filteredGames = _searchQuery.isEmpty
                      ? state.games
                      : state.games.where((g) =>
                          g.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                  if (filteredGames.isEmpty) {
                    return Center(
                      child: Text(
                        "No releases found",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        GameGrid(
                          games: filteredGames,
                          childAspectRatio: 0.75,
                          itemBuilder: (game, crossAxisCount) => GameCard(
                            game: game,
                            crossAxisCount: crossAxisCount,
                            showDateBadge: true,
                            showNotifyButton: true,
                            heroTag: 'hero_schedule_${game.id}',
                          ),
                        ),
                        if (!state.hasReachedMax && _searchQuery.isEmpty)
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
    );
  }

  Widget _buildMonthChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.sm.h),
      child: Row(
        children: List.generate(12, (index) {
          final month = index + 1;
          final isSelected = month == _selectedMonth;
          final fullName = DateFormat('MMMM').format(DateTime(_year, month));
          return Padding(
            padding: EdgeInsets.only(right: Dimens.sm.w),
            child: AppFilterChip(
              label: fullName,
              isSelected: isSelected,
              onSelected: (_) {
                setState(() => _selectedMonth = month);
                _fetchSelectedMonth();
              },
            ),
          );
        }),
      ),
    );
  }

  void _showOrderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(Dimens.lg.w, 0, Dimens.lg.w, Dimens.xl.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order By",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimens.md.h),
              Wrap(
                spacing: Dimens.sm.w,
                runSpacing: Dimens.sm.h,
                children: [
                  ...(_orderingOptions.map((option) {
                    final isSelected = _ordering == option['value'];
                    return ListTile(
                      title: Text(
                        option['label']!,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () {
                        setState(() => _ordering = option['value']!);
                        Navigator.pop(context);
                        _fetchSelectedMonth();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    );
                  })),
                ],
              ),

            ],
          ),
        );
      },
    );
  }
}
