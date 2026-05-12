class Environment {
  // Supabase configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key-here',
  );

  // API endpoints
  static String get messagesEndpoint => '$supabaseUrl/rest/v1/messages';

  // Deep link scheme
  static const String deepLinkScheme = 'angelmessages';

  // Notification channels
  static const String notificationChannelId = 'angel_messages_channel';
  static const String notificationChannelName = 'Angel Messages';
  static const String notificationChannelDescription =
      'Inspirational angel messages';

  // Background task identifiers
  static const String dailySyncTaskName = 'angelMessages.dailySync';
}
