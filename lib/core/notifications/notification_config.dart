import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationConfig {
  static const String channelId = 'angel_messages';
  static const String channelName = 'Angel Messages';
  static const String channelDescription = 'Daily angel messages and spiritual guidance';
  
  // Angel-themed notification icon (should be placed in android/app/src/main/res/drawable/)
  static const String iconName = 'ic_angel_notification';
  
  // Title format with angel emoji
  static String formatTitle() => 'Angel Message ✨';
  
  // Content truncation helper
  static String truncateContent(String content, {int maxLength = 50}) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength - 3)}...';
  }
  
  // Android notification details with custom styling
  static AndroidNotificationDetails get androidDetails => AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.high,
    priority: Priority.high,
    icon: iconName,
    color: const Color(0xFF6B46C1), // Purple theme color
    enableLights: true,
    ledColor: const Color(0xFF6B46C1),
    ledOnMs: 1000,
    ledOffMs: 500,
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
    category: AndroidNotificationCategory.reminder,
    visibility: NotificationVisibility.public,
    ongoing: false,
    autoCancel: true,
    showWhen: true,
    when: null, // Will use current timestamp
    usesChronometer: false,
    showProgress: false,
    maxProgress: 0,
    progress: 0,
    indeterminate: false,
    channelShowBadge: true,
    onlyAlertOnce: false,
    playSound: true,
    sound: null, // Use default notification sound
    colorized: true,
    groupKey: 'angel_messages_group',
    groupAlertBehavior: GroupAlertBehavior.children,
    setAsGroupSummary: false,
    ticker: 'New Angel Message',
    additionalFlags: null,
    fullScreenIntent: false,
    shortcutId: null,
    subText: null,
    tag: null,
    timeoutAfter: null,
    silent: false,
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'read_message',
        'Read Message',
        cancelNotification: true,
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        'save_favorite',
        'Save as Favorite',
        cancelNotification: false,
        showsUserInterface: false,
      ),
    ],
  );
  
  // Complete notification details for cross-platform
  static NotificationDetails get notificationDetails => NotificationDetails(
    android: androidDetails,
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: null, // Use default sound
      badgeNumber: null,
      threadIdentifier: 'angel_messages',
      categoryIdentifier: 'angel_message_category',
      interruptionLevel: InterruptionLevel.active,
    ),
  );
  
  // Notification channel for Android initialization
  static AndroidNotificationChannel get androidChannel => const AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.high,
    enableLights: true,
    ledColor: Color(0xFF6B46C1),
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
    showBadge: true,
    playSound: true,
    sound: null,
  );
  
  // Helper method to create notification payload
  static Map<String, String> createPayload({
    required String messageId,
    required String messageContent,
    String? category,
  }) => {
    'messageId': messageId,
    'messageContent': messageContent,
    'category': category ?? 'daily',
    'timestamp': DateTime.now().toIso8601String(),
  };
  
  // Format notification for display
  static ({String title, String body}) formatNotification(String content) => (
    title: formatTitle(),
    body: truncateContent(content),
  );
}
