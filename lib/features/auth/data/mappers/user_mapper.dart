import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:game_tracker/features/auth/domain/entities/app_user.dart';

extension FirebaseUserX on firebase.User {
  AppUser toEntity() {
    return AppUser(
      id: uid,
      email: email ?? '',
      displayName: displayName,
      photoUrl: photoURL,
    );
  }
}