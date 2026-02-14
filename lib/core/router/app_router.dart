import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/router/router_utils.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_event.dart';
import 'package:game_tracker/features/games/presentation/pages/discovery_page.dart';
import 'package:game_tracker/features/games/presentation/pages/game_details_page.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_cubit.dart';
import 'package:game_tracker/features/library/presentation/pages/library_page.dart';
import 'package:game_tracker/features/profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:game_tracker/features/auth/presentation/pages/login_page.dart';
import 'package:game_tracker/features/games/presentation/pages/games_page.dart';

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
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // BRANCH 1: HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<GameBloc>()..add(FetchGames()),
                  child: const HomePage(),
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
                builder: (context, state) {
                  final filterCubit = sl<DiscoveryFilterCubit>();

                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: filterCubit),
                      BlocProvider(
                        create: (context) => DiscoveryBloc(
                          repository: sl<GameRepository>(),
                          filterCubit: filterCubit,
                        ),
                      ),
                    ],
                    child: const DiscoveryPage(),
                  );
                },
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

          // BRANCH 3: PROFILE
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
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