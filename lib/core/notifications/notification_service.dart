import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_config.dart';

/// Service for managing local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification service
  static Future<void> initialize() async {
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings(
      NotificationConfig.iconName,
    );

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationConfig.androidChannel);
  }

  /// Handle notification tap events
  static void _onNotificationTapped(NotificationResponse response) {
    // TODO: Handle notification tap navigation
    // This will be implemented when navigation is fully set up
  }

  /// Request notification permission
  static Future<bool> requestPermission() async {
    final permission = Permission.notification;
    final status = await permission.request();
    return status.isGranted;
  }

  /// Check if notification permission is granted
  static Future<bool> hasPermission() async {
    final permission = Permission.notification;
    final status = await permission.status;
    return status.isGranted;
  }

  /// Show immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      NotificationConfig.notificationDetails,
      payload: payload?.entries
          .map((e) => '${e.key}:${e.value}')
          .join(';'),
    );
  }

  /// Schedule notification for specific time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    Map<String, String>? payload,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationConfig.notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload?.entries
          .map((e) => '${e.key}:${e.value}')
          .join(';'),
    );
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}