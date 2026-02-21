import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_cubit.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_state.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';

class LibraryFilterSheet extends StatelessWidget {
  const LibraryFilterSheet({super.key});

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimens.md.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Year", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: Dimens.md.h),
                  _buildYearSlider(context),
                  SizedBox(height: Dimens.xl.h),
                  Text("Platforms", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: Dimens.md.h),
                  _buildPlatformFilter(context),
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
    return BlocBuilder<LibraryFilterCubit, LibraryFilterState>(
      builder: (context, state) {
        final currentYear = DateTime.now().year;
        const min = 1970.0;
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
                context.read<LibraryFilterCubit>().setYearRange(
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

  Widget _buildPlatformFilter(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, libState) {
        if (libState is! LibraryLoaded) return const SizedBox();

        // Extract all unique platforms from the library
        final allPlatforms = libState.items
            .expand((item) => item.platforms ?? <String>[])
            .toSet()
            .toList()
          ..sort();

        if (allPlatforms.isEmpty) return const Text("No platform metadata available yet.", style: TextStyle(color: Colors.white38));

        return BlocBuilder<LibraryFilterCubit, LibraryFilterState>(
          builder: (context, filterState) {
            return Wrap(
              spacing: Dimens.sm.w,
              runSpacing: Dimens.sm.h,
              children: allPlatforms.map((platform) => FilterChip(
                label: Text(platform),
                selected: filterState.platforms.contains(platform),
                onSelected: (_) => context.read<LibraryFilterCubit>().togglePlatform(platform),
              )).toList(),
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
      onPressed: () => Navigator.pop(context),
      child: Text("APPLY FILTERS", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
