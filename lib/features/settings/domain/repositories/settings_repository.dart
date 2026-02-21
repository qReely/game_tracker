import 'package:game_tracker/features/settings/data/models/user_settings.dart';

abstract class SettingsRepository {
  Future<UserSettings> getSettings();
  Future<void> updateSettings(UserSettings settings);
  Future<void> clearCache();
  Future<void> logout();
}
