import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'permission_service.g.dart';

const String _permissionAskedKey = 'notification_permission_asked';

@riverpod
PermissionService permissionService(PermissionServiceRef ref) {
  return PermissionService();
}

@riverpod
Future<PermissionStatus> notificationPermission(
  NotificationPermissionRef ref,
) async {
  return Permission.notification.status;
}

class PermissionService {
  /// Request notification permission with rationale
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.notification.request();
      await _markPermissionAsked();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Request exact alarm permission (Android 14+)
  Future<bool> requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.scheduleExactAlarm.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Check if this is the first app launch
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_permissionAskedKey);
  }

  /// Mark that permission has been asked
  Future<void> _markPermissionAsked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionAskedKey, true);
  }

  /// Show permission rationale dialog
  Future<bool> showPermissionRationale(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text(
          'Angel Messages would like to send you daily inspirational messages. '
          'Allow notifications to receive your daily angel guidance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not Now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
}

extension on Permission {
  Future<PermissionStatus> get status async {
    final status = await this.status;
    if (status.isGranted) return PermissionStatus.granted;
    if (status.isDenied) return PermissionStatus.denied;
    if (status.isPermanentlyDenied) return PermissionStatus.permanentlyDenied;
    if (status.isRestricted) return PermissionStatus.restricted;
    return PermissionStatus.denied;
  }
}
