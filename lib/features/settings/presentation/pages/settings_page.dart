import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/settings/data/models/user_settings.dart';
import 'package:game_tracker/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:game_tracker/core/presentation/widgets/app_snackbar.dart';
import 'package:game_tracker/core/presentation/widgets/app_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsCubit>()..loadSettings(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is SettingsLoaded) {
            final settings = state.settings;
            return ListView(
              padding: EdgeInsets.all(Dimens.md.w),
              children: [
                _buildSectionHeader(context, 'Account'),
                _buildListTile(
                  context,
                  title: 'Logout',
                  icon: AppIcons.logout,
                  onTap: () => _showLogoutDialog(context),
                  textColor: AppColors.error,
                  iconColor: AppColors.error,
                ),
                SizedBox(height: Dimens.lg.h),
                _buildSectionHeader(context, 'Appearance'),
                _buildDropdownTile<ThemeSetting>(
                  context,
                  title: 'Theme Mode',
                  value: settings.themeMode,
                  items: ThemeSetting.values,
                  onChanged: (value) => context.read<SettingsCubit>().toggleTheme(value!),
                ),
                _buildDropdownTile<GridDensity>(
                  context,
                  title: 'Grid Density',
                  value: settings.gridDensity,
                  items: GridDensity.values,
                  onChanged: (value) => context.read<SettingsCubit>().setGridDensity(value!),
                ),
                SizedBox(height: Dimens.lg.h),
                _buildSectionHeader(context, 'Storage'),
                _buildListTile(
                  context,
                  title: 'Clear Image Cache',
                  icon: AppIcons.delete,
                  onTap: () => _showClearCacheDialog(context),
                ),
                SizedBox(height: Dimens.lg.h),
                _buildSectionHeader(context, 'About'),
                _buildListTile(
                  context,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  icon: AppIcons.info,
                ),
                _buildListTile(
                  context,
                  title: 'Data provided by RAWG',
                  icon: AppIcons.discovery,
                  onTap: () {
                    // Open RAWG website
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.sm.h, left: Dimens.xs.w),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: Dimens.sm.h),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusLg.r),
        ),
        leading: Icon(icon, color: iconColor ?? AppColors.primary),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor ?? AppColors.textPrimary,
              ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: onTap != null ? const Icon(Icons.chevron_right, color: AppColors.textTertiary) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildDropdownTile<T>(
    BuildContext context, {
    required String title,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: Dimens.sm.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.md.w, vertical: Dimens.xs.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            DropdownButton<T>(
              value: value,
              items: items.map((e) {
                return DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString().split('.').last),
                );
              }).toList(),
              onChanged: onChanged,
              underline: const SizedBox(),
              dropdownColor: AppColors.surface,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AppBottomSheet.showWarning(    
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      onConfirm: () {
        context.read<SettingsCubit>().logout();
        context.go('/login');
      },
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    AppBottomSheet.showWarning(
      context,
      title: 'Clear Cache',
      message: 'This will remove all locally stored game images.',
      warningDetails: 'They will be re-downloaded when needed.',
      confirmText: 'Clear',
      onConfirm: () {
        context.read<SettingsCubit>().clearCache();
        AppSnackbar.show(context, message: 'Image cache cleared', type: SnackbarType.success);
      },
    );
  }
}
