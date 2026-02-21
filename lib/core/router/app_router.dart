import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/router/router_utils.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/games/domain/repositories/discovery_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/genre/genre_games_bloc.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:game_tracker/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:game_tracker/features/games/presentation/pages/discovery_page.dart';
import 'package:game_tracker/features/game_details/presentation/pages/game_details_page.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_cubit.dart';
import 'package:game_tracker/features/library/presentation/pages/library_page.dart';
import 'package:game_tracker/features/profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:game_tracker/features/auth/presentation/pages/login_page.dart';
import 'package:game_tracker/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:game_tracker/features/schedule/presentation/pages/schedule_page.dart';
import 'package:game_tracker/features/games/presentation/pages/game_notes_page.dart';
import 'package:game_tracker/features/games/presentation/pages/games_by_company_page.dart';
import 'package:game_tracker/features/games/presentation/pages/genre_games_page.dart';
import 'package:game_tracker/features/settings/presentation/pages/settings_page.dart';

import 'scaffold_wrapper.dart';

class AppRouter {
  static final router = GoRouter(
    refreshListenable: GoRouterRefreshStream(sl<AuthRepository>().authStateChanges),
    redirect: (context, state) {
      final bool loggedIn = sl<AuthRepository>().currentUser != null;
      final bool isLoggingIn = state.matchedLocation == '/login';

      if (!loggedIn) return isLoggingIn ? null : '/login';
      if (!loggedIn && !isLoggingIn) return '/login';
      if (loggedIn && isLoggingIn) return '/';

      return null;
    },
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => DiscoveryBloc(
                  repository: sl<DiscoveryRepository>(),
                  filterCubit: sl<DiscoveryFilterCubit>(),
                )..add(RefreshDiscovery()), // Fetch on launch
              ),
              BlocProvider.value(value: sl<DiscoveryFilterCubit>()),
            ],
            child: MainScaffold(navigationShell: navigationShell),
          );
        },
        branches: [
          // BRANCH 1: HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'dashboard',
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<DashboardBloc>()..add(LoadDashboardData()),
                  child: const DashboardPage(),
                ),
                routes: [
                   // Sub-routes like /game/:id live here so the bottom bar stays visible
                   GoRoute(
                    path: 'game/:id',
                    name: 'game_details',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return GameDetailsPage(gameId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'notes',
                        name: 'game_notes',
                        builder: (context, state) {
                          final id = int.parse(state.pathParameters['id']!);
                          final extra = state.extra as Map<String, dynamic>?;
                          return GameNotesPage(
                            gameId: id,
                            gameName: extra?['gameName'] ?? 'Game',
                            initialNote: extra?['initialNote'],
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'publisher/:slug',
                    name: 'publisher',
                    builder: (context, state) {
                      final slug = state.pathParameters['slug']!;
                      final name = state.uri.queryParameters['name'] ?? 'Publisher';
                      return GamesByCompanyPage(
                        companySlug: slug,
                        companyName: name,
                        isPublisher: true,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'developer/:slug',
                    name: 'developer',
                    builder: (context, state) {
                      final slug = state.pathParameters['slug']!;
                      final name = state.uri.queryParameters['name'] ?? 'Developer';
                      return GamesByCompanyPage(
                        companySlug: slug,
                        companyName: name,
                        isPublisher: false,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'genre/:slug',
                    name: 'genre_games',
                    builder: (context, state) {
                      final slug = state.pathParameters['slug']!;
                      final name = state.uri.queryParameters['name'] ?? 'Genre';
                      return BlocProvider(
                        create: (context) => sl<GenreGamesBloc>()..add(FetchGamesByGenre(slug)),
                        child: GenreGamesPage(
                          genreSlug: slug,
                          genreName: name,
                        ),
                      );
                    },
                  ),
                ]
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discovery',
                name: 'discovery',
                builder: (context, state) => const DiscoveryPage(),
              )
            ],
          ),

          // BRANCH 2: LIBRARY
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                name: 'library',
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<LibraryFilterCubit>(),
                  child: const LibraryPage(),
                ),
              ),
            ],
          ),

          // BRANCH 4: CALENDAR
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/schedule',
                name: 'schedule',
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<ScheduleBloc>(),
                  child: const SchedulePage(),
                ),
              ),
            ],
          ),

          // BRANCH 3: PROFILE
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // LOGIN is outside the Shell because we don't want the bottom bar there
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}