import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/features/library/presentation/cubit/library_filter_cubit.dart';

void main() {
  late LibraryFilterCubit libraryCubit;

  setUp(() {
    libraryCubit = LibraryFilterCubit();
  });

  tearDown(() {
    libraryCubit.close();
  });
}
