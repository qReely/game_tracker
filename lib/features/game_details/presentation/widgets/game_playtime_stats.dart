import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:game_tracker/features/library/presentation/widgets/playtime_input_sheet.dart';

class GamePlaytimeStats extends StatelessWidget {
  final int gameId;
  final int? playtimeMinutes;

  const GamePlaytimeStats({
    super.key,
    required this.gameId,
    this.playtimeMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final minutesTotal = playtimeMinutes ?? 0;
    final hours = minutesTotal ~/ 60;
    final minutes = minutesTotal % 60;

    String displayTime = "";
    if (playtimeMinutes == null || playtimeMinutes == 0) {
      displayTime = "Set Playtime";
    } else {
      if (hours > 0) displayTime += "${hours}h ";
      if (minutes > 0 || hours == 0) displayTime += "${minutes}m";
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => PlaytimeInputSheet(
            initialMinutes: playtimeMinutes ?? 0,
            onSave: (newMinutes) {
              context.read<LibraryBloc>().add(UpdatePlaytime(gameId, newMinutes));
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimens.md.h, horizontal: Dimens.md.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
          border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_filled, color: AppColors.primary, size: 20.sp),
            SizedBox(width: Dimens.md.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GameBlockHeader(headerTitle: "My Playtime",),
                Text(
                  displayTime,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.edit, color: AppColors.textTertiary, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
