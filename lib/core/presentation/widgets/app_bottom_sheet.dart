import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:go_router/go_router.dart';

enum AppBottomSheetType { confirmation, warning, info }

class AppBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String? secondaryMessage;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final AppBottomSheetType type;
  final Widget? icon;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.secondaryMessage,
    required this.confirmText,
    this.cancelText = "Cancel",
    required this.onConfirm,
    this.onCancel,
    this.type = AppBottomSheetType.confirmation,
    this.icon,
  });

  static Future<void> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: Dimens.sheetMaxWidth),
      builder: (_) => AppBottomSheet(
        title: title,
        message: message,
        onConfirm: onConfirm,
        confirmText: confirmText,
        cancelText: cancelText,
        type: AppBottomSheetType.confirmation,
      ),
    );
  }

  static Future<void> showWarning(
    BuildContext context, {
    required String title,
    required String message,
    String? warningDetails,
    required VoidCallback onConfirm,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: Dimens.sheetMaxWidth),
      builder: (_) => AppBottomSheet(
        title: title,
        message: message,
        secondaryMessage: warningDetails,
        onConfirm: onConfirm,
        confirmText: confirmText,
        cancelText: cancelText,
        type: AppBottomSheetType.warning,
      ),
    );
  }

  static Future<void> showInfo(
      BuildContext context, {
        required String title,
        required String message,
        String buttonText = "Got it",
        VoidCallback? onDismiss,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: Dimens.sheetMaxWidth),
      builder: (_) => AppBottomSheet(
        title: title,
        message: message,
        onConfirm: onDismiss ?? () {}, // Just close
        confirmText: buttonText,
        cancelText: "", // No cancel button
        type: AppBottomSheetType.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWarning = type == AppBottomSheetType.warning;

    return Container(
      padding: EdgeInsets.all(Dimens.lg.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.xl.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: Dimens.lg.h),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          
          if (icon != null) ...[
             Center(child: icon),
             SizedBox(height: Dimens.md.h),
          ],

          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: Dimens.md.h),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          
          if (secondaryMessage != null) ...[
            SizedBox(height: Dimens.md.h),
            Container(
              padding: EdgeInsets.all(Dimens.md.w),
              decoration: BoxDecoration(
                color: isWarning ? AppColors.warning.withValues(alpha: 0.1) : Colors.white10,
                borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
                border: isWarning ? Border.all(color: AppColors.warning.withValues(alpha: 0.3)) : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
                    color: isWarning ? AppColors.warning : Colors.white70,
                    size: 24.sp
                  ),
                  SizedBox(width: Dimens.sm.w),
                  Expanded(
                    child: Text(
                      secondaryMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isWarning ? AppColors.textSecondary : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          SizedBox(height: Dimens.xl.h),
          
          Row(
            children: [
              if (type != AppBottomSheetType.info && cancelText.isNotEmpty)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (onCancel != null) onCancel!();
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: Dimens.md.h),
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radiusLg.r)),
                    ),
                    child: Text(cancelText, style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              
              if (type != AppBottomSheetType.info && cancelText.isNotEmpty)
                 SizedBox(width: Dimens.md.w),
              
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close sheet
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWarning ? AppColors.warning : AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: Dimens.md.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radiusLg.r)),
                  ),
                  child: Text(
                    confirmText,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.md.h), // Safe area spacer if needed
        ],
      ),
    );
  }
}
