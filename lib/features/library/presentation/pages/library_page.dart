import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/library/data/models/library_view_model.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_cubit.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_state.dart';
import 'package:game_tracker/features/library/presentation/widgets/library_game_card.dart';
import 'package:rxdart/rxdart.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  GameStatus? selectedFilter;

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
              // Filtering logic moved out of the build method
              final items = libState.items.where((item) {
                final matchesStatus = filterState.status == null || item.status == filterState.status;
                final matchesSearch = item.gameName.toLowerCase().contains(filterState.searchQuery.toLowerCase());
                return matchesStatus && matchesSearch;
              }).toList();

              return LibraryViewModel(items, filterState.status);
            }
            return LibraryViewModel([], filterState.status);
          },
        ),
        builder: (context, snapshot) {
          final viewModel = snapshot.data;

          if (viewModel == null || context.read<LibraryBloc>().state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          return Column(
            children: [
              // Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.sm.h),
                child: Row(
                  children: [
                    _buildFilterChip(context, null, "ALL", viewModel.activeFilter),
                    ...GameStatus.values.map((s) =>
                        _buildFilterChip(context, s, s.name.toUpperCase(), viewModel.activeFilter)),
                  ],
                ),
              ),

              // Library Grid
              Expanded(
                child: viewModel.items.isEmpty
                    ? Center(child: Text("No games found here.", style: Theme.of(context).textTheme.bodyLarge))
                    : GridView.builder(
                  padding: EdgeInsets.all(Dimens.md.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: Dimens.md.w,
                    mainAxisSpacing: Dimens.md.h,
                  ),
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) =>
                      LibraryGameCard(item: viewModel.items[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, GameStatus? status, String label, GameStatus? activeFilter) {
    final isSelected = activeFilter == status;
    return Padding(
      padding: EdgeInsets.only(right: Dimens.sm.w),
      child: FilterChip(
        label: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary, 
          fontWeight: FontWeight.bold
        )),
        selected: isSelected,
        onSelected: (_) => context.read<LibraryFilterCubit>().setStatus(status),
        backgroundColor: AppColors.surface,
        selectedColor: status?.color.withValues(alpha: 0.3) ?? AppColors.primary.withValues(alpha: 0.3),
        checkmarkColor: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: isSelected ? Colors.white24 : Colors.transparent)),
      ),
    );
  }
}