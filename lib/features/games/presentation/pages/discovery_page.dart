import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_state.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_card.dart';
import 'package:game_tracker/features/games/presentation/widgets/discovery/discovery_filter_sheet.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Discover Games"),
        actions: [
          BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
            builder: (context, state) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: state.activeFilterCount > 0,
                  label: Text('${state.activeFilterCount}'),
                  child: const Icon(AppIcons.filter),
                ),
                onPressed: () => _showFilterSheet(context),
              );
            },
          )
        ],
      ),
      body: BlocBuilder<DiscoveryBloc, DiscoveryState>(
        builder: (context, state) {
          if (state is DiscoveryInitial) {
            context.read<DiscoveryBloc>().add(RefreshDiscovery());
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is DiscoveryLoading) {
            return Column(
              children: [
                _buildFilterSummary(context),
                const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary))),
              ],
            );
          }

          if (state is DiscoveryLoaded) {
            return Column(
              children: [
                _buildFilterSummary(context),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(Dimens.md.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: Dimens.md.w,
                      mainAxisSpacing: Dimens.md.h,
                    ),
                    itemCount: state.hasReachedMax ? state.games.length : state.games.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.games.length) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }
                      final game = state.games[index];
                      return GameCard(game: game);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No games found with these filters"));
        },
      ),
    );
  }

  Widget _buildFilterSummary(BuildContext context) {
    return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
      builder: (context, state) {
        if (state.activeFilterCount == 0) return const SizedBox();

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

  void _showFilterSheet(BuildContext context) {
    final discoveryBloc = context.read<DiscoveryBloc>();
    final filterCubit = context.read<DiscoveryFilterCubit>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: filterCubit),
            BlocProvider.value(value: discoveryBloc),
          ],
          child: DiscoveryFilterSheet(),
        );
      },
    );
  }
}