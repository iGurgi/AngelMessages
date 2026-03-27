import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the app's router configuration
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

/// Central router configuration for the Angel Messages app
class AppRouter {
  static const String home = '/';
  static const String settings = '/settings';
  static const String message = '/message';
  
  /// Creates a message route path with the given ID
  static String messageRoute(String id) => '/message/$id';
  
  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const _HomePage(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const _SettingsPage(),
      ),
      GoRoute(
        path: '/message/:id',
        name: 'message',
        builder: (context, state) {
          final messageId = state.pathParameters['id']!;
          return _MessageDetailPage(messageId: messageId);
        },
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(
      error: state.error.toString(),
    ),
  );
}

/// Temporary placeholder for home page
/// Will be replaced with actual implementation
class _HomePage extends StatelessWidget {
  const _HomePage();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angel Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(AppRouter.settings),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 64,
              color: Colors.pink,
            ),
            SizedBox(height: 16),
            Text(
              'Angel Messages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your daily messages from the angels',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Temporary placeholder for settings page
/// Will be replaced with actual implementation
class _SettingsPage extends StatelessWidget {
  const _SettingsPage();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Configure your preferences',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Temporary placeholder for message detail page
/// Will be replaced with actual implementation
class _MessageDetailPage extends StatelessWidget {
  const _MessageDetailPage({required this.messageId});
  
  final String messageId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.message,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Message ID: $messageId',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Message content will appear here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error page for navigation failures
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error});
  
  final String error;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigation Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
