import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/domain/entities/game_ordering.dart';
import 'package:game_tracker/features/games/domain/repositories/discovery_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';

class DiscoveryFilterSheet extends StatelessWidget {
  /// Callback to be called when the "Apply" button is pressed.
  final VoidCallback onApply;

  /// Whether to show the genres section.
  final bool showGenres;

  const DiscoveryFilterSheet({
    super.key, 
    required this.onApply,
    this.showGenres = true,
  });

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
                   _buildDynamicSection('platforms/lists/parents', (cubit, e) => cubit.setPlatform(e), category: 'platform', maxItems: 12),
                   SizedBox(height: Dimens.xl.h),
                   Text("Popular Tags", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   SizedBox(height: Dimens.md.h),
                   _buildDynamicSection('tags', (cubit, e) => cubit.toggleTag(e), category: 'tag', maxItems: 12),
                   SizedBox(height: Dimens.xl.h),
                   if (showGenres) ...[
                     Text("Genres", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                     SizedBox(height: Dimens.md.h),
                     _buildDynamicSection('genres', (cubit, e) => cubit.setGenre(e), category: 'genre'),
                     SizedBox(height: Dimens.xxl.h),
                   ],
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
                Text("${start.toInt()}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                Text("${end.toInt()}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
            RangeSlider(
              values: RangeValues(start, end),
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              labels: RangeLabels("${start.toInt()}", "${end.toInt()}"),
              activeColor: AppColors.primary,
              inactiveColor: AppColors.textSecondary.withValues(alpha: 0.2),
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
          runSpacing: Dimens.sm.h,
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

  Widget _buildDynamicSection(String endpoint, Function(DiscoveryFilterCubit, dynamic) onSelect, {required String category, int? maxItems}) {
    return FutureBuilder(
      future: sl<DiscoveryRepository>().getFilterMetadata(endpoint),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var items = snapshot.data!;
        if (maxItems != null) {
          items = items.take(maxItems).toList();
        }

        return BlocBuilder<DiscoveryFilterCubit, DiscoveryFilterState>(
          builder: (context, state) {
            return Wrap(
              runSpacing: Dimens.sm.h,
              spacing: Dimens.sm.w,
              children: items.map((item) {
                bool isSelected = false;
                if (category == 'platform') {
                  isSelected = state.platform?.id == item.id;
                } else if (category == 'tag') {
                  isSelected = state.tags.any((t) => t.id == item.id);
                } else if (category == 'genre') {
                  isSelected = state.genres.any((g) => g.id == item.id) || state.genreSlug == item.slug;
                }

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
        onApply();
        Navigator.pop(context);
      },
      child: Text("SHOW RESULTS", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}