import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/theme/app_colors.dart';
import 'package:game_tracker/core/theme/dimens.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:game_tracker/features/dashboard/presentation/widgets/game_carousel.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_block_header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return _buildLoadingHome();
          }

          if (state is DashboardLoaded) {
            return _buildLoadedHome(state);
          }

          if (state is DashboardError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(Dimens.lg.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Dimens.md.h),
                    ElevatedButton(
                      onPressed: () => context.read<DashboardBloc>().add(LoadDashboardData()),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingHome() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: Dimens.md.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Your Sessions"),
          const GameCarousel(games: [], isLoading: true, sectionId: 'loading_sessions'),
          SizedBox(height: 32.h),
          _buildSectionHeader("Upcoming Releases"),
          const GameCarousel(games: [], isLoading: true, sectionId: 'loading_upcoming'),
          SizedBox(height: 32.h),
          _buildSectionHeader("Community Favorites"),
          const GameCarousel(games: [], isLoading: true, sectionId: 'loading_popular'),
        ],
      ),
    );
  }

  Widget _buildLoadedHome(DashboardLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(LoadDashboardData());
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: Dimens.md.h),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.currentSessions.isNotEmpty) ...[
              _buildSectionHeader("Your Sessions"),
              GameCarousel(games: state.currentSessions, sectionId: 'sessions'),
              SizedBox(height: 32.h),
            ],
            
            _buildSectionHeader("Upcoming Releases"),
            GameCarousel(games: state.upcomingReleases, sectionId: 'upcoming'),
            SizedBox(height: 32.h),

            if (state.popularCommunity.isNotEmpty) ...[
              _buildSectionHeader("Community Favorites"),
              GameCarousel(games: state.popularCommunity, sectionId: 'popular'),
              SizedBox(height: 32.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.md.w),
      child: GameBlockHeader(headerTitle: title),
    );
  }
}
