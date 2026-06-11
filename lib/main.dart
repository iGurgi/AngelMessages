import 'package:angel_messages/models/message.dart';
import 'package:angel_messages/providers/schedule_notifier.dart';
import 'package:angel_messages/repositories/message_repository.dart';
import 'package:angel_messages/router/app_router.dart';
import 'package:angel_messages/services/background_sync.dart';
import 'package:angel_messages/services/notification_scheduler.dart';
import 'package:angel_messages/services/permission_service.dart';
import 'package:angel_messages/theme/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_links/uni_links.dart';

// Supabase configuration
const String supabaseUrl = 'https://your-project.supabase.co';
const String supabaseAnonKey = 'your-anon-key';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [MessageSchema],
    directory: dir.path,
  );

  // Initialize Dio
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Create repository
  final messageRepository = MessageRepository(
    isar: isar,
    dio: dio,
    supabaseUrl: supabaseUrl,
    supabaseAnonKey: supabaseAnonKey,
  );

  // Seed initial messages for demo
  await messageRepository.seedInitialMessages();

  // Create notification scheduler
  final notificationScheduler = NotificationScheduler(
    plugin: notificationsPlugin,
    messageRepository: messageRepository,
  );

  // Initialize background sync
  await BackgroundSyncService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        messageRepositoryProvider.overrideWithValue(messageRepository),
        notificationSchedulerProvider.overrideWithValue(notificationScheduler),
      ],
      child: const AngelMessagesApp(),
    ),
  );
}

class AngelMessagesApp extends ConsumerStatefulWidget {
  const AngelMessagesApp({super.key});

  @override
  ConsumerState<AngelMessagesApp> createState() => _AngelMessagesAppState();
}

class _AngelMessagesAppState extends ConsumerState<AngelMessagesApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Request permissions on first launch
    final permissionService = ref.read(permissionServiceProvider);
    final isFirstLaunch = await permissionService.isFirstLaunch();

    if (isFirstLaunch && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          final shouldRequest = await permissionService.showPermissionRationale(context);
          if (shouldRequest) {
            await permissionService.requestNotificationPermission();
            await permissionService.requestExactAlarmPermission();
          }
        }
      });
    }

    // Set up notification tap handling
    _setupNotificationHandling();

    // Set up deep link handling
    _setupDeepLinkHandling();
  }

  void _setupNotificationHandling() {
    // Handle notification tap when app is in foreground or background
    notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _router.push('/message/${response.payload}');
        }
      },
    );

    // Handle notification tap when app was terminated
    notificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((details) {
      if (details?.didNotificationLaunchApp ?? false) {
        final payload = details?.notificationResponse?.payload;
        if (payload != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _router.push('/message/$payload');
          });
        }
      }
    });
  }

  void _setupDeepLinkHandling() {
    // Handle deep links (angelmessages://message/:id)
    getInitialUri().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'angelmessages' && uri.host == 'message') {
      final messageId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      if (messageId != null) {
        _router.push('/message/$messageId');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Angel Messages',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
    );
  }
}
