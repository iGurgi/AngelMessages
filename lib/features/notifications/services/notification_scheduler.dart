import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:angel_messages/core/config/environment.dart';
import 'package:angel_messages/core/models/schedule_category.dart';
import 'package:angel_messages/features/messages/data/message_repository.dart';

class NotificationScheduler {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final MessageRepository _messageRepository;

  NotificationScheduler({
    required MessageRepository messageRepository,
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  })  : _messageRepository = messageRepository,
        _notificationsPlugin = notificationsPlugin ??
            FlutterLocalNotificationsPlugin();

  /// Initialize the notification system
  Future<void> initialize() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      Environment.notificationChannelId,
      Environment.notificationChannelName,
      description: Environment.notificationChannelDescription,
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Schedule notifications based on category
  Future<void> scheduleNotifications(ScheduleCategory category) async {
    // Cancel all existing notifications first
    await _notificationsPlugin.cancelAll();

    switch (category) {
      case ScheduleCategory.angelTimes:
        await _scheduleAngelTimes();
        break;
      case ScheduleCategory.everyHour:
        await _scheduleEveryHour();
        break;
    }
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Schedule notifications for angel times (1:11, 2:22, 3:33, 4:44, 5:55, 11:11, 12:12, 22:22)
  Future<void> _scheduleAngelTimes() async {
    final angelTimes = [
      const TimeOfDay(hour: 1, minute: 11),
      const TimeOfDay(hour: 2, minute: 22),
      const TimeOfDay(hour: 3, minute: 33),
      const TimeOfDay(hour: 4, minute: 44),
      const TimeOfDay(hour: 5, minute: 55),
      const TimeOfDay(hour: 11, minute: 11),
      const TimeOfDay(hour: 12, minute: 12),
      const TimeOfDay(hour: 22, minute: 22),
    ];

    for (var i = 0; i < angelTimes.length; i++) {
      final time = angelTimes[i];
      await _scheduleDaily(i, time.hour, time.minute);
    }
  }

  /// Schedule notifications every hour
  Future<void> _scheduleEveryHour() async {
    for (var hour = 0; hour < 24; hour++) {
      await _scheduleDaily(hour, hour, 0);
    }
  }

  /// Schedule a daily notification at a specific time
  Future<void> _scheduleDaily(int id, int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Get the next unviewed message
    final message = await _messageRepository.getNextUnviewedMessage();

    if (message == null) {
      return; // No messages available
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      message.title,
      message.body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          Environment.notificationChannelId,
          Environment.notificationChannelName,
          channelDescription: Environment.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
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
      matchDateTimeComponents: DateTimeComponents.time,
      payload: message.id,
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      // The router will handle navigation via deep link
      // This is set up in main.dart
    }
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});
}
