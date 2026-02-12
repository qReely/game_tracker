import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/router/router_utils.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/games/presentation/pages/game_details_page.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_cubit.dart';
import 'package:game_tracker/features/library/presentation/pages/library_page.dart';
import 'package:go_router/go_router.dart';
import 'package:game_tracker/features/auth/presentation/pages/login_page.dart';
import 'package:game_tracker/features/games/presentation/pages/games_page.dart';

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
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // Example of a sub-route for Game Details
      GoRoute(
        path: '/game/:id',
        name: 'game_details',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return GameDetailsPage(gameId: id);
        },
      ),
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => BlocProvider(
          create: (_) => LibraryFilterCubit(),
          child: const LibraryPage(),
        ),
      ),
    ],
  );
}