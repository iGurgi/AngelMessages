// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// Minimal stubs to allow pub get to succeed
// Run: dart run build_runner build --delete-conflicting-outputs
// to generate the full implementation

String _$isarHash() => r'isar';
typedef IsarRef = AutoDisposeFutureProviderRef<Isar>;

class $IsarProvider extends AutoDisposeFutureProvider<Isar> {
  $IsarProvider() : super((ref) => ref.watch(isarProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $IsarProvider;
  }
  
  @override
  int get hashCode => _$isarHash().hashCode;
}

final isarProvider = $IsarProvider();

String _$sharedPreferencesHash() => r'sharedPreferences';
typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;

class $SharedPreferencesProvider extends AutoDisposeFutureProvider<SharedPreferences> {
  $SharedPreferencesProvider() : super((ref) => ref.watch(sharedPreferencesProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $SharedPreferencesProvider;
  }
  
  @override
  int get hashCode => _$sharedPreferencesHash().hashCode;
}

final sharedPreferencesProvider = $SharedPreferencesProvider();

String _$dioHash() => r'dio';
typedef DioRef = AutoDisposeProviderRef<Dio>;

class $DioProvider extends AutoDisposeProvider<Dio> {
  $DioProvider() : super((ref) => ref.watch(dioProvider));
  
  @override
  bool operator ==(Object other) {
    return other is $DioProvider;
  }
  
  @override
  int get hashCode => _$dioHash().hashCode;
}

final dioProvider = $DioProvider();

String _$notificationsPluginHash() => r'notificationsPlugin';
typedef NotificationsPluginRef = AutoDisposeProviderRef<FlutterLocalNotificationsPlugin>;

class $NotificationsPluginProvider extends AutoDisposeProvider<FlutterLocalNotificationsPlugin> {
  $NotificationsPluginProvider() : super((ref) => ref.watch(notificationsPluginProvider));
  
  @override
  bool operator ==(Object other) {
    return other is $NotificationsPluginProvider;
  }
  
  @override
  int get hashCode => _$notificationsPluginHash().hashCode;
}

final notificationsPluginProvider = $NotificationsPluginProvider();

String _$messageLocalDataSourceHash() => r'messageLocalDataSource';
typedef MessageLocalDataSourceRef = AutoDisposeFutureProviderRef<MessageLocalDataSource>;

class $MessageLocalDataSourceProvider extends AutoDisposeFutureProvider<MessageLocalDataSource> {
  $MessageLocalDataSourceProvider() : super((ref) => ref.watch(messageLocalDataSourceProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $MessageLocalDataSourceProvider;
  }
  
  @override
  int get hashCode => _$messageLocalDataSourceHash().hashCode;
}

final messageLocalDataSourceProvider = $MessageLocalDataSourceProvider();

String _$messageRemoteDataSourceHash() => r'messageRemoteDataSource';
typedef MessageRemoteDataSourceRef = AutoDisposeProviderRef<MessageRemoteDataSource>;

class $MessageRemoteDataSourceProvider extends AutoDisposeProvider<MessageRemoteDataSource> {
  $MessageRemoteDataSourceProvider() : super((ref) => ref.watch(messageRemoteDataSourceProvider));
  
  @override
  bool operator ==(Object other) {
    return other is $MessageRemoteDataSourceProvider;
  }
  
