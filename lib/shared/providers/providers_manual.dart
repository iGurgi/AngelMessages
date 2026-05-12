// Manual providers without code generation - used during initial setup
// This file allows pub get to succeed before build_runner is run

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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Manual Provider definitions (to be replaced with generated ones)

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [MessageSchema],
    directory: dir.path,
    name: AppConstants.dbName,
  );
  ref.onDispose(isar.close);
  return isar;
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final notificationsPluginProvider = Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final messageLocalDataSourceProvider = FutureProvider<MessageLocalDataSource>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return MessageLocalDataSource(isar);
});

final messageRemoteDataSourceProvider = Provider<MessageRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return MessageRemoteDataSource(dio);
});

final messageRepositoryProvider = FutureProvider<MessageRepository>((ref) async {
  final localDataSource = await ref.watch(messageLocalDataSourceProvider.future);
  final remoteDataSource = ref.watch(messageRemoteDataSourceProvider);
  return MessageRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

final settingsRepositoryProvider = FutureProvider<SettingsRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return SettingsRepository(prefs);
});

final notificationSchedulerProvider = FutureProvider<NotificationScheduler>((ref) async {
  final notificationsPlugin = ref.watch(notificationsPluginProvider);
  final messageRepository = await ref.watch(messageRepositoryProvider.future);
  return NotificationScheduler(
    notificationsPlugin: notificationsPlugin,
    messageRepository: messageRepository,
  );
});

final backgroundSyncServiceProvider = FutureProvider<BackgroundSyncService>((ref) async {
  final messageRepository = await ref.watch(messageRepositoryProvider.future);
  return BackgroundSyncService(messageRepository: messageRepository);
});

final messagesProvider = FutureProvider<List<Message>>((ref) async {
  final repository = await ref.watch(messageRepositoryProvider.future);
  return repository.getMessages();
});

final messageProvider = FutureProvider.family<Message?, String>((ref, String id) async {
  final repository = await ref.watch(messageRepositoryProvider.future);
  return repository.getMessageById(id);
});

// These need to be StateNotifierProviders but for simplicity using FutureProviders
final scheduleCategoryProvider = FutureProvider<String>((ref) async {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  return repository.getScheduleCategory();
});

final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  return repository.getNotificationPermissionGranted();
});

final unviewedMessageCountProvider = FutureProvider<int>((ref) async {
  final repository = await ref.watch(messageRepositoryProvider.future);
  return repository.getUnviewedCount();
});
