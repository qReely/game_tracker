import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:game_tracker/core/utils/app_snackbar.dart';
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
                onPressed: () => context.push('/settings'),
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final user = sl<AuthRepository>().currentUser;
                  final isAnonymous = user?.isAnonymous ?? false;
                  if(isAnonymous) return SizedBox.shrink();
                  return IconButton(
                    icon: const Icon(AppIcons.logout),
                    onPressed: () {
                      AppBottomSheet.showWarning(
                        context,
                        title: "Sign Out",
                        message: "Are you sure you want to sign out?",
                        confirmText: "Sign Out",
                        onConfirm: () => context.read<ProfileBloc>().add(SignOutRequested()),
                      );
                    },
                  );
                },
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
                      _buildStatsGrid(libraryState.items),
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
          ),
          backgroundColor: isAnonymous ? AppColors.surfaceLight : null,
          onForegroundImageError: isAnonymous ? null : (_, _) {},
          radius: 48,
          child: isAnonymous ? const Icon(Icons.person_outline, size: 48, color: Colors.white54) : null,
        ),
        const SizedBox(height: 16),
        Text(
          isAnonymous ? "Anonymous User" : "${user?.displayName}",
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _buildStatsGrid(List<LibraryItem> items) {
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
        _buildStatCard("GAMES", total.toString(), Colors.blueAccent),
        _buildStatCard("BEATEN", completed.toString(), Colors.greenAccent),
        _buildStatCard("RATING", avgRating.toStringAsFixed(1), Colors.amberAccent),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}