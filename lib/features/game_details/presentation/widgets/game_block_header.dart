import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class GameBlockHeader extends StatelessWidget {
  final String headerTitle;
  const GameBlockHeader({super.key, required this.headerTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.sm.h),
      child: Text(
        headerTitle, 
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
        ),
      ),
    );
  }
}
