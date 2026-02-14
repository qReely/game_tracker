import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/router/app_router.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
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
    when(() => mockAuthRepository.authStateChanges).thenAnswer((
        _) => const Stream.empty());

    // Stub getTrendingGames for all tests since GameBloc may be created during routing
    when(() => mockRepo.getTrendingGames()).thenAnswer((_) async =>
    <GameEntity>[]);

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
        builder: (context, child) {
          UiScaler.init(context);
          return child!;
        },
      ),
    );
  }
}

