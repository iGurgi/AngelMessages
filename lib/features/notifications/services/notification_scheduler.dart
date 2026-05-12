import 'package:angel_messages/core/constants/app_constants.dart';
import 'package:angel_messages/features/messages/data/repositories/message_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for scheduling local notifications
class NotificationScheduler {
  NotificationScheduler({
    required FlutterLocalNotificationsPlugin notificationsPlugin,
    required MessageRepository messageRepository,
  })  : _notificationsPlugin = notificationsPlugin,
        _messageRepository = messageRepository;

  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final MessageRepository _messageRepository;
  bool _initialized = false;

  /// Initialize the notification system
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Initialize notification plugin
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    _initialized = true;
  }

  /// Schedule notifications based on category
  Future<void> scheduleNotifications(String category) async {
    await initialize();

    // Cancel all existing notifications
    await _notificationsPlugin.cancelAll();

    switch (category) {
      case AppConstants.scheduleCategoryAngelTimes:
        await _scheduleAngelTimes();
        break;
      case AppConstants.scheduleCategoryEveryHour:
        await _scheduleEveryHour();
        break;
    }
  }

  /// Schedule notifications at angel times (1:11, 2:22, 3:33, etc.)
  Future<void> _scheduleAngelTimes() async {
    final now = tz.TZDateTime.now(tz.local);
    
    // Angel times configuration
    final angelTimes = [
      _TimeSpec(1, 11),
      _TimeSpec(2, 22),
      _TimeSpec(3, 33),
      _TimeSpec(4, 44),
      _TimeSpec(5, 55),
      _TimeSpec(11, 11),
      _TimeSpec(12, 12),
      _TimeSpec(22, 22),
    ];

    for (var i = 0; i < angelTimes.length; i++) {
      final spec = angelTimes[i];
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        spec.hour,
        spec.minute,
      );

      // If time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _scheduleNotificationAt(
        id: i,
        scheduledDate: scheduledDate,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Schedule notifications every hour at the top of the hour
  Future<void> _scheduleEveryHour() async {
    final now = tz.TZDateTime.now(tz.local);
    
    // Schedule for next hour
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour + 1,
      0,
    );

    // If we're at 23:xx, schedule for 00:00 tomorrow
    if (scheduledDate.hour == 0 && now.hour == 23) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _scheduleNotificationAt(
      id: 0,
      scheduledDate: scheduledDate,
      matchDateTimeComponents: DateTimeComponents.hourAndMinute,
    );
  }

  /// Schedule a notification at a specific time
  Future<void> _scheduleNotificationAt({
    required int id,
    required tz.TZDateTime scheduledDate,
    required DateTimeComponents matchDateTimeComponents,
  }) async {
    // Get next unviewed message for the notification
    final message = await _messageRepository.getNextUnviewedMessage();
    
    if (message == null) {
      // No messages available, schedule generic notification
      await _notificationsPlugin.zonedSchedule(
        id,
        'Angel Message',
        'Your daily inspiration awaits ✨',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.notificationChannelId,
            AppConstants.notificationChannelName,
            channelDescription: AppConstants.notificationChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchDateTimeComponents,
      );
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      message.title,
      _truncateBody(message.body),
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchDateTimeComponents,
      payload: message.id,
    );
  }

  /// Truncate message body for notification preview
  String _truncateBody(String body) {
    const maxLength = 100;
    if (body.length <= maxLength) return body;
    return '${body.substring(0, maxLength)}...';
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Get list of pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notificationsPlugin.pendingNotificationRequests();
  }
}

/// Internal class for time specification
class _TimeSpec {
  _TimeSpec(this.hour, this.minute);
  final int hour;
  final int minute;
}
