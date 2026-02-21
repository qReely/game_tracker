import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

/// A reusable filter chip following the app's design system.
/// 
/// Two variants:
/// - **Default**: Surface background, primary when selected. Used for discovery/calendar chips.
/// - **Colored**: Custom `selectedColor` with checkmark. Used for library status chips.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final Color? selectedColor;
  final bool showCheckmark;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.selectedColor,
    this.showCheckmark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppColors.primary;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: AppColors.surface,
      selectedColor: selectedColor != null
          ? effectiveSelectedColor.withValues(alpha: 0.3)
          : AppColors.primary,
      checkmarkColor: showCheckmark ? Colors.white : null,
      showCheckmark: showCheckmark,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isSelected ? effectiveSelectedColor : AppColors.border,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w, vertical: 0),
    );
  }
}
