import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_state.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_about_block.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_genres_subtitle.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_info_block.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_media_gallery.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_platforms_tags.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_private_note.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_stats_row.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_system_requirements.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_user_rating.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:game_tracker/features/library/presentation/widgets/status_selection_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';

class GameDetailsPage extends StatelessWidget {
  final int gameId;
  const GameDetailsPage({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GameDetailsBloc>()..add(FetchGameDetails(gameId)),
      child: BlocBuilder<GameDetailsBloc, GameDetailsState>(
        builder: (context, state) {
          if (state is GameDetailsLoading) {
            return Scaffold(
              appBar: AppBar(),
              backgroundColor: const Color(0xFF050B18),
              body: const Center(child: CircularProgressIndicator(color: Color(0xFF2F6BFF))),
            );
          }
          if (state is GameDetailsLoaded) {
            return Scaffold(
              backgroundColor: const Color(0xFF050B18),
              body: _buildBody(context, state.details),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            backgroundColor: const Color(0xFF050B18),
            body: const Center(child: Text("Error loading game", style: TextStyle(color: Colors.white))),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, GameDetailEntity game) {
    return CustomScrollView(
      slivers: [
        // 1. The Hero Image Header
        SliverAppBar(
          pinned: true,
          expandedHeight: 240,
          backgroundColor: const Color(0xFF050B18),
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.black45,
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black45,
                child: Icon(Icons.share, color: Colors.white),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
          ],
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var top = constraints.biggest.height;
              bool isCollapsed = top <= (MediaQuery.of(context).padding.top + kToolbarHeight);

              return FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: false,
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: isCollapsed ? 1.0 : 0.0, // Only visible when collapsed
                  child: Text(
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    game.name,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: game.backgroundImage ?? '',
                      width: 200,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                    ),
                    // The Gradient Fade at the bottom
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xFF050B18)],
                          stops: [0.6, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // 2. The Content Body
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform Tags
                GamePlatformsTags(platforms: game.platforms),
                // Title
                Text(
                  game.name,
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),

                // Genres
                GameGenreSubtitle(genres: game.genres), // EXTRACTED
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    BlocBuilder<LibraryBloc, LibraryState>(
                      builder: (context, state) {
                        LibraryItem? libraryItem;

                        if (state is LibraryLoaded) {
                          libraryItem = state.items.firstWhereOrNull(
                            (item) => item.gameId == game.id,
                          );
                        }

                        final bool isInLibrary = libraryItem != null;

                        return Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => showStatusSheet(context, game, libraryItem),
                            // Change icon based on presence
                            icon: Icon(
                              isInLibrary ? libraryItem.status.icon.icon : Icons.add_circle_outline,
                              color: isInLibrary ? libraryItem.status.color : Colors.white,
                            ),
                            // Change text to show current status
                            label: Text(
                              isInLibrary ? libraryItem.status.name.toUpperCase() : "Add to Library",
                              style: TextStyle(color: isInLibrary ? libraryItem.status.color : Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              // Change color: Blue for "Add", Dark Grey/Green for "In Library"
                              backgroundColor: isInLibrary ? const Color(0xFF32394C) : const Color(0xFF2F6BFF),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: isInLibrary ? const BorderSide(color: Colors.white10) : BorderSide.none,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2430),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.favorite_border, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Stats Row (Score, Release, Time)
                GameStatsRow(game: game),
                const SizedBox(height: 32),

                // Synopsis
                GameAboutBlock(description: game.description), // EXTRACTED
                const SizedBox(height: 32),

                GameInfoBlock(game: game),
                const SizedBox(height: 32),

                // Media Gallery
                GameMediaGallery(screenshots: game.screenshots), // EXTRACTED
                const SizedBox(height: 32),

                // System Specs
                if (game.pcRequirements != null)
                  GameSystemRequirements(pcRequirements: game.pcRequirements!),
                const SizedBox(height: 32),
                BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                    if (state is LibraryLoaded) {
                      final item = state.items.firstWhereOrNull((i) => i.gameId == game.id);

                      if (item != null) {
                        return Column(
                          children: [
                            const Divider(color: Colors.white10, height: 60),
                            GameUserRatingBar(gameId: game.id, currentRating: item.userRating ?? 0),
                            const SizedBox(height: 32),
                            GamePrivateNoteField(gameId: game.id, initialNote: item.privateNote),
                          ],
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}