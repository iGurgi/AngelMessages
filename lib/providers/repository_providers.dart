import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
MessageRepository messageRepository(MessageRepositoryRef ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return MessageRepository(supabaseService: supabaseService);
}

@riverpod
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(
  FlutterLocalNotificationsPluginRef ref,
) {
  return FlutterLocalNotificationsPlugin();
}

@riverpod
NotificationScheduler notificationScheduler(NotificationSchedulerRef ref) {
  final plugin = ref.watch(flutterLocalNotificationsPluginProvider);
  final repository = ref.watch(messageRepositoryProvider);
  return NotificationScheduler(
    flutterLocalNotificationsPlugin: plugin,
    messageRepository: repository,
  );
}
