import 'entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInAnonymously();
  Future<AppUser> linkGoogleAccount();
  Future<void> signOut();
}