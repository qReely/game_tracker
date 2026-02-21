import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';

/// Shows the status selection bottom sheet.
///
/// Accepts only primitive fields so it works with both [GameEntity]
/// and [GameDetailEntity] — no coupling to a specific entity type.
void showStatusSheet(
  BuildContext context, {
  required int gameId,
  required String gameName,
  String? posterPath,
  String? releasedYear,
  List<String>? platforms,
  LibraryItem? currentItem,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxWidth: Dimens.sheetMaxWidth,
      maxHeight: MediaQuery.of(context).size.height * 0.7,
    ),
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.xl.r))),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.lg.w, vertical: Dimens.sm.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Update Status",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Dimens.xs.h),
            Text(
              gameName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            SizedBox(height: Dimens.sm.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: GameStatus.values.where((s) => s != GameStatus.none).map((status) {
                        final bool isSelected = currentItem?.status == status;
                        final color = status.color;

                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimens.sm.h),
                          child: InkWell(
                            onTap: () {
                              if (currentItem != null) {
                                // If item exists, ONLY update status to preserve ratings/notes
                                context.read<LibraryBloc>().add(
                                  UpdateStatus(gameId, status),
                                );
                              } else {
                                // If new item, add with metadata
                                context.read<LibraryBloc>().add(
                                  AddGameToLibrary(
                                    LibraryItem(
                                      gameId: gameId,
                                      gameName: gameName,
                                      posterPath: posterPath,
                                      status: status,
                                      platforms: platforms,
                                      releasedYear: releasedYear,
                                      addedAt: DateTime.now(),
                                    ),
                                  ),
                                );
                              }
                              Navigator.pop(sheetContext);
                            },
                            borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(Dimens.md.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withValues(alpha: 0.1)
                                    : AppColors.surfaceLight.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                                border: Border.all(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.8)
                                      : Colors.white.withValues(alpha: 0.05),
                                  width: 1.5,
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.3),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 0),
                                  ),
                                ] : null,
                              ),
                              child: Row(
                                children: [
                                  // Icon Container
                                  Container(
                                    padding: EdgeInsets.all(Dimens.sm.w),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
                                    ),
                                    child: Icon(
                                      status.icon.icon,
                                      color: color,
                                      size: 24.sp,
                                    ),
                                  ),
                                  SizedBox(width: Dimens.md.w),
                                  // Text Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          status.name.substring(0, 1).toUpperCase() + status.name.substring(1),
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          status.description,
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Selection Indicator
                                  Container(
                                    width: 20.sp,
                                    height: 20.sp,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? color : AppColors.textSecondary,
                                        width: 2,
                                      ),
                                      color: isSelected ? color : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? Icon(Icons.check, color: AppColors.textPrimary, size: 14.sp)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            if (currentItem != null) ...[
              SizedBox(height: Dimens.md.h),
              OutlinedButton.icon(
                onPressed: () {
                  context.read<LibraryBloc>().add(RemoveGameFromLibrary(gameId));
                  Navigator.pop(sheetContext);
                },
                icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent.withValues(alpha: 0.8), size: 18.sp),
                label: Text(
                  "Remove from Library",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3), width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: Dimens.lg.h),
                  minimumSize: Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}