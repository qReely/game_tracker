import 'package:cached_network_image/cached_network_image.dart';
import 'package:game_tracker/core/utils/image_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/constants/app_icons.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/presentation/widgets/app_bottom_sheet.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:go_router/go_router.dart';

import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/presentation/widgets/app_snackbar.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';

import 'package:game_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:game_tracker/features/profile/presentation/bloc/profile_event.dart';
import 'package:game_tracker/features/profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLinkSuccess) {
            AppSnackbar.show(context, message: "Account linked successfully!", type: SnackbarType.success);
          }
          if (state is ProfileLinkFailure) {
            AppSnackbar.show(context, message: state.message, type: SnackbarType.error);
          }
          if (state is ProfileSignOutSuccess) {
            context.go('/login');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text("Profile"),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(AppIcons.settings),
                onPressed: () => context.push('/profile/settings'),
              ),
            ],
          ),
          body: BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, libraryState) {
              if (libraryState is LibraryLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildUserHeader(context),
                      const SizedBox(height: 32),
                      _buildStatsGrid(context, libraryState.items),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    final user = sl<AuthRepository>().currentUser;
    final isAnonymous = user?.isAnonymous ?? false;

    return Column(
      children: [
        CircleAvatar(
          foregroundImage: isAnonymous ? null : CachedNetworkImageProvider(
            user?.photoUrl ?? "",
            cacheManager: AppImageCacheManager.instance,
          ),
          backgroundColor: isAnonymous ? AppColors.surfaceLight : null,
          onForegroundImageError: isAnonymous ? null : (_, _) {},
          radius: 48,
          child: isAnonymous ? Icon(AppIcons.profile, size: 48, color: AppColors.textSecondary) : null,
        ),
        const SizedBox(height: 16),
        Text(
          isAnonymous ? "Anonymous User" : "${user?.displayName}",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (isAnonymous) ...[
          Text(
            "Sync your library to the cloud",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
          ),
          SizedBox(height: Dimens.md.h),
          OutlinedButton.icon(
            onPressed: () {
              AppBottomSheet.showWarning(
                context,
                title: "Link Google Account",
                message: "Linking your account will save your current library to the cloud.",
                warningDetails: "If the Google account you select already has a GameTracker profile, this linking process might fail or conflict.",
                confirmText: "Continue & Link",
                onConfirm: () => context.read<ProfileBloc>().add(LinkGoogleAccount()),
              );
            },
            icon: const Icon(AppIcons.google, size: 18),
            label: const Text("Connect Google Account"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radiusLg)),
            ),
          ),
        ] else
          Text(
            "Level 12 • Pro Explorer",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
          ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, List<LibraryItem> items) {
    // Logic to calculate stats
    final int total = items.length;
    final int completed = items.where((i) => i.status == GameStatus.completed).length;
    final int ratingSet = items.where((i) => i.userRating != null).length;

    final double avgRating = items.isEmpty
        ? 0.0
        : items.where((i) => i.userRating != null).fold(0.0, (sum, i) => sum + (i.userRating ?? 0)) / (ratingSet == 0 ? 1 : ratingSet);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(context, "GAMES", total.toString(), Colors.blueAccent),
        _buildStatCard(context, "BEATEN", completed.toString(), Colors.greenAccent),
        _buildStatCard(context, "RATING", avgRating.toStringAsFixed(1), Colors.amberAccent),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Dimens.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
          SizedBox(height: Dimens.xs),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textTertiary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}