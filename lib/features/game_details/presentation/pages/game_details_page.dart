import 'package:flutter/material.dart';
import 'package:game_tracker/core/widgets/app_cached_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/presentation/widgets/app_snackbar.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/game_details/presentation/bloc/game_details_bloc.dart';
import 'package:game_tracker/features/game_details/presentation/bloc/game_details_event.dart';
import 'package:game_tracker/features/game_details/presentation/bloc/game_details_state.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_about_block.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_details_skeleton.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_genres_block.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_info_block.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_media_gallery.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_platforms_tags.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_stats_row.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_system_requirements.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_user_rating.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_average_rating.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_status_button.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_note_button.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_series_block.dart';
import 'package:go_router/go_router.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_playtime_stats.dart';
import 'package:collection/collection.dart';

class GameDetailsPage extends StatefulWidget {
  final int gameId;
  const GameDetailsPage({super.key, required this.gameId});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  LibraryItem? _previousItem;
  bool _isInitialized = false;

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
            
            if (!_isInitialized) {
              _isInitialized = true;
              _previousItem = currentItem;
              return;
            }

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
            if (state is GameDetailsLoading || state is GameDetailsInitial) {
              return const Scaffold(
                backgroundColor: AppColors.background,
                body: GameDetailsSkeleton(),
              );
            }
            if (state is GameDetailsLoaded) {
              // Proactive: Update library item with metadata if missing
              final libraryState = context.read<LibraryBloc>().state;
              if (libraryState is LibraryLoaded) {
                final item = libraryState.items.firstWhereOrNull((i) => i.gameId == widget.gameId);
                if (item != null && (item.platforms == null || item.releasedYear == null)) {
                  context.read<LibraryBloc>().add(AddGameToLibrary(LibraryItem(
                    gameId: item.gameId,
                    gameName: item.gameName,
                    posterPath: item.posterPath,
                    status: item.status,
                    userRating: item.userRating,
                    privateNote: item.privateNote,
                    platforms: state.details.platforms,
                    releasedYear: state.details.released.split('-').first,
                    addedAt: item.addedAt,
                  )));
                }
              }

              return Scaffold(
                backgroundColor: AppColors.background,
                body: _buildBody(context, state.details),
              );
            }
            if(state is GameDetailsError) {
              return Scaffold(
                appBar: AppBar(backgroundColor: AppColors.background),
                backgroundColor: AppColors.background,
                body: Center(child: Text(state.message, style: Theme.of(context).textTheme.bodyLarge)),
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
          expandedHeight: 300.h, // Scaled height
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.black45,
              radius: 18.r,
              child: Icon(AppIcons.back, color: Colors.white, size: Dimens.iconMd.sp),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.black45,
                radius: 18.r,
                child: Icon(AppIcons.share, color: Colors.white, size: Dimens.iconMd.sp),
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
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppCachedImage(
                      imageUrl: game.backgroundImage ?? '',
                      fit: BoxFit.cover,
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
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(height: Dimens.lg.h),

                // Action Buttons
                LayoutBuilder(
                  builder: (context, constraints) {
                    // On wide screens (tablet/desktop), reduce the width of the status button
                    // so it doesn't stretch across the entire screen.
                    // On mobile, let it be expanded to fill the row.
                    
                    // We check if the available width is "large" (e.g., > 600)
                    // If large, we use a flexible or fixed constraint.
                    // If small, we use Expanded.
                    
                    final isWide = constraints.maxWidth > 600;

                    return Row(
                      children: [
                        if (isWide)
                          Flexible(child: GameStatusButton(game: game))
                        else
                          Expanded(
                            child: GameStatusButton(game: game),
                          ),
                          
                        SizedBox(width: Dimens.md.w),
                        
                        GameNoteButton(game: game),
                      ],
                    );
                  },
                ),
                SizedBox(height: Dimens.xl.h),

                // Stats Row (Score, Release, Time)
                GameStatsRow(game: game),
                SizedBox(height: Dimens.xl.h),

                BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                    double userRating = 0;
                    int? playtimeMinutes;
                    bool isInLibrary = false;
                    if (state is LibraryLoaded) {
                      final item = state.items.firstWhereOrNull((i) => i.gameId == game.id);
                      userRating = item?.userRating ?? 0;
                      playtimeMinutes = item?.playtimeMinutes;
                      isInLibrary = item != null;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GameAverageRating(gameId: game.id),
                        SizedBox(height: 16.h),
                        if (isInLibrary) ...[
                          GameUserRatingBar(gameId: game.id, currentRating: userRating),
                          SizedBox(height: 16.h),
                          GamePlaytimeStats(gameId: game.id, playtimeMinutes: playtimeMinutes),
                          SizedBox(height: 24.h),
                        ],
                      ],
                    );
                  },
                ),

                // Synopsis
                GameAboutBlock(description: game.description), // EXTRACTED

                GameGenresBlock(genres: game.genres),

                GameInfoBlock(game: game),
                SizedBox(height: Dimens.xl.h),

                // Media Gallery
                GameMediaGallery(screenshots: game.screenshots), // EXTRACTED
                SizedBox(height: Dimens.xl.h),

                // Games in the series
                BlocBuilder<GameDetailsBloc, GameDetailsState>(
                  builder: (context, state) {
                    if (state is GameDetailsLoaded && state.seriesGames.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GameSeriesBlock(games: state.seriesGames),
                          SizedBox(height: Dimens.xl.h),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // System Specs
                if (game.pcRequirements != null)
                  GameSystemRequirements(pcRequirements: game.pcRequirements!),
                SizedBox(height: Dimens.xl.h),
                SizedBox(height: Dimens.xl.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}