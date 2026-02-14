import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/features/library/domain/entities/library_item.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLibraryRepository extends Mock implements LibraryRepository {}
class FakeLibraryItem extends Fake implements LibraryItem {}

void main() {
  late LibraryBloc bloc;
  late MockLibraryRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeLibraryItem());
    registerFallbackValue(GameStatus.backlog);
  });

  setUp(() {
    mockRepository = MockLibraryRepository();
    bloc = LibraryBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  final tLibraryItem = LibraryItem(
    gameId: 1,
    gameName: 'Test Game',
    status: GameStatus.backlog,
    addedAt: DateTime(2023, 1, 1),
  );

  group('LibraryBloc', () {
    test('initial state should be LibraryInitial', () {
      expect(bloc.state, isA<LibraryInitial>());
    });

    blocTest<LibraryBloc, LibraryState>(
      'emits [LibraryLoading, LibraryLoaded] when WatchLibrary is added',
      build: () {
        when(() => mockRepository.getMyLibrary())
            .thenAnswer((_) => Stream.value([tLibraryItem]));
        return bloc;
      },
      act: (bloc) => bloc.add(WatchLibrary()),
      expect: () => [
        isA<LibraryLoading>(),
        isA<LibraryLoaded>().having((s) => s.items, 'items', [tLibraryItem]),
      ],
    );

    blocTest<LibraryBloc, LibraryState>(
      'calls addToLibrary on repository when AddGameToLibrary is added',
      build: () {
        when(() => mockRepository.addToLibrary(any()))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(AddGameToLibrary(tLibraryItem)),
      verify: (_) {
        verify(() => mockRepository.addToLibrary(any())).called(1);
      },
    );

    blocTest<LibraryBloc, LibraryState>(
      'calls updateGameStatus on repository when UpdateStatus is added',
      build: () {
        when(() => mockRepository.updateGameStatus(any(), any()))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateStatus(1, GameStatus.completed)),
      verify: (_) {
        verify(() => mockRepository.updateGameStatus(1, GameStatus.completed)).called(1);
      },
    );

    blocTest<LibraryBloc, LibraryState>(
      'calls removeFromLibrary on repository when RemoveGameFromLibrary is added',
      build: () {
        when(() => mockRepository.removeFromLibrary(any()))
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveGameFromLibrary(1)),
      verify: (_) {
        verify(() => mockRepository.removeFromLibrary(1)).called(1);
      },
    );
  });
}
