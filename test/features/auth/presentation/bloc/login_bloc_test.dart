import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_bloc.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_event.dart';
import 'package:game_tracker/features/auth/presentation/bloc/login_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  blocTest<LoginBloc, LoginState>(
    'emits [LoginLoading, LoginSuccess] when login is successful',
    build: () {
      when(() => mockRepo.signInWithGoogle())
          .thenAnswer((_) async => AppUser(id: '1', email: 'test@me.com'));
      return LoginBloc(mockRepo);
    },
    act: (bloc) => bloc.add(GoogleSignInRequested()),
    expect: () => [
      isA<LoginLoading>(),
      isA<LoginSuccess>(),
    ],
  );
}