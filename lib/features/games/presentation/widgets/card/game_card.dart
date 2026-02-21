import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/presentation/widgets/app_snackbar.dart';
import 'package:game_tracker/core/utils/image_optimization_utils.dart';
import 'package:game_tracker/core/widgets/app_cached_image.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/core/extensions/num_extensions.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:collection/collection.dart';
import 'package:game_tracker/features/library/presentation/widgets/status_selection_sheet.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/presentation/widgets/app_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class GameCard extends StatelessWidget {
  final GameEntity game;
  final int crossAxisCount;
  final bool showDateBadge;
  final bool showNotifyButton;
  final String? heroTag;

  const GameCard({
    super.key,
    required this.game,
    this.crossAxisCount = 2,
    this.showDateBadge = false,
    this.showNotifyButton = false,
    this.heroTag,
  });

  String _formatDate(String? date) {
    if (date == null) return 'TBA';
    try {
      final dt = DateTime.parse(date);
      return DateFormat('MMM d, y').format(dt);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. BACKGROUND IMAGE
            Hero(
              tag: heroTag ?? 'game_poster_${game.id}',
              child: AppCachedImage(
                imageUrl: game.backgroundImage ?? '',
                memCacheWidth: ImageOptimizationUtils.getOptimalMemCacheWidth(
                  context,
                  crossAxisCount: crossAxisCount,
                ),
              ),
            ),

            // 2. GRADIENT OVERLAY
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                    stops: const [0.0, 0.45, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // 3. TEXT CONTENT (Bottom)
            Positioned(
              bottom: Dimens.md.h,
              left: Dimens.md.w,
              right: Dimens.md.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: Dimens.sm.w),
                          child: Text(
                            game.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              shadows: [
                                Shadow(blurRadius: 4.r, color: Colors.black, offset: Offset(0, 2.h)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildRatingBadge(context, game.rating),
                    ],
                  ),
                  // Show year only when date badge is NOT shown
                  if (!showDateBadge) ...[
                    SizedBox(height: Dimens.xs.h),
                    Text(
                      game.releasedYear ?? 'TBA',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // 4. TOUCH RIPPLE
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pushNamed('game_details', pathParameters: {'id': game.id.toString()}),
              ),
            ),

            // 5. TOP-LEFT BADGES (status, date)
            Positioned(
              top: Dimens.sm.h,
              left: Dimens.sm.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date badge (calendar only)
                  if (showDateBadge)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w, vertical: Dimens.xs.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(Dimens.radiusXs.r),
                      ),
                      child: Text(
                        _formatDate(game.releasedDate),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  // Library status tag
                  BlocBuilder<LibraryBloc, LibraryState>(
                    builder: (context, state) {
                      if (state is LibraryLoaded) {
                        final item = state.items.firstWhereOrNull((i) => i.gameId == game.id);
                        if (item != null) {
                          return Padding(
                            padding: EdgeInsets.only(top: showDateBadge ? Dimens.xs.h : 0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w, vertical: Dimens.xs.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(Dimens.radiusXs.r),
                                border: Border.all(color: item.status.color.withValues(alpha: 0.5), width: 1.w),
                              ),
                              child: Text(
                                item.status.name[0].toUpperCase() + item.status.name.substring(1),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: item.status.color,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            // 6. TOP-RIGHT ACTIONS (notify, add-to-library)
            Positioned(
              top: Dimens.sm.h,
              right: Dimens.sm.w,
              child: Column(
                children: [
                  if (showNotifyButton)
                    _NotifyButton(game: game),
                  if (showNotifyButton) SizedBox(height: Dimens.xs.h),
                  _AddToLibraryButton(game: game),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context, double rating) {
    if (rating == 0.0) return const SizedBox.shrink();
    final Color color = rating.ratingColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w, vertical: Dimens.xs.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Dimens.radiusXs.r),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.star, color: color, size: 12.r),
          SizedBox(width: Dimens.xs.w),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PRIVATE ACTION BUTTONS
// ──────────────────────────────────────────────────────────────

/// Small icon button that opens a confirmation sheet to get notified
/// when a game is released.
class _NotifyButton extends StatelessWidget {
  final GameEntity game;

  const _NotifyButton({required this.game});

  void _showConfirmationSheet(BuildContext context) {
    AppBottomSheet.showConfirmation(
      context,
      title: "Get Notified",
      message: "You'll receive a notification when \"${game.name}\" is released.",
      confirmText: "Confirm",
      onConfirm: () {
        AppSnackbar.show(
          context,
          message: 'You will be notified when "${game.name}" is released!',
          type: SnackbarType.success,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showConfirmationSheet(context),
        borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
        child: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.w),
          ),
          child: Icon(AppIcons.notificationAdd, color: Colors.white, size: 18.r),
        ),
      ),
    );
  }
}

/// Small icon button to add a game to the library.
/// Only visible when the game is NOT already in the library.
class _AddToLibraryButton extends StatelessWidget {
  final GameEntity game;

  const _AddToLibraryButton({required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        // Only show if game is NOT already in library
        LibraryItem? libraryItem;
        if (state is LibraryLoaded) {
          libraryItem = state.items.firstWhereOrNull((i) => i.gameId == game.id);
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => showStatusSheet(
              context,
              gameId: game.id,
              gameName: game.name,
              posterPath: game.backgroundImage,
              releasedYear: game.releasedYear,
              currentItem: libraryItem,
            ),
            borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(Dimens.radiusSm.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.w),
              ),
              child: Icon(AppIcons.addToLibrary, color: Colors.white, size: 18.r),
            ),
          ),
        );
      },
    );
  }
}