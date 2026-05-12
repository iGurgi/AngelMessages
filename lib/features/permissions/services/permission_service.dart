import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _permissionRequestedKey = 'notification_permission_requested';

class PermissionService {
  /// Check and request notification permission if needed
  static Future<bool> requestNotificationPermission(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasRequested = prefs.getBool(_permissionRequestedKey) ?? false;

    // Check current permission status
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    // Show rationale dialog on first launch
    if (!hasRequested && context.mounted) {
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Text(
            'Angel Messages would like to send you inspirational '
            'messages at special times throughout the day. Would you '
            'like to enable notifications?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Not Now'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Enable'),
            ),
          ],
        ),
      );

      await prefs.setBool(_permissionRequestedKey, true);

      if (shouldRequest != true) {
        return false;
      }
    }

    // Request permission
    final newStatus = await Permission.notification.request();
    return newStatus.isGranted;
  }

  /// Show snackbar with action to open settings if permission denied
  static void showPermissionDeniedSnackBar(BuildContext context) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notifications are disabled'),
        action: SnackBarAction(
          label: 'Enable',
          onPressed: () async {
            await openAppSettings();
          },
        ),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  /// Check if notification permission is granted
  static Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
}
