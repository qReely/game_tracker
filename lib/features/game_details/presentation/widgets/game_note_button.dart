import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/game_details/domain/entities/game_detail_entity.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:collection/collection.dart';

class GameNoteButton extends StatelessWidget {
  final GameDetailEntity game;

  const GameNoteButton({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        String? note;
        if (state is LibraryLoaded) {
          note = state.items.firstWhereOrNull((i) => i.gameId == game.id)?.privateNote;
        }
        
        return Material(
          color: AppColors.surface,
          shape: const CircleBorder(side: BorderSide(color: Colors.white12)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.pushNamed(
              'game_notes',
              pathParameters: {'id': game.id.toString()},
              extra: {'gameName': game.name, 'initialNote': note},
            ),
            child: SizedBox(
              width: 50.h,
              height: 50.h,
              child: Center(
                child: Icon(
                  note != null && note.isNotEmpty ? AppIcons.note : AppIcons.noteAdd,
                  color: Colors.white,
                  size: Dimens.iconMd.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
