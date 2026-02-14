import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/constants/app_icons.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, 
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        backgroundColor: AppColors.background,
        destinations: const [
          NavigationDestination(
            icon: Icon(AppIcons.home), 
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.discovery),
            label: 'Discovery',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.library),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.profile),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    // Navigate to the branch (Home, Library, or Profile)
    navigationShell.goBranch(
      index,
      // If the user taps the same tab twice, it resets that tab's navigation stack
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}