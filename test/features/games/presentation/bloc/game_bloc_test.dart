import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/domain/game_repository.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_bloc.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_event.dart';
import 'package:game_tracker/features/games/presentation/bloc/game_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late GameBloc bloc;
  late MockGameRepository mockRepository;

  setUp(() {
    mockRepository = MockGameRepository();
    bloc = GameBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  const tGame = GameEntity(id: 1, name: 'Game 1', rating: 4.5);
  const tGame2 = GameEntity(id: 2, name: 'Game 2', rating: 4.0);

  group('GameBloc', () {
    test('initial state should be GamesInitial', () {
      expect(bloc.state, isA<GamesInitial>());
    });

    blocTest<GameBloc, GameState>(
      'emits [GamesLoading, GamesLoaded] when FetchGames is successful',
      build: () {
        when(() => mockRepository.getTrendingGames(page: any(named: 'page')))
            .thenAnswer((_) async => [tGame]);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchGames()),
      expect: () => [
        isA<GamesLoading>(),
        isA<GamesLoaded>().having((s) => s.games, 'games', [tGame]),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits [GamesLoading, GamesError] when FetchGames fails',
      build: () {
        when(() => mockRepository.getTrendingGames(page: any(named: 'page')))
            .thenThrow(GamesLoadingFailure());
        return bloc;
      },
      act: (bloc) => bloc.add(FetchGames()),
      expect: () => [
        isA<GamesLoading>(),
        isA<GamesError>(),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits updated GamesLoaded when LoadMoreGames is successful',
      build: () {
        when(() => mockRepository.getTrendingGames(page: 2))
            .thenAnswer((_) async => [tGame2]);
        return bloc;
      },
      seed: () => GamesLoaded(games: [tGame], hasReachedMax: false),
      act: (bloc) => bloc.add(LoadMoreGames()),
      expect: () => [
        isA<GamesLoaded>().having((s) => s.games, 'games', [tGame, tGame2]),
      ],
    );
  });
}
