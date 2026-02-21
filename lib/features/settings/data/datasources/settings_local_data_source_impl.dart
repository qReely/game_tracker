import 'package:game_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:game_tracker/features/settings/data/models/user_settings.dart';
import 'package:isar_community/isar.dart';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Isar isar;

  SettingsLocalDataSourceImpl(this.isar);

  @override
  Future<UserSettings> getSettings() async {
    final settings = await isar.userSettings.where().findFirst();
    if (settings == null) {
      // Create default settings if none exist
      final defaultSettings = UserSettings();
      await isar.writeTxn(() async {
        await isar.userSettings.put(defaultSettings);
      });
      return defaultSettings;
    }
    return settings;
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    await isar.writeTxn(() async {
      await isar.userSettings.put(settings);
    });
  }
}
