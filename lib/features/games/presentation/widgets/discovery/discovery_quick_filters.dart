import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/widgets/app_filter_chip.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

class DiscoveryQuickFilters extends StatelessWidget {
  const DiscoveryQuickFilters({super.key});

  final List<_QuickFilterOption> _options = const [
    _QuickFilterOption(label: "Last 30 days", group: "New releases", id: "recent-games-past"),
    _QuickFilterOption(label: "This week", group: "New releases", id: "recent-games-this-week"),
    _QuickFilterOption(label: "Best of the year", group: "Top", id: "greatest"),
    _QuickFilterOption(label: "Popular 2026", group: "Top", id: "popular-2026"),
    _QuickFilterOption(label: "All time top 250", group: "Top", id: "popular"),
  ];

  void _onChipSelected(BuildContext context, String id) {
    final cubit = context.read<DiscoveryFilterCubit>();
    final bloc = context.read<DiscoveryBloc>();

    cubit.toggleQuickFilter(id);
    bloc.add(RefreshDiscovery());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.sm.h),
          child: Row(
            children: _options.map((option) {
              final isSelected = state.activeQuickFilterId == option.id;

              return Padding(
                padding: EdgeInsets.only(right: Dimens.sm.w),
                child: AppFilterChip(
                  label: option.label,
                  isSelected: isSelected,
                  onSelected: (_) => _onChipSelected(context, option.id),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _QuickFilterOption {
  final String label;
  final String group;
  final String id;

  const _QuickFilterOption({required this.label, required this.group, required this.id});
}
