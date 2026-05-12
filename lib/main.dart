import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:app_links/app_links.dart';
import 'package:angel_messages/router/app_router.dart';
import 'package:angel_messages/theme/app_theme.dart';
import 'package:angel_messages/providers/repository_providers.dart';
import 'package:angel_messages/providers/schedule_providers.dart';
import 'package:angel_messages/data/database.dart';
import 'package:angel_messages/data/message_repository.dart';
import 'package:angel_messages/services/supabase_service.dart';

/// Background task callback for daily sync
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'angelMessages.dailySync') {
      try {
        // Create service instances for background sync
        final supabaseService = SupabaseService(
          supabaseUrl: 'https://your-project.supabase.co',
          supabaseAnonKey: 'your-anon-key',
        );
        final database = AppDatabase();
        final repository = MessageRepository(
          database: database,
          supabaseService: supabaseService,
        );

        // Sync messages from remote
        await repository.syncFromRemote();

        // Clean up
        await database.close();

        return Future.value(true);
      } catch (e) {
        // Silent fail for background tasks
        return Future.value(false);
      }
    }
    return Future.value(false);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager for background sync
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Register daily sync task
  await Workmanager().registerPeriodicTask(
    'angelMessages.dailySync',
    'angelMessages.dailySync',
    frequency: const Duration(hours: 24),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(
    const ProviderScope(
      child: AngelMessagesApp(),
    ),
  );
}

class AngelMessagesApp extends ConsumerStatefulWidget {
  const AngelMessagesApp({super.key});

  @override
  ConsumerState<AngelMessagesApp> createState() => _AngelMessagesAppState();
}

class _AngelMessagesAppState extends ConsumerState<AngelMessagesApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize notifications
    await _initializeNotifications();

    // Initialize scheduled notifications based on saved preference
    await _initializeScheduledNotifications();

    // Initialize app links
    _appLinks = AppLinks();

    // Handle deep links
    _handleDeepLinks();

    // Handle initial link (cold start)
    _handleInitialLink();
  }

  Future<void> _initializeNotifications() async {
    final plugin = ref.read(notificationsPluginProvider);
    final scheduler = ref.read(notificationSchedulerProvider);

    await scheduler.initialize();

    // Handle notification taps
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    // Handle notification tap when app is terminated
    final launchDetails = await plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null) {
        _handleNotificationTap(payload);
      }
    }
  }

  Future<void> _initializeScheduledNotifications() async {
    final schedule = await ref.read(scheduleNotifierProvider.future);
    final scheduler = ref.read(notificationSchedulerProvider);
    await scheduler.scheduleNotifications(schedule);
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      // Navigate to message detail screen
      appRouter.push('/message/$payload');
    }
  }

  void _handleDeepLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _processDeepLink(uri);
    });
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _processDeepLink(uri);
      }
    } catch (e) {
      // Handle exception
    }
  }

  void _processDeepLink(Uri uri) {
    // Handle angelmessages://message/:id
    if (uri.scheme == 'angelmessages' && uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments[0] == 'message' && uri.pathSegments.length > 1) {
        final messageId = uri.pathSegments[1];
        appRouter.push('/message/$messageId');
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Angel Messages',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
