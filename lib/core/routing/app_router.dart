import 'package:angel_messages/core/constants/app_constants.dart';
import 'package:angel_messages/features/messages/presentation/screens/home_screen.dart';
import 'package:angel_messages/features/messages/presentation/screens/message_detail_screen.dart';
import 'package:angel_messages/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Application router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.routeHome,
    routes: [
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeMessage,
        name: 'message',
        pageBuilder: (context, state) {
          final messageId = state.pathParameters['id'];
          if (messageId == null) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const HomeScreen(),
            );
          }
          return MaterialPage<void>(
            key: state.pageKey,
            child: MessageDetailScreen(messageId: messageId),
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeSettings,
        name: 'settings',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const HomeScreen(),
  );

  /// Navigate to message detail by ID
  static void navigateToMessage(BuildContext context, String messageId) {
    context.push('/message/$messageId');
  }

  /// Navigate to settings
  static void navigateToSettings(BuildContext context) {
    context.push(AppConstants.routeSettings);
  }

  /// Navigate back
  static void navigateBack(BuildContext context) {
    context.pop();
  }
}
