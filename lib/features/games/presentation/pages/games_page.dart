import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_state.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<GameBloc>().add(LoadMoreGames());
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
      backgroundColor: const Color(0xFF050B18),
      appBar: AppBar(title: const Text("Home")),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GamesLoading || state is GamesInitial) return const Center(child: CircularProgressIndicator());

          if (state is GamesLoaded) {
            return GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.hasReachedMax ? state.games.length : state.games.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.games.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GameCard(game: state.games[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}