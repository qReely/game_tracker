import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_tracker/core/utils/image_cache_manager.dart';
import 'package:game_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:game_tracker/features/settings/data/models/user_settings.dart';
import 'package:game_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final FirebaseAuth firebaseAuth;

  SettingsRepositoryImpl(this.localDataSource, this.firebaseAuth);

  @override
  Future<UserSettings> getSettings() async {
    return await localDataSource.getSettings();
  }

  @override
  Future<void> updateSettings(UserSettings settings) async {
    await localDataSource.saveSettings(settings);
  }

  @override
  Future<void> clearCache() async {
    await AppImageCacheManager.instance.emptyCache();
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn.instance.signOut();
    await firebaseAuth.signOut();
  }
}
