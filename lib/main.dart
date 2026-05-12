import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';
import 'package:angel_messages/core/router/app_router.dart';
import 'package:angel_messages/core/theme/app_theme.dart';
import 'package:angel_messages/features/background/services/background_sync_service.dart';
import 'package:angel_messages/features/notifications/services/notification_scheduler.dart';
import 'package:angel_messages/features/permissions/services/permission_service.dart';
import 'package:angel_messages/features/settings/providers/schedule_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize background sync
  await BackgroundSyncService.initialize();
  await BackgroundSyncService.registerDailySync();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLinks _appLinks;
  NotificationScheduler? _notificationScheduler;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setupDeepLinking();
  }

  Future<void> _initializeApp() async {
    // Initialize notification scheduler
    _notificationScheduler = ref.read(notificationSchedulerProvider);
    await _notificationScheduler!.initialize();

    // Request notification permission
    if (mounted) {
      final granted = await PermissionService.requestNotificationPermission(context);

      if (granted) {
        // Schedule notifications based on saved preference
        final schedule = await ref.read(scheduleNotifierProvider.future);
        await _notificationScheduler!.scheduleNotifications(schedule);
      } else if (mounted) {
        // Show persistent snackbar if denied
        PermissionService.showPermissionDeniedSnackBar(context);
      }
    }

    // Set the scheduler in the notifier
    ref.read(scheduleNotifierProvider.notifier).setScheduler(_notificationScheduler!);
  }

  void _setupDeepLinking() {
    _appLinks = AppLinks();

    // Handle initial link if app was cold-started from a notification
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Handle links while app is running
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    // Handle angelmessages://message/:id
    if (uri.scheme == 'angelmessages' && uri.host == 'message') {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      if (id != null) {
        appRouter.push('/message/$id');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Angel Messages',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Dark mode first
      routerConfig: appRouter,
    );
  }
}