  @override
  int get hashCode => _$messageRemoteDataSourceHash().hashCode;
}

final messageRemoteDataSourceProvider = $MessageRemoteDataSourceProvider();

String _$messageRepositoryHash() => r'messageRepository';
typedef MessageRepositoryRef = AutoDisposeFutureProviderRef<MessageRepository>;

class $MessageRepositoryProvider extends AutoDisposeFutureProvider<MessageRepository> {
  $MessageRepositoryProvider() : super((ref) => ref.watch(messageRepositoryProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $MessageRepositoryProvider;
  }
  
  @override
  int get hashCode => _$messageRepositoryHash().hashCode;
}

final messageRepositoryProvider = $MessageRepositoryProvider();

String _$settingsRepositoryHash() => r'settingsRepository';
typedef SettingsRepositoryRef = AutoDisposeFutureProviderRef<SettingsRepository>;

class $SettingsRepositoryProvider extends AutoDisposeFutureProvider<SettingsRepository> {
  $SettingsRepositoryProvider() : super((ref) => ref.watch(settingsRepositoryProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $SettingsRepositoryProvider;
  }
  
  @override
  int get hashCode => _$settingsRepositoryHash().hashCode;
}

final settingsRepositoryProvider = $SettingsRepositoryProvider();

String _$notificationSchedulerHash() => r'notificationScheduler';
typedef NotificationSchedulerRef = AutoDisposeFutureProviderRef<NotificationScheduler>;

class $NotificationSchedulerProvider extends AutoDisposeFutureProvider<NotificationScheduler> {
  $NotificationSchedulerProvider() : super((ref) => ref.watch(notificationSchedulerProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $NotificationSchedulerProvider;
  }
  
  @override
  int get hashCode => _$notificationSchedulerHash().hashCode;
}

final notificationSchedulerProvider = $NotificationSchedulerProvider();

String _$backgroundSyncServiceHash() => r'backgroundSyncService';
typedef BackgroundSyncServiceRef = AutoDisposeFutureProviderRef<BackgroundSyncService>;

class $BackgroundSyncServiceProvider extends AutoDisposeFutureProvider<BackgroundSyncService> {
  $BackgroundSyncServiceProvider() : super((ref) => ref.watch(backgroundSyncServiceProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $BackgroundSyncServiceProvider;
  }
  
  @override
  int get hashCode => _$backgroundSyncServiceHash().hashCode;
}

final backgroundSyncServiceProvider = $BackgroundSyncServiceProvider();

String _$messagesHash() => r'messages';
typedef MessagesRef = AutoDisposeFutureProviderRef<List<Message>>;

class $MessagesProvider extends AutoDisposeFutureProvider<List<Message>> {
  $MessagesProvider() : super((ref) => ref.watch(messagesProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $MessagesProvider;
  }
  
  @override
  int get hashCode => _$messagesHash().hashCode;
}

final messagesProvider = $MessagesProvider();

String _$messageHash() => r'message';
typedef MessageRef = AutoDisposeFutureProviderRef<Message?>;

class $MessageProvider extends AutoDisposeFutureProviderFamily<Message?, String> {
  $MessageProvider(String id) : super((ref) => ref.watch(messageProvider(id).future));
  
  @override
  bool operator ==(Object other) {
    return other is $MessageProvider;
  }
  
  @override
  int get hashCode => _$messageHash().hashCode;
}

final messageProvider = $MessageProvider;

abstract class _$ScheduleCategory extends BuildlessAutoDisposeAsyncNotifier<String> {
  @override
  FutureOr<String> build();
}

abstract class _$NotificationPermission extends BuildlessAutoDisposeAsyncNotifier<bool> {
  @override
  FutureOr<bool> build();
}

String _$scheduleCategoryHash() => r'scheduleCategory';
typedef ScheduleCategoryRef = AutoDisposeAsyncNotifierProviderRef<String>;

class ScheduleCategoryProvider extends AutoDisposeAsyncNotifierProvider<ScheduleCategory, String> {
  ScheduleCategoryProvider() : super(() => ScheduleCategory());
  
  @override
  bool operator ==(Object other) {
    return other is ScheduleCategoryProvider;
  }
  
  @override
  int get hashCode => _$scheduleCategoryHash().hashCode;
}

final scheduleCategoryProvider = ScheduleCategoryProvider();

String _$notificationPermissionHash() => r'notificationPermission';
typedef NotificationPermissionRef = AutoDisposeAsyncNotifierProviderRef<bool>;

class NotificationPermissionProvider extends AutoDisposeAsyncNotifierProvider<NotificationPermission, bool> {
  NotificationPermissionProvider() : super(() => NotificationPermission());
  
  @override
  bool operator ==(Object other) {
    return other is NotificationPermissionProvider;
  }
  
  @override
  int get hashCode => _$notificationPermissionHash().hashCode;
}

final notificationPermissionProvider = NotificationPermissionProvider();

String _$unviewedMessageCountHash() => r'unviewedMessageCount';
typedef UnviewedMessageCountRef = AutoDisposeFutureProviderRef<int>;

class $UnviewedMessageCountProvider extends AutoDisposeFutureProvider<int> {
  $UnviewedMessageCountProvider() : super((ref) => ref.watch(unviewedMessageCountProvider.future));
  
  @override
  bool operator ==(Object other) {
    return other is $UnviewedMessageCountProvider;
  }
  
  @override
  int get hashCode => _$unviewedMessageCountHash().hashCode;
}

final unviewedMessageCountProvider = $UnviewedMessageCountProvider();
