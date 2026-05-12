import 'package:angel_messages/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing app settings using SharedPreferences
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  /// Get the current schedule category
  String getScheduleCategory() {
    return _prefs.getString(AppConstants.prefKeyScheduleCategory) ??
        AppConstants.scheduleCategoryAngelTimes;
  }

  /// Set the schedule category
  Future<void> setScheduleCategory(String category) async {
    await _prefs.setString(AppConstants.prefKeyScheduleCategory, category);
  }

  /// Check if this is the first app launch
  bool isFirstLaunch() {
    return _prefs.getBool(AppConstants.prefKeyFirstLaunch) ?? true;
  }

  /// Mark first launch as complete
  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool(AppConstants.prefKeyFirstLaunch, false);
  }

  /// Get notification permission status
  bool getNotificationPermissionGranted() {
    return _prefs.getBool(AppConstants.prefKeyNotificationPermission) ?? false;
  }

  /// Set notification permission status
  Future<void> setNotificationPermissionGranted(bool granted) async {
    await _prefs.setBool(AppConstants.prefKeyNotificationPermission, granted);
  }
}
