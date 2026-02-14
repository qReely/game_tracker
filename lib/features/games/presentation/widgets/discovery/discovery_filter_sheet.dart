import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/domain/entities/game_ordering.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

class DiscoveryFilterSheet extends StatelessWidget {
  const DiscoveryFilterSheet({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: Dimens.lg.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.xl.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important for bottom sheet
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimens.md.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text("Ordering", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   SizedBox(height: Dimens.md.h),
                   _buildOrderingGroup(),
                   SizedBox(height: Dimens.xl.h),
                   Text("Year", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   SizedBox(height: Dimens.md.h),
                   _buildYearSlider(context),
                   SizedBox(height: Dimens.xl.h),
                   Text("Platform", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   SizedBox(height: Dimens.md.h),
                   _buildDynamicSection('platforms/lists/parents', (cubit, e) => cubit.setPlatform(e)),
                   SizedBox(height: Dimens.xl.h),
                   Text("Popular Tags", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   SizedBox(height: Dimens.md.h),
                   _buildDynamicSection('tags', (cubit, e) => cubit.toggleTag(e)),
                   SizedBox(height: Dimens.xxl.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimens.md.w),
            child: _buildApplyButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSlider(BuildContext context) {
    return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
      builder: (context, state) {
        final currentYear = DateTime.now().year;
        final min = 1979.0;
        final max = currentYear.toDouble();
        
        final start = state.minYear?.toDouble() ?? min;
        final end = state.maxYear?.toDouble() ?? max;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${start.toInt()}", style: const TextStyle(color: Colors.white70)),
                Text("${end.toInt()}", style: const TextStyle(color: Colors.white70)),
              ],
            ),
            RangeSlider(
              values: RangeValues(start, end),
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              labels: RangeLabels("${start.toInt()}", "${end.toInt()}"),
              activeColor: AppColors.primary,
              inactiveColor: Colors.white24,
              onChanged: (values) {
                context.read<DiscoveryFilterCubit>().setYearRange(
                  values.start.toInt(), 
                  values.end.toInt()
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderingGroup() {
    return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
      builder: (context, state) {
        return Wrap(
          spacing: Dimens.sm.w,
          children: GameOrdering.values.map((order) => ChoiceChip(
            label: Text(order.label),
            selected: state.ordering == order,
            onSelected: (val) => val ? context.read<DiscoveryFilterCubit>().setOrdering(order) : null,
          )).toList(),
        );
      },
    );
  }

  Widget _buildDynamicSection(String endpoint, Function(DiscoveryFilterCubit, dynamic) onSelect) {
    return FutureBuilder(
      future: sl<GameRepository>().getFilterMetadata(endpoint),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!.take(8).toList();

        return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
          builder: (context, state) {
            return Wrap(
              spacing: Dimens.sm.w,
              children: items.map((item) {
                final isSelected = state.platform?.id == item.id || state.tags.any((t) => t.id == item.id);
                return FilterChip(
                  label: Text(item.name),
                  selected: isSelected,
                  onSelected: (_) => onSelect(context.read<DiscoveryFilterCubit>(), item),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radiusLg.r)),
      ),
      onPressed: () {
        context.read<DiscoveryBloc>().add(RefreshDiscovery());
        Navigator.pop(context);
      },
      child: Text("SHOW RESULTS", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}