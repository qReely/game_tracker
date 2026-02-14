import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/app_typography.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),

      textTheme: AppTypography.textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimens.md.w,
          vertical: Dimens.md.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.lg.w,
            vertical: Dimens.md.h,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
          side: const BorderSide(color: AppColors.border),
        ),
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primary,
        secondaryLabelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: Dimens.sm.w, vertical: Dimens.xs.h),
      ),
    );
  }
}
