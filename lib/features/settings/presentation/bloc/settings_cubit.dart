import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_tracker/features/settings/data/models/user_settings.dart';
import 'package:game_tracker/features/settings/domain/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final settings = await repository.getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateSettings(UserSettings settings) async {
    try {
      await repository.updateSettings(settings);
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> toggleTheme(ThemeSetting theme) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      current.themeMode = theme;
      await updateSettings(current);
    }
  }

  Future<void> setGridDensity(GridDensity density) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      current.gridDensity = density;
      await updateSettings(current);
    }
  }

  Future<void> clearCache() async {
    try {
      await repository.clearCache();
      // Optionally notify success
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await repository.logout();
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
