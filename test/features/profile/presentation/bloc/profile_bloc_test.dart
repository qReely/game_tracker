import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/library/domain/library_repository.dart';
import 'package:game_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:game_tracker/features/profile/presentation/bloc/profile_event.dart';
import 'package:game_tracker/features/profile/presentation/bloc/profile_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockLibraryRepository extends Mock implements LibraryRepository {}

void main() {
  late ProfileBloc bloc;
  late MockAuthRepository mockAuthRepository;
  late MockLibraryRepository mockLibraryRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLibraryRepository = MockLibraryRepository();
    bloc = ProfileBloc(mockAuthRepository, mockLibraryRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('ProfileBloc', () {
    final tUser = AppUser(id: '123', email: 'test@me.com');

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLinkSuccess] when account linking is successful',
      build: () {
        when(() => mockAuthRepository.linkGoogleAccount())
            .thenAnswer((_) async => tUser);
        when(() => mockLibraryRepository.syncLocalToRemote())
            .thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(LinkGoogleAccount()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLinkSuccess>(),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.linkGoogleAccount()).called(1);
        verify(() => mockLibraryRepository.syncLocalToRemote()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLinkFailure] when account linking fails',
      build: () {
        when(() => mockAuthRepository.linkGoogleAccount())
            .thenThrow(AuthFailure("Linking failed"));
        return bloc;
      },
      act: (bloc) => bloc.add(LinkGoogleAccount()),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLinkFailure>(),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileSignOutSuccess] when sign-out is requested',
      build: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [
        isA<ProfileSignOutSuccess>(),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.signOut()).called(1);
      },
    );
  });
}
