import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
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
      backgroundColor: const Color(0xFF050B18),
      appBar: AppBar(
        title: const Text("My Library"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              sl<AuthRepository>().signOut();
            }
          ),
        ],
      ),
      body: StreamBuilder<LibraryViewModel>(
        // Combine the streams of the LibraryBloc and LibraryFilterCubit
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
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    ? const Center(child: Text("No games found here.", style: TextStyle(color: Colors.grey)))
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
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
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
        selected: isSelected,
        onSelected: (_) => context.read<LibraryFilterCubit>().setStatus(status),
        backgroundColor: const Color(0xFF1F2430),
        selectedColor: status?.color.withOpacity(0.3) ?? Colors.blueAccent.withOpacity(0.3),
        checkmarkColor: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: isSelected ? Colors.white24 : Colors.transparent)),
      ),
    );
  }
}