import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../permissions/permission_guard.dart';
import '../../features/messages/presentation/pages/messages_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

/// Navigation routes for type-safe routing
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String messages = '/messages';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String messageDetail = '/messages/:messageId';
}

/// Global router configuration provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check notification permissions for protected routes
      final protectedRoutes = [
        AppRoutes.messages,
        AppRoutes.notifications,
        AppRoutes.home,
      ];
      
      final currentPath = state.matchedLocation;
      final isProtectedRoute = protectedRoutes.any((route) => 
          currentPath.startsWith(route.replaceAll('/:messageId', '')));
      
      if (isProtectedRoute) {
        // Use PermissionGuard to check notification permission
        // This will be handled asynchronously in the actual implementation
        // For now, we'll let the guard handle permission checks in each page
        return null;
      }
      
      return null;
    },
    routes: [
      // Onboarding route
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Shell route for main app navigation
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: _buildBottomNavBar(context, state),
          );
        },
        routes: [
          // Home/Messages route
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const MessagesPage(),
          ),
          
          // Messages list route
          GoRoute(
            path: AppRoutes.messages,
            name: 'messages',
            builder: (context, state) => const MessagesPage(),
            routes: [
              // Message detail route
              GoRoute(
                path: ':messageId',
                name: 'messageDetail',
                builder: (context, state) {
                  final messageId = state.pathParameters['messageId']!;
                  return MessageDetailPage(messageId: messageId);
                },
              ),
            ],
          ),
          
          // Notifications route
          GoRoute(
            path: AppRoutes.notifications,
            name: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          
          // Settings route
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    
    // Error page for 404 and other routing errors
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.matchedLocation}" could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Bottom navigation bar for main app routes
Widget _buildBottomNavBar(BuildContext context, GoRouterState state) {
  final currentPath = state.matchedLocation;
  
  // Don't show bottom nav on onboarding
  if (currentPath == AppRoutes.onboarding) {
    return const SizedBox.shrink();
  }
  
  int getCurrentIndex() {
    if (currentPath == AppRoutes.home || currentPath.startsWith(AppRoutes.messages)) {
      return 0;
    } else if (currentPath == AppRoutes.notifications) {
      return 1;
    } else if (currentPath == AppRoutes.settings) {
      return 2;
    }
    return 0;
  }
  
  return NavigationBar(
    selectedIndex: getCurrentIndex(),
    onDestinationSelected: (index) {
      switch (index) {
        case 0:
          context.go(AppRoutes.home);
          break;
        case 1:
          context.go(AppRoutes.notifications);
          break;
        case 2:
          context.go(AppRoutes.settings);
          break;
      }
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.message_outlined),
        selectedIcon: Icon(Icons.message),
        label: 'Messages',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ],
  );
}

/// Message detail page widget
class MessageDetailPage extends StatelessWidget {
  final String messageId;
  
  const MessageDetailPage({
    super.key,
    required this.messageId,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Message ID: $messageId',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Message detail content will be implemented here',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.messages),
              child: const Text('Back to Messages'),
            ),
          ],
        ),
      ),
    );
  }
}
