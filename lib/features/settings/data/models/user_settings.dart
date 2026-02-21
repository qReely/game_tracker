import 'package:isar_community/isar.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  // UI Settings
  @enumerated
  late ThemeSetting themeMode = ThemeSetting.system;
  
  @enumerated
  late GridDensity gridDensity = GridDensity.comfortable;

  // Discovery Preferences
  late String region = 'US';
  late bool adultContentFiltered = true;

  // Account Preferences (Local cache for UI state)
  bool? isNotificationsEnabled = true;
}

enum ThemeSetting {
  light,
  dark,
  system,
}

enum GridDensity {
  compact,
  comfortable,
}
