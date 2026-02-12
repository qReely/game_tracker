import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/router/app_router.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockGameRepository mockRepo;

  setUp(() async {
    await sl.reset();
    mockAuthRepository = MockAuthRepository();
    mockRepo = MockGameRepository();

    // Provide a dummy stream for the router's refreshListenable
    when(() => mockAuthRepository.authStateChanges).thenAnswer((_) => const Stream.empty());

    sl.registerSingleton<AuthRepository>(mockAuthRepository);
    sl.registerSingleton<GameRepository>(mockRepo);
    sl.registerFactory(() => LoginBloc(sl()));
    sl.registerFactory(() => GameBloc(sl()));
  });

  Widget createTestWidget() {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
      ),
    );
  }

  group('AppRouter Redirect Logic', () {
    testWidgets('should redirect to /login when user is NOT authenticated', (tester) async {
      // Arrange: Repository returns null for currentUser
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      // Act: Build the app
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Wait for redirects to complete

      // Assert: Verify we are at the login page
      // (Assumes your LoginPage has a specific key or unique text)
      expect(find.text("Sign in with Google"), findsOneWidget);
      expect(AppRouter.router.state?.matchedLocation, '/login');
    });

    testWidgets('should redirect to home (/) when user IS authenticated and tries to access login', (tester) async {
      // Arrange: Repository returns a valid user
      final tUser = AppUser(id: '1', email: 'test@me.com');
      when(() => mockAuthRepository.currentUser).thenReturn(tUser);
      when(() => mockRepo.getTrendingGames.call())
          .thenAnswer((_) async => <GameEntity>[]);

      // Act: Build the app
      await tester.pumpWidget(createTestWidget());

      // Manually try to go to login
      AppRouter.router.go('/login');
      await tester.pumpAndSettle();

      // Assert: The redirect should have kicked us back to home
      expect(AppRouter.router.state?.matchedLocation, '/');
    });
  });
}