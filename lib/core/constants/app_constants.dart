/// Application-wide constants
class AppConstants {
  AppConstants._();

  // API Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // Database
  static const String dbName = 'angel_messages';

  // Notification Channels
  static const String notificationChannelId = 'angel_messages_channel';
  static const String notificationChannelName = 'Angel Messages';
  static const String notificationChannelDescription =
      'Daily inspirational messages from the angels';

  // Routing
  static const String routeHome = '/';
  static const String routeMessage = '/message/:id';
  static const String routeSettings = '/settings';

  // Preferences Keys
  static const String prefKeyScheduleCategory = 'schedule_category';
  static const String prefKeyFirstLaunch = 'first_launch';
  static const String prefKeyNotificationPermission = 'notification_permission';

  // Background Work
  static const String bgTaskDailySync = 'angelMessages.dailySync';
  static const String bgTaskUniqueName = 'angelMessagesDailySync';

  // Schedule Categories
  static const String scheduleCategoryAngelTimes = 'angel_times';
  static const String scheduleCategoryEveryHour = 'every_hour';

  // Angel Times (hours in 24-hour format)
  static const List<int> angelTimeHours = [1, 2, 3, 4, 5, 11, 12, 22];
  static const List<int> angelTimeMinutes = [11, 22, 33, 44, 55, 11, 12, 22];
}
