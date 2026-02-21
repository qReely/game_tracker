import 'package:flutter/material.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class GameSystemRequirements extends StatelessWidget {
  final Map<String, String> pcRequirements;
  const GameSystemRequirements({super.key, required this.pcRequirements});

  @override
  Widget build(BuildContext context) {
    final cleanMin = parseRequirements(pcRequirements['minimum']?.replaceAll("Minimum:", "").trim() ?? "");
    if (cleanMin.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameBlockHeader(headerTitle: "System Requirements"),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(Dimens.lg.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
            border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MINIMUM", 
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary, 
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: Dimens.md.h),
              ...cleanMin.entries.map((entry) => _buildSpecRow(context, entry.key, entry.value)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.md.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary, 
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary, 
                height: 1.4,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> parseRequirements(String rawString) {
    final Map<String, String> specs = {};

    // Define the keys we want to extract
    final keys = ['OS', 'Processor', 'Memory', 'Graphics', 'Storage'];

    // Regex to find a key followed by its value until the next key or end of string
    // It looks for patterns like "OS: ... Processor:"
    for (var i = 0; i < keys.length; i++) {
      final currentKey = keys[i];
      final nextKey = (i + 1 < keys.length) ? keys[i + 1] : null;

      // Create a regex for the current key
      final regExp = RegExp(
        '$currentKey: (.*?)(?=${nextKey != null ? "$nextKey:" : r"Sound Card:|Additional Notes:|Other requirements:|$"})',
        caseSensitive: false,
        dotAll: true,
      );

      final match = regExp.firstMatch(rawString);
      if (match != null) {
        specs[currentKey] = match.group(1)?.trim() ?? 'N/A';
      }
    }

    return specs;
  }
}