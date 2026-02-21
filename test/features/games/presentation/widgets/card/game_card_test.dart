import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/core/widgets/app_cached_image.dart';
import 'package:game_tracker/features/games/domain/entities/game_entity.dart';
import 'package:game_tracker/features/games/presentation/widgets/card/game_card.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';

class MockLibraryBloc extends MockBloc<LibraryEvent, LibraryState> implements LibraryBloc {}

void main() {
  late MockLibraryBloc mockLibraryBloc;

  final testGame = const GameEntity(
    id: 1,
    name: 'Test Game',
    backgroundImage: 'https://test.com/image.jpg',
    rating: 4.5,
    releasedYear: '2023',
    releasedDate: '2023-10-15',
  );

  setUp(() {
    mockLibraryBloc = MockLibraryBloc();
    when(() => mockLibraryBloc.state).thenReturn(LibraryInitial());
  });

  Widget createWidgetUnderTest({
    required GameEntity game,
    bool showDateBadge = false,
    bool showNotifyButton = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            UiScaler.init(context);
            return BlocProvider<LibraryBloc>.value(
              value: mockLibraryBloc,
              child: SizedBox(
                width: 200,
                height: 300,
                child: GameCard(
                  game: game,
                  showDateBadge: showDateBadge,
                  showNotifyButton: showNotifyButton,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  group('GameCard', () {
    testWidgets('renders game information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(game: testGame));

      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget); // releasedYear is usually derived or just year
    });

    testWidgets('shows date badge when requested', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(game: testGame, showDateBadge: true));

      expect(find.text('Oct 15, 2023'), findsOneWidget);
    });

    testWidgets('shows notify button when requested', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(game: testGame, showNotifyButton: true));

      expect(find.text('Test Game'), findsOneWidget);
      expect(find.byIcon(Icons.notification_add), findsOneWidget);
    });
  });
}
