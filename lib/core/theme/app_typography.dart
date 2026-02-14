import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class AppTypography {
  static TextTheme get textTheme {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 57.sp,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 45.sp,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 36.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.outfit(
        color: AppColors.textSecondary,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.outfit(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.outfit(
        color: AppColors.textTertiary,
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.outfit(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.outfit(
        color: AppColors.textTertiary,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}