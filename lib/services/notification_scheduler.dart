import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:angel_messages/models/schedule_category.dart';
import 'package:angel_messages/data/message_repository.dart';

class NotificationScheduler {
  NotificationScheduler({
    required this.flutterLocalNotificationsPlugin,
    required this.messageRepository,
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final MessageRepository messageRepository;

  static const String channelId = 'angel_messages_channel';
  static const String channelName = 'Angel Messages';
  static const String channelDescription = 'Inspirational messages from your angels';

  /// Initialize timezone data
  Future<void> initializeTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  /// Initialize notification plugin
  Future<void> initialize() async {
    await initializeTimezone();

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

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Schedule notifications based on category
  Future<void> scheduleNotifications(ScheduleCategory category) async {
    await cancelAll();

    await category.when(
      angelTimes: () => _scheduleAngelTimes(),
      everyHour: () => _scheduleEveryHour(),
    );
  }

  /// Schedule Angel Times notifications (1:11, 2:22, 3:33, 4:44, 5:55, 11:11, 12:12, 22:22)
  Future<void> _scheduleAngelTimes() async {
    final angelTimes = [
      _TimeSpec(hour: 1, minute: 11),
      _TimeSpec(hour: 2, minute: 22),
      _TimeSpec(hour: 3, minute: 33),
      _TimeSpec(hour: 4, minute: 44),
      _TimeSpec(hour: 5, minute: 55),
      _TimeSpec(hour: 11, minute: 11),
      _TimeSpec(hour: 12, minute: 12),
      _TimeSpec(hour: 22, minute: 22),
    ];

    for (var i = 0; i < angelTimes.length; i++) {
      final time = angelTimes[i];
      await _scheduleDailyAtTime(
        id: i,
        hour: time.hour,
        minute: time.minute,
      );
    }
  }

  /// Schedule every hour notifications
  Future<void> _scheduleEveryHour() async {
    for (var hour = 0; hour < 24; hour++) {
      await _scheduleDailyAtTime(
        id: hour,
        hour: hour,
        minute: 0,
      );
    }
  }

  /// Schedule a daily notification at specific time
  Future<void> _scheduleDailyAtTime({
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

    // Get next unviewed message for notification content
    final message = await messageRepository.getNextUnviewedMessage();

    if (message == null) {
      return; // No messages to show
    }

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      message.title,
      _truncateBody(message.body),
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: message.id,
    );
  }

  /// Truncate body for notification preview
  String _truncateBody(String body) {
    const maxLength = 100;
    if (body.length <= maxLength) {
      return body;
    }
    return '${body.substring(0, maxLength)}...';
  }

  /// Show immediate notification (for testing)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}

/// Internal time specification class
class _TimeSpec {
  _TimeSpec({required this.hour, required this.minute});
  final int hour;
  final int minute;
}
