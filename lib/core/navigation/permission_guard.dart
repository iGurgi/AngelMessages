import 'package:permission_handler.dart';

/// Navigation guard utility for checking permissions before route access
class PermissionGuard {
  /// Checks if notification permission is granted
  /// 
  /// Returns `true` if notification permission is granted or permanently denied
  /// (on some platforms permanently denied still allows notifications).
  /// Returns `false` if permission is denied and can be requested.
  static Future<bool> checkNotificationPermission() async {
    final permission = Permission.notification;
    final status = await permission.status;
    
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        // Permission is denied but can be requested
        return false;
      case PermissionStatus.permanentlyDenied:
        // On some platforms, permanently denied still allows notifications
        // Return true to avoid blocking navigation, handle in UI instead
        return true;
      case PermissionStatus.restricted:
        // Permission is restricted (iOS parental controls, etc.)
        return false;
      case PermissionStatus.limited:
        // Limited permission (iOS 14+)
        return true;
      case PermissionStatus.provisional:
        // Provisional permission (iOS quiet notifications)
        return true;
    }
  }
}
