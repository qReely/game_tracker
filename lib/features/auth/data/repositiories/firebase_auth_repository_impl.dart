import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/auth/data/mappers/user_mapper.dart';
import 'package:game_tracker/features/auth/domain/auth_repository.dart';
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  FirebaseAuthRepository(this._auth, this._googleSignIn);

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user?.toEntity();
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _auth.userChanges().map((firebaseUser) {
      // If firebaseUser is null, return null. Otherwise, map to entity.
      return firebaseUser?.toEntity();
    });
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      if (!_googleSignIn.supportsAuthenticate()) {
        throw AuthFailure("Direct sign-in not supported on this platform.");
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthFailure("Firebase user creation failed.");
      }

      return userCredential.user!.toEntity();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AuthFailure("No user found with this email.");
        case 'wrong-password':
          throw AuthFailure("Incorrect password.");
        case 'network-request-failed':
          throw NetworkFailure();
        default:
          throw AuthFailure("An authentication error occurred.");
      }
    } catch (e) {
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.canceled) {
        throw AuthFailure("Sign-in cancelled.");
      }
      debugPrint(e.toString());
      throw AuthFailure("Connection failed. Please try again.");
    }
  }

  @override
  Future<AppUser> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      if (userCredential.user == null) {
        throw AuthFailure("Anonymous sign-in failed.");
      }
      return userCredential.user!.toEntity();
    } on FirebaseAuthException catch (e) {
      debugPrint("Anonymous Auth Error: ${e.code} - ${e.message}");
      throw AuthFailure("Failed to sign in anonymously.");
    }
  }

  @override
  @override
  Future<AppUser> linkGoogleAccount() async {
    OAuthCredential? credential;
    
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw AuthFailure("No user is currently signed in.");
      }

      if (!_googleSignIn.supportsAuthenticate()) {
        throw AuthFailure("Direct sign-in not supported on this platform.");
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      // Use linkWithCredential to link the Google account to the existing anonymous user
      final userCredential = await currentUser.linkWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthFailure("Linking failed.");
      }

      return userCredential.user!.toEntity();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use' && credential != null) {
        // The Google account already exists - sign out anonymous and sign in with Google
        debugPrint("Google account already exists. Signing in with existing account...");
        await _auth.signOut();
        final userCredential = await _auth.signInWithCredential(credential);
        
        if (userCredential.user == null) {
          throw AuthFailure("Failed to sign in with existing account.");
        }
        
        return userCredential.user!.toEntity();
      } else if (e.code == 'requires-recent-login') {
        throw AuthFailure("Please sign in again to link your account.");
      }
      throw AuthFailure("Failed to link account: ${e.message}");
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure("An unexpected error occurred during account linking.");
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}