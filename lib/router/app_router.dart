import 'package:angel_messages/screens/home_screen.dart';
import 'package:angel_messages/screens/message_detail_screen.dart';
import 'package:angel_messages/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/message/:id',
        name: 'message-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MessageDetailScreen(messageId: id);
        },
      ),
    ],
  );
}
