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
  late MockGameRepository mockRepo;

  setUp(() {
    mockRepo = MockGameRepository();
  });

  group('GameBloc', () {
    const tGame = GameEntity(id: 1, name: "Test", rating: 4.5);

    blocTest<GameBloc, GameState>(
      'emits [GamesLoading, GamesLoaded] when successful',
      build: () {
        when(() => mockRepo.getTrendingGames()).thenAnswer((_) async => [tGame]);
        return GameBloc(mockRepo);
      },
      act: (bloc) => bloc.add(FetchTrendingGames()),
      expect: () => [
        isA<GamesLoading>(),
        isA<GamesLoaded>(),
      ],
    );

    blocTest<GameBloc, GameState>(
      'emits [GamesLoading, GamesError] when failure occurs',
      build: () {
        when(() => mockRepo.getTrendingGames()).thenThrow(GamesLoadingFailure());
        return GameBloc(mockRepo);
      },
      act: (bloc) => bloc.add(FetchTrendingGames()),
      expect: () => [
        isA<GamesLoading>(),
        isA<GamesError>(),
      ],
    );
  });
}