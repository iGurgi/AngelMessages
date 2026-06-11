import 'package:angel_messages/models/schedule_category.dart';
import 'package:angel_messages/repositories/message_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  NotificationScheduler({
    required FlutterLocalNotificationsPlugin plugin,
    required MessageRepository messageRepository,
  })  : _plugin = plugin,
        _messageRepository = messageRepository;

  final FlutterLocalNotificationsPlugin _plugin;
  final MessageRepository _messageRepository;
  bool _initialized = false;

  static const String channelId = 'angel_messages_channel';
  static const String channelName = 'Angel Messages';
  static const String channelDescription = 'Daily inspirational messages from your angels';

  /// Initialize timezone and notification plugin
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

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    _initialized = true;
  }

  /// Schedule notifications based on category
  Future<void> scheduleNotifications(ScheduleCategory category) async {
    await initialize();
    await cancelAllNotifications();

    switch (category) {
      case ScheduleCategory.angelTimes:
        await _scheduleAngelTimes();
      case ScheduleCategory.everyHour:
        await _scheduleEveryHour();
    }
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  /// Schedule angel times (1:11, 2:22, 3:33, etc.)
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
      await _scheduleDailyNotification(
        id: i,
        hour: time.hour,
        minute: time.minute,
      );
    }
  }

  /// Schedule hourly notifications
  Future<void> _scheduleEveryHour() async {
    for (var hour = 0; hour < 24; hour++) {
      await _scheduleDailyNotification(
        id: hour,
        hour: hour,
        minute: 0,
      );
    }
  }

  /// Schedule a daily notification at specific time
  Future<void> _scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      'Angel Message',
      'A new message from your angels awaits',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
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
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'angel_message',
    );
  }

  /// Show immediate notification with next unviewed message
  Future<void> showMessageNotification() async {
    final message = await _messageRepository.getNextUnviewedMessage();
    if (message == null) return;

    await _plugin.show(
      999, // Use high ID for immediate notifications
      message.title,
      message.body.length > 100
          ? '${message.body.substring(0, 100)}...'
          : message.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
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
      payload: message.id,
    );
  }
}

class TimeOfDay {
  const TimeOfDay({required this.hour, required this.minute});
  final int hour;
  final int minute;
}
