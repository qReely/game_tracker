import 'package:flutter_test/flutter_test.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/auth/data/repositiories/firebase_auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FakeAuthCredential extends Fake implements AuthCredential {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

void main() {
  late FirebaseAuthRepository repository;
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    repository = FirebaseAuthRepository(mockAuth, mockGoogleSignIn);
  });

  group('signInWithGoogle', () {
    test('should return AppUser when sign-in is successful', () async {
      final mockGoogleAccount = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();
      final mockUserCredential = MockUserCredential();
      final mockFirebaseUser = MockUser();

      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockGoogleAccount);

      // Uses .authentication directly, matching the real implementation
      when(() => mockGoogleAccount.authentication)
          .thenReturn(mockGoogleAuth);
      when(() => mockGoogleAuth.idToken).thenReturn('fake-id-token');

      when(() => mockAuth.signInWithCredential(any()))
          .thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockFirebaseUser);
      when(() => mockFirebaseUser.uid).thenReturn('123');
      when(() => mockFirebaseUser.email).thenReturn('test@game.com');

      final result = await repository.signInWithGoogle();

      expect(result.id, '123');
      expect(result.email, 'test@game.com');
      verify(() => mockGoogleSignIn.authenticate()).called(1);
      verify(() => mockAuth.signInWithCredential(any())).called(1);
    });

    test('should throw AuthFailure when platform does not support authenticate', () async {
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(false);

      await expectLater(
            () => repository.signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );

      verifyNever(() => mockGoogleSignIn.authenticate());
    });

    test('should throw AuthFailure when user cancels sign-in', () async {
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(() => mockGoogleSignIn.authenticate()).thenThrow(
        GoogleSignInException(
          code: GoogleSignInExceptionCode.canceled,
          description: 'activity is cancelled by the user.',
        ),
      );

      await expectLater(
            () => repository.signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('should throw AuthFailure when Firebase user is null', () async {
      final mockGoogleAccount = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();
      final mockUserCredential = MockUserCredential();

      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockGoogleAccount);
      when(() => mockGoogleAccount.authentication)
          .thenReturn(mockGoogleAuth);
      when(() => mockGoogleAuth.idToken).thenReturn('fake-id-token');
      when(() => mockAuth.signInWithCredential(any()))
          .thenAnswer((_) async => mockUserCredential);
      // Firebase returns null user → should trigger AuthFailure
      when(() => mockUserCredential.user).thenReturn(null);

      await expectLater(
            () => repository.signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('should throw AuthFailure on FirebaseAuthException', () async {
      final mockGoogleAccount = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();

      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(() => mockGoogleSignIn.authenticate())
          .thenAnswer((_) async => mockGoogleAccount);
      when(() => mockGoogleAccount.authentication)
          .thenReturn(mockGoogleAuth);
      when(() => mockGoogleAuth.idToken).thenReturn('fake-id-token');
      when(() => mockAuth.signInWithCredential(any()))
          .thenThrow(FirebaseAuthException(code: 'network-request-failed'));

      await expectLater(
            () => repository.signInWithGoogle(),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  group('signOut', () {
    test('should call sign out on both Firebase and Google', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockAuth.signOut()).called(1);
    });
  });
}