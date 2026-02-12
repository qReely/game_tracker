import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:game_tracker/core/error/failures.dart';
import 'package:game_tracker/features/auth/data/mappers/user_mapper.dart';
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  FirebaseAuthRepository(this._auth, this._googleSignIn);

  @override
  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().map((firebaseUser) {
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
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}