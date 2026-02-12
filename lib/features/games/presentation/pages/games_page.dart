import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/utils/app_snackbar.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_state.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GameBloc>()..add(FetchTrendingGames()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Game Tracker"),
          actions: [
            GestureDetector(
              onTap: () {
                context.push('/library');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 32,
                width: 32,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    sl<AuthRepository>().currentUser?.photoUrl ?? "",
                  ),
                  onBackgroundImageError: (_, __) {
                    Icon(Icons.broken_image, size: 16);
                  },
                  radius: 16,
                ),
              ),
            ),
            SizedBox(width: 16,),
          ],
        ),
        body: BlocConsumer<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GamesError) {
              AppSnackbar.show(
                context,
                message: state.message,
                type: SnackbarType.error
              );
            }
          },
          builder: (context, state) {
            if (state is GamesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GamesLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.games.length,
                itemBuilder: (context, index) {
                  final game = state.games[index];
                  return GestureDetector(
                    onTap: () => context.pushNamed(
                      'game_details',
                      pathParameters: {'id': game.id.toString()},
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: game.backgroundImage ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorWidget: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(game.rating.toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("Start exploring games!"));
          },
        ),
      ),
    );
  }
}