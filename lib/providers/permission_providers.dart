import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'permission_providers.g.dart';

const String _permissionRequestedKey = 'notification_permission_requested';

@riverpod
class NotificationPermission extends _$NotificationPermission {
  @override
  Future<PermissionStatus> build() async {
    return Permission.notification.status;
  }

  Future<void> request() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionRequestedKey, true);

    final status = await Permission.notification.request();
    state = AsyncValue.data(status);
  }

  Future<void> refresh() async {
    final status = await Permission.notification.status;
    state = AsyncValue.data(status);
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}

@riverpod
Future<bool> permissionRequested(PermissionRequestedRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_permissionRequestedKey) ?? false;
}

@riverpod
class ExactAlarmPermission extends _$ExactAlarmPermission {
  @override
  Future<PermissionStatus> build() async {
    return Permission.scheduleExactAlarm.status;
  }

  Future<void> request() async {
    final status = await Permission.scheduleExactAlarm.request();
    state = AsyncValue.data(status);
  }

  Future<void> refresh() async {
    final status = await Permission.scheduleExactAlarm.status;
    state = AsyncValue.data(status);
  }
}
