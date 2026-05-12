import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:angel_messages/screens/home_screen.dart';
import 'package:angel_messages/screens/message_detail_screen.dart';
import 'package:angel_messages/screens/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/message/:id',
      name: 'message-detail',
      builder: (context, state) {
        final messageId = state.pathParameters['id']!;
        return MessageDetailScreen(messageId: messageId);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);

class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';

  static String messageDetail(String id) => '/message/$id';
}
