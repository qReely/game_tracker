import 'package:game_tracker/features/settings/data/models/user_settings.dart';

abstract class SettingsLocalDataSource {
  Future<UserSettings> getSettings();
  Future<void> saveSettings(UserSettings settings);
}
