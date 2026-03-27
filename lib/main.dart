import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/messages/presentation/pages/home_page.dart';
import 'features/messages/presentation/pages/message_detail_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AngelMessagesApp(),
    ),
  );
}

class AngelMessagesApp extends StatelessWidget {
  const AngelMessagesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Angel Messages',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/message/:id',
      name: 'message_detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MessageDetailPage(messageId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
