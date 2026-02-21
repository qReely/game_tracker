import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';

class GameUserRatingBar extends StatelessWidget {
  final int gameId;
  final double currentRating;

  const GameUserRatingBar({super.key, required this.gameId, required this.currentRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameBlockHeader(headerTitle: "Your Rating",),
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            final isFilled = starValue <= currentRating;

            return IconButton(
              onPressed: () {
                context.read<LibraryBloc>().add(UpdateUserRating(gameId, starValue));
              },
              icon: Icon(
                isFilled ? AppIcons.star : AppIcons.starOutline,
                color: isFilled ? AppColors.warning : AppColors.textSecondary,
                size: 32.sp,
              ),
            );
          }),
        ),
      ],
    );
  }
}