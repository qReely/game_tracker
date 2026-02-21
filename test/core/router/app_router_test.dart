import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/di/injection_container.dart';
import 'package:game_tracker/core/router/app_router.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:game_tracker/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:game_tracker/features/games/domain/repositories/discovery_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_cubit.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'package:game_tracker/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/discovery/discovery_filter_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockDiscoveryRepository extends Mock implements DiscoveryRepository {}
class MockLibraryRepository extends Mock implements LibraryRepository {}

class FakeDiscoveryFilterState extends Fake implements DiscoveryFilterState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDiscoveryFilterState());
  });

  late MockAuthRepository mockAuthRepository;
  late MockDiscoveryRepository mockDiscoveryRepo;
  late MockLibraryRepository mockLibraryRepo;

  setUp(() async {
    await sl.reset();
    mockAuthRepository = MockAuthRepository();
    mockDiscoveryRepo = MockDiscoveryRepository();
    mockLibraryRepo = MockLibraryRepository();

    // Provide a dummy stream for the router's refreshListenable
    when(() => mockAuthRepository.authStateChanges).thenAnswer((_) => const Stream.empty());
    when(() => mockLibraryRepo.getMyLibrary()).thenAnswer((_) => const Stream.empty());
    
    // Stub DiscoveryRepository methods used by DashboardBloc
    when(() => mockDiscoveryRepo.getDiscoveryGames(any(), any())).thenAnswer((_) async => []);
    when(() => mockDiscoveryRepo.getPopularCommunityGames()).thenAnswer((_) async => []);

    sl.registerSingleton<AuthRepository>(mockAuthRepository);
    sl.registerSingleton<DiscoveryRepository>(mockDiscoveryRepo);
    sl.registerSingleton<LibraryRepository>(mockLibraryRepo);
    
    sl.registerFactory(() => LoginBloc(sl()));
    sl.registerLazySingleton(() => DiscoveryFilterCubit());
    sl.registerFactory(() => DiscoveryBloc(repository: sl(), filterCubit: sl()));
    sl.registerFactory(() => DashboardBloc(libraryRepository: sl(), discoveryRepository: sl()));
    sl.registerFactory(() => ScheduleBloc(repository: sl()));
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<DiscoveryFilterCubit>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        builder: (context, child) {
          UiScaler.init(context);
          return child!;
        },
      ),
    );
  }

  testWidgets('should boot successfully with Dashboard as home', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

