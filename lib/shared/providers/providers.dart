import 'package:angel_messages/core/constants/app_constants.dart';
import 'package:angel_messages/features/messages/data/data_sources/local/message_local_data_source.dart';
import 'package:angel_messages/features/messages/data/data_sources/remote/message_remote_data_source.dart';
import 'package:angel_messages/features/messages/data/models/message.dart';
import 'package:angel_messages/features/messages/data/repositories/message_repository.dart';
import 'package:angel_messages/features/notifications/services/background_sync_service.dart';
import 'package:angel_messages/features/notifications/services/notification_scheduler.dart';
import 'package:angel_messages/features/settings/data/repositories/settings_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

// ============================================================================
// Infrastructure Providers
// ============================================================================

/// Provides Isar database instance
@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [MessageSchema],
    directory: dir.path,
    name: AppConstants.dbName,
  );
  ref.onDispose(isar.close);
  return isar;
}

/// Provides SharedPreferences instance
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

/// Provides Dio HTTP client
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  return dio;
}

/// Provides FlutterLocalNotificationsPlugin
@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin notificationsPlugin(
  NotificationsPluginRef ref,
) {
  return FlutterLocalNotificationsPlugin();
}

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provides MessageLocalDataSource
@Riverpod(keepAlive: true)
Future<MessageLocalDataSource> messageLocalDataSource(
  MessageLocalDataSourceRef ref,
) async {
  final isar = await ref.watch(isarProvider.future);
  return MessageLocalDataSource(isar);
}

/// Provides MessageRemoteDataSource
@Riverpod(keepAlive: true)
MessageRemoteDataSource messageRemoteDataSource(
  MessageRemoteDataSourceRef ref,
) {
  final dio = ref.watch(dioProvider);
  return MessageRemoteDataSource(dio);
}

// ============================================================================
// Repository Providers
// ============================================================================

/// Provides MessageRepository
@Riverpod(keepAlive: true)
Future<MessageRepository> messageRepository(MessageRepositoryRef ref) async {
  final localDataSource = await ref.watch(messageLocalDataSourceProvider.future);
  final remoteDataSource = ref.watch(messageRemoteDataSourceProvider);
  return MessageRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
}

/// Provides SettingsRepository
@Riverpod(keepAlive: true)
Future<SettingsRepository> settingsRepository(
  SettingsRepositoryRef ref,
) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return SettingsRepository(prefs);
}

// ============================================================================
// Service Providers
// ============================================================================

/// Provides NotificationScheduler
@Riverpod(keepAlive: true)
Future<NotificationScheduler> notificationScheduler(
  NotificationSchedulerRef ref,
) async {
  final notificationsPlugin = ref.watch(notificationsPluginProvider);
  final messageRepository = await ref.watch(messageRepositoryProvider.future);
  return NotificationScheduler(
    notificationsPlugin: notificationsPlugin,
    messageRepository: messageRepository,
  );
}

/// Provides BackgroundSyncService
@Riverpod(keepAlive: true)
Future<BackgroundSyncService> backgroundSyncService(
  BackgroundSyncServiceRef ref,
) async {
  final messageRepository = await ref.watch(messageRepositoryProvider.future);
  return BackgroundSyncService(messageRepository: messageRepository);
}

// ============================================================================
// State Providers
// ============================================================================

/// Provides list of all messages
@riverpod
Future<List<Message>> messages(MessagesRef ref) async {
  final repository = await ref.watch(messageRepositoryProvider.future);
  return repository.getMessages();
}

/// Provides a specific message by ID
@riverpod
Future<Message?> message(MessageRef ref, String id) async {
  final repository = await ref.watch(messageRepositoryProvider.future);
  return repository.getMessageById(id);
}

/// Provides the current schedule category
@riverpod
class ScheduleCategory extends _$ScheduleCategory {
  @override
  Future<String> build() async {
    final repository = await ref.watch(settingsRepositoryProvider.future);
    return repository.getScheduleCategory();
  }

  /// Update the schedule category
  Future<void> setCategory(String category) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    await repository.setScheduleCategory(category);
    
    // Reschedule notifications
    final scheduler = await ref.read(notificationSchedulerProvider.future);
    await scheduler.scheduleNotifications(category);
    
    // Update state
    ref.invalidateSelf();
  }
}

/// Provides notification permission status
@riverpod
class NotificationPermission extends _$NotificationPermission {
  @override
  Future<bool> build() async {
    final repository = await ref.watch(settingsRepositoryProvider.future);
    return repository.getNotificationPermissionGranted();
  }

  /// Update permission status
  Future<void> setGranted(bool granted) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    await repository.setNotificationPermissionGranted(granted);
    ref.invalidateSelf();
  }
}

/// Provides unviewed message count
@riverpod
Future<int> unviewedMessageCount(UnviewedMessageCountRef ref) async {
  final repository = await ref.watch(messageRepositoryProvider.future);
  return repository.getUnviewedCount();
}
