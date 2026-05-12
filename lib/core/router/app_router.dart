import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:angel_messages/features/home/presentation/home_screen.dart';
import 'package:angel_messages/features/messages/presentation/message_detail_screen.dart';
import 'package:angel_messages/features/settings/presentation/settings_screen.dart';

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
      name: 'message',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MessageDetailScreen(messageId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
