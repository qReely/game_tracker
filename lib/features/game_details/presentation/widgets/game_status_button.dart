import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:game_tracker/features/library/presentation/widgets/status_selection_sheet.dart';
import 'package:collection/collection.dart';

class GameStatusButton extends StatelessWidget {
  final GameDetailEntity game;

  const GameStatusButton({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        LibraryItem? libraryItem;

        if (state is LibraryLoaded) {
          libraryItem = state.items.firstWhereOrNull(
            (item) => item.gameId == game.id,
          );
        }

        final bool isInLibrary = libraryItem != null;

        return SizedBox(
           height: 50.h,
           width: double.infinity, 
           child: ElevatedButton.icon(
             onPressed: () => showStatusSheet(
               context,
               gameId: game.id,
               gameName: game.name,
               posterPath: game.backgroundImage,
               releasedYear: game.released.split('-').first,
               platforms: game.platforms,
               currentItem: libraryItem,
             ),
             icon: Icon(
               isInLibrary ? libraryItem.status.icon.icon : AppIcons.add,
               color: isInLibrary ? libraryItem.status.color : Colors.white,
               size: Dimens.iconMd.sp,
             ),
             label: Text(
               isInLibrary ? libraryItem.status.name.toUpperCase() : "Add to Library",
               style: Theme.of(context).textTheme.labelLarge?.copyWith(
                 color: isInLibrary ? libraryItem.status.color : Colors.white,
                 fontWeight: FontWeight.bold,
                 fontSize: 14.sp,
               ),
             ),
             style: ElevatedButton.styleFrom(
               backgroundColor: isInLibrary ? AppColors.surfaceLight : AppColors.primary,
               padding: EdgeInsets.symmetric(horizontal: Dimens.lg.w),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(Dimens.radiusXl.r),
                 side: isInLibrary ? BorderSide(color: libraryItem.status.color) : BorderSide.none,
               ),
               elevation: 0,
             ),
           ),
        );
      },
    );
  }
}
