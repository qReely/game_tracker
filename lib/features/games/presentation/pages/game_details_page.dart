import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/utils/app_snackbar.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/details/game_details_state.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_about_block.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_genres_subtitle.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_info_block.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_media_gallery.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_platforms_tags.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_private_note.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_stats_row.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_system_requirements.dart';
import 'package:game_tracker/features/games/presentation/widgets/game_details/game_user_rating.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:game_tracker/features/library/presentation/widgets/status_selection_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

class GameDetailsPage extends StatefulWidget {
  final int gameId;
  const GameDetailsPage({super.key, required this.gameId});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  LibraryItem? _previousItem;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<LibraryBloc>().state;
    if (currentState is LibraryLoaded) {
      _previousItem = currentState.items.firstWhereOrNull((i) => i.gameId == widget.gameId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GameDetailsBloc>()..add(FetchGameDetails(widget.gameId)),
      child: BlocListener<LibraryBloc, LibraryState>(
        listener: (context, state) {
          if (state is LibraryLoaded) {
            final currentItem = state.items.firstWhereOrNull((i) => i.gameId == widget.gameId);
            
            // 1. Added
            if (_previousItem == null && currentItem != null) {
              AppSnackbar.show(context, message: "Added to library", type: SnackbarType.success);
            } 
            // 2. Removed
            else if (_previousItem != null && currentItem == null) {
              AppSnackbar.show(context, message: "Removed from library", type: SnackbarType.info);
            }
            // 3. Updates (Status or Rating)
            else if (_previousItem != null && currentItem != null) {
               if (_previousItem!.status != currentItem.status) {
                  AppSnackbar.show(context, message: "Status updated to ${currentItem.status.name.toUpperCase()}", type: SnackbarType.success);
               }
               if (_previousItem!.userRating != currentItem.userRating) {
                 AppSnackbar.show(context, message: "Rating updated", type: SnackbarType.success);
               }
            }
            
            _previousItem = currentItem;
          }
        },
        child: BlocBuilder<GameDetailsBloc, GameDetailsState>(
          builder: (context, state) {
            if (state is GameDetailsLoading) {
              return Scaffold(
                appBar: AppBar(backgroundColor: AppColors.background),
                backgroundColor: AppColors.background,
                body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              );
            }
            if (state is GameDetailsLoaded) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: _buildBody(context, state.details),
              );
            }
            return Scaffold(
              appBar: AppBar(backgroundColor: AppColors.background),
              backgroundColor: AppColors.background,
              body: Center(child: Text("Error loading game", style: Theme.of(context).textTheme.bodyLarge)),
            );
          },
        ),
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
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.black45,
              child: Icon(AppIcons.back, color: Colors.white),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black45,
                child: Icon(AppIcons.share, color: Colors.white),
              ),
              onPressed: () {},
            ),
            SizedBox(width: Dimens.md.w),
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                      const Icon(AppIcons.error, size: 50),
                    ),
                    // The Gradient Fade at the bottom
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, AppColors.background],
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
            padding: EdgeInsets.symmetric(horizontal: Dimens.lg.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform Tags
                GamePlatformsTags(platforms: game.platforms),
                // Title
                Text(
                  game.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: Dimens.sm.h),

                // Genres
                GameGenreSubtitle(genres: game.genres), // EXTRACTED
                SizedBox(height: Dimens.xl.h),

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
                              isInLibrary ? libraryItem.status.icon.icon : AppIcons.add,
                              color: isInLibrary ? libraryItem.status.color : Colors.white,
                            ),
                            // Change text to show current status
                            label: Text(
                              isInLibrary ? libraryItem.status.name.toUpperCase() : "Add to Library",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: isInLibrary ? libraryItem.status.color : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              // Change color: Blue for "Add", Dark Grey/Green for "In Library"
                              backgroundColor: isInLibrary ? AppColors.surfaceLight : AppColors.primary,
                              padding: EdgeInsets.symmetric(vertical: Dimens.md.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Dimens.radiusXl.r),
                                side: isInLibrary ? const BorderSide(color: Colors.white10) : BorderSide.none,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: Dimens.md.w),
                    Container(
                      padding: EdgeInsets.all(Dimens.md.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(AppIcons.favoriteBorder, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.xl.h),

                // Stats Row (Score, Release, Time)
                GameStatsRow(game: game),
                SizedBox(height: Dimens.xl.h),

                // Synopsis
                GameAboutBlock(description: game.description), // EXTRACTED
                SizedBox(height: Dimens.xl.h),

                GameInfoBlock(game: game),
                SizedBox(height: Dimens.xl.h),

                // Media Gallery
                GameMediaGallery(screenshots: game.screenshots), // EXTRACTED
                SizedBox(height: Dimens.xl.h),

                // System Specs
                if (game.pcRequirements != null)
                  GameSystemRequirements(pcRequirements: game.pcRequirements!),
                SizedBox(height: Dimens.xl.h),
                BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                    if (state is LibraryLoaded) {
                      final item = state.items.firstWhereOrNull((i) => i.gameId == game.id);

                      if (item != null) {
                        return Column(
                          children: [
                            const Divider(color: Colors.white10, height: 60),
                            GameUserRatingBar(gameId: game.id, currentRating: item.userRating ?? 0),
                            SizedBox(height: Dimens.xl.h),
                            GamePrivateNoteField(gameId: game.id, initialNote: item.privateNote),
                          ],
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: Dimens.xl.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}