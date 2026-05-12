import 'package:angel_messages/core/routing/app_router.dart';
import 'package:angel_messages/core/theme/app_theme.dart';
import 'package:angel_messages/features/notifications/services/background_sync_service.dart';
// TODO: After build_runner, switch to generated providers
// import 'package:angel_messages/shared/providers/providers.dart';
import 'package:angel_messages/shared/providers/providers_manual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager for background sync
  await BackgroundSyncService.initialize();

  runApp(
    const ProviderScope(
      child: AngelMessagesApp(),
    ),
  );
}

/// Main application widget
class AngelMessagesApp extends ConsumerStatefulWidget {
  const AngelMessagesApp({super.key});

  @override
  ConsumerState<AngelMessagesApp> createState() => _AngelMessagesAppState();
}

class _AngelMessagesAppState extends ConsumerState<AngelMessagesApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize notification handling
    await _initializeNotifications();

    // Request permissions on first launch
    await _requestPermissionsOnFirstLaunch();

    // Register background sync
    await _registerBackgroundSync();

    // Schedule initial notifications
    await _scheduleNotifications();

    // Initialize deep link handling
    _initializeDeepLinks();
  }

  /// Initialize notification plugin and handlers
  Future<void> _initializeNotifications() async {
    final notificationsPlugin = ref.read(notificationsPluginProvider);

    // Set up notification tap handler
    notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    // Handle notification that launched the app
    final launchDetails =
        await notificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _handleNotificationTap(
        launchDetails?.notificationResponse?.payload,
      );
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      // Navigate to message detail
      AppRouter.router.push('/message/$payload');
    }
  }

  /// Request permissions on first launch
  Future<void> _requestPermissionsOnFirstLaunch() async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);

    if (settingsRepo.isFirstLaunch()) {
      // Show permission rationale dialog
      if (mounted) {
        await _showPermissionRationaleDialog();
      }

      // Request notification permission
      final status = await Permission.notification.request();
      await settingsRepo.setNotificationPermissionGranted(status.isGranted);

      // Mark first launch as complete
      await settingsRepo.setFirstLaunchComplete();
    }
  }

  /// Show permission rationale dialog
  Future<void> _showPermissionRationaleDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: AppTheme.softGold,
              ),
              const SizedBox(width: 8),
              const Text('Welcome to Angel Messages'),
            ],
          ),
          content: const Text(
            'To receive your daily inspirational messages, '
            'we need permission to send you notifications. '
            'You can change this anytime in Settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  /// Register background sync task
  Future<void> _registerBackgroundSync() async {
    final backgroundSync = await ref.read(backgroundSyncServiceProvider.future);
    await backgroundSync.registerDailySync();
  }

  /// Schedule initial notifications
  Future<void> _scheduleNotifications() async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    final scheduler = await ref.read(notificationSchedulerProvider.future);
    final category = settingsRepo.getScheduleCategory();
    await scheduler.scheduleNotifications(category);
  }

  /// Initialize deep link handling
  void _initializeDeepLinks() {
    // Handle initial link if app was opened via deep link
    getInitialLink().then((String? initialLink) {
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    });

    // Listen for deep links while app is running
    linkStream.listen((String? link) {
      if (link != null) {
        _handleDeepLink(link);
      }
    });
  }

  /// Handle deep link
  void _handleDeepLink(String link) {
    // Parse link format: angelmessages://message/:id
    final uri = Uri.parse(link);
    if (uri.scheme == 'angelmessages' && uri.host == 'message') {
      final messageId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      if (messageId != null) {
        AppRouter.router.push('/message/$messageId');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Angel Messages',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
