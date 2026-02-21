import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:game_tracker/core/utils/ui_scaler.dart';
import 'package:game_tracker/features/game_details/presentation/widgets/game_playtime_stats.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_bloc.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_event.dart';
import 'package:game_tracker/features/library/presentation/bloc/library_state.dart';
import 'package:game_tracker/features/library/presentation/widgets/playtime_input_sheet.dart';

class MockLibraryBloc extends MockBloc<LibraryEvent, LibraryState> implements LibraryBloc {}

void main() {
  late MockLibraryBloc mockLibraryBloc;

  setUp(() {
    mockLibraryBloc = MockLibraryBloc();
  });

  Widget createWidgetUnderTest({int? playtimeMinutes}) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<LibraryBloc>.value(
          value: mockLibraryBloc,
          child: Builder(
            builder: (context) {
              UiScaler.init(context);
              return GamePlaytimeStats(
                gameId: 1,
                playtimeMinutes: playtimeMinutes,
              );
            },
          ),
        ),
      ),
    );
  }

  group('GamePlaytimeStats', () {
    testWidgets('shows "Set Playtime" when playtime is null', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(playtimeMinutes: null));

      expect(find.text('Set Playtime'), findsOneWidget);
    });

    testWidgets('shows "Set Playtime" when playtime is 0', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(playtimeMinutes: 0));

      expect(find.text('Set Playtime'), findsOneWidget);
    });

    testWidgets('formats playtime correctly for under an hour', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(playtimeMinutes: 45));

      expect(find.text('45m'), findsOneWidget);
    });

    testWidgets('formats playtime correctly for exactly one hour', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(playtimeMinutes: 60));

      expect(find.text('1h '), findsOneWidget);
    });

    testWidgets('formats playtime correctly for over an hour', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(playtimeMinutes: 135)); // 2h 15m

      expect(find.text('2h 15m'), findsOneWidget);
    });

    testWidgets('opens PlaytimeInputSheet when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(playtimeMinutes: 30));

      await tester.tap(find.byType(GamePlaytimeStats));
      await tester.pumpAndSettle();

      expect(find.byType(PlaytimeInputSheet), findsOneWidget);
    });
  });
}
