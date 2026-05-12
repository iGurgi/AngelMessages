import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:angel_messages/data/database.dart';
import 'package:angel_messages/data/message_repository.dart';
import 'package:angel_messages/services/supabase_service.dart';
import 'package:angel_messages/services/notification_scheduler.dart';

part 'repository_providers.g.dart';

// TODO: Replace with actual Supabase credentials
const String _supabaseUrl = 'https://your-project.supabase.co';
const String _supabaseAnonKey = 'your-anon-key';

@riverpod
SupabaseService supabaseService(SupabaseServiceRef ref) {
  return SupabaseService(
    supabaseUrl: _supabaseUrl,
    supabaseAnonKey: _supabaseAnonKey,
  );
}

@riverpod
AppDatabase database(DatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
}

@riverpod
MessageRepository messageRepository(MessageRepositoryRef ref) {
  final database = ref.watch(databaseProvider);
  final supabaseService = ref.watch(supabaseServiceProvider);
  return MessageRepository(
    database: database,
    supabaseService: supabaseService,
  );
}

@riverpod
FlutterLocalNotificationsPlugin notificationsPlugin(
  NotificationsPluginRef ref,
) {
  return FlutterLocalNotificationsPlugin();
}

@riverpod
NotificationScheduler notificationScheduler(NotificationSchedulerRef ref) {
  final plugin = ref.watch(notificationsPluginProvider);
  final repository = ref.watch(messageRepositoryProvider);
  return NotificationScheduler(
    flutterLocalNotificationsPlugin: plugin,
    messageRepository: repository,
  );
}
