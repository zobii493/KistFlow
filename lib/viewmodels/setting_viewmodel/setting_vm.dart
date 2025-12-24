import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kistflow/viewmodels/setting_viewmodel/theme_vm.dart';

import '../../models/setting/app_preference.dart';
import '../../models/setting/user_profile.dart';
import '../../repositories/setting_repository.dart';

class SettingsViewModel extends StateNotifier<AsyncValue<UserProfile>> {
  final SettingsRepository _repository;
  final Ref ref;

  SettingsViewModel(this._repository, this.ref)
      : super(const AsyncValue.loading()) {
    loadData();
  }

  AppPreferences _preferences = AppPreferences(
    theme: 'light',
    notificationsEnabled: true,
    reminderAlerts: true,
    overdueAlerts: true,
  );

  AppPreferences get preferences => _preferences;

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.loadUserProfile();
      _preferences = await _repository.loadPreferences();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }


  Future<void> refreshUserData() async {
    await loadData();
  }
  Future<void> updateUserName(String name) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      await _repository.updateUserName(name);
      state = AsyncValue.data(currentState.copyWith(name: name));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateAvatar(String avatar) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      await _repository.saveUserAvatar(avatar);
      state = AsyncValue.data(currentState.copyWith(avatar: avatar));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTheme(String theme) async {
    _preferences = _preferences.copyWith(theme: theme);
    await _repository.savePreferences(_preferences);

    // THIS LINE WAS MISSING
    ref.read(themeViewModelProvider.notifier).setTheme(theme);
  }


  Future<void> updateNotifications(bool enabled) async {
    _preferences = _preferences.copyWith(notificationsEnabled: enabled);
    await _repository.savePreferences(_preferences);
  }

  Future<void> updateReminders(bool enabled) async {
    _preferences = _preferences.copyWith(reminderAlerts: enabled);
    await _repository.savePreferences(_preferences);
  }

  Future<void> updateOverdueAlerts(bool enabled) async {
    _preferences = _preferences.copyWith(overdueAlerts: enabled);
    await _repository.savePreferences(_preferences);
  }

  // =================== PASSWORD CHANGE ===================
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  // =================== DELETE ACCOUNT ===================
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    return await _repository.deleteAccount(password);
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final settingsViewModelProvider =
StateNotifierProvider<SettingsViewModel, AsyncValue<UserProfile>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsViewModel(repository, ref);
});
