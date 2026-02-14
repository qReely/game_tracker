import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/games/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';

void showStatusSheet(BuildContext context, GameDetailEntity game, LibraryItem? currentItem) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.xl.r))),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.fromLTRB(Dimens.lg.w, Dimens.sm.h, Dimens.lg.w, Dimens.xl.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             // Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: Dimens.lg.h),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2.r)),
              ),
            ),
            
            Text(
              "Update Status",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: Dimens.xl.h),

            Wrap(
              spacing: Dimens.md.w,
              runSpacing: Dimens.md.h,
              alignment: WrapAlignment.center,
              children: GameStatus.values.map((status) {
                final bool isSelected = currentItem?.status == status;
                final color = status.color;
                
                return InkWell(
                  onTap: () {
                    context.read<LibraryBloc>().add(
                      AddGameToLibrary(
                        LibraryItem(
                          gameId: game.id,
                          gameName: game.name,
                          posterPath: game.backgroundImage,
                          status: status,
                          addedAt: DateTime.now(),
                        ),
                      ),
                    );
                    Navigator.pop(sheetContext);
                  },
                  borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2, // 2 items per row roughly
                    padding: EdgeInsets.symmetric(vertical: Dimens.md.h, horizontal: Dimens.md.w),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.2) : Colors.white10,
                      borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(status.icon.icon, color: isSelected ? color : Colors.white70, size: 28.sp),
                        SizedBox(height: Dimens.xs.h),
                        Text(
                          status.name.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            if (currentItem != null) ...[
              SizedBox(height: Dimens.xl.h),
              Divider(color: Colors.white10),
              SizedBox(height: Dimens.md.h),
              TextButton.icon(
                onPressed: () {
                  context.read<LibraryBloc>().add(RemoveGameFromLibrary(game.id));
                  Navigator.pop(sheetContext);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                label: const Text("Remove from Library", style: TextStyle(color: Colors.redAccent)),
                style: TextButton.styleFrom(
                   padding: EdgeInsets.symmetric(vertical: Dimens.md.h),
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}