import 'package:flutter/material.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

class PlaytimeInputSheet extends StatefulWidget {
  final int initialMinutes;
  final Function(int) onSave;

  const PlaytimeInputSheet({
    super.key,
    required this.initialMinutes,
    required this.onSave,
  });

  @override
  State<PlaytimeInputSheet> createState() => _PlaytimeInputSheetState();
}

class _PlaytimeInputSheetState extends State<PlaytimeInputSheet> {
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    final hours = widget.initialMinutes ~/ 60;
    final minutes = widget.initialMinutes % 60;
    _hoursController = TextEditingController(text: hours > 0 ? hours.toString() : '');
    _minutesController = TextEditingController(text: minutes > 0 ? minutes.toString() : '');
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final totalMinutes = (hours * 60) + minutes;
    widget.onSave(totalMinutes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.lg.w, vertical: Dimens.sm.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.xl.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          Text(
            "Hours Played",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: Dimens.lg.h),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  controller: _hoursController,
                  label: "Hours",
                  hint: "0",
                ),
              ),
              SizedBox(width: Dimens.md.w),
              Expanded(
                child: _buildInputField(
                  controller: _minutesController,
                  label: "Minutes",
                  hint: "0",
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.lg.h),
          ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: Dimens.md.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
              ),
            ),
            child: Text(
              "Save Playtime",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: Dimens.md.h + MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: Dimens.xs.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusMd.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimens.md.w,
              vertical: Dimens.md.h,
            ),
          ),
        ),
      ],
    );
  }
}
