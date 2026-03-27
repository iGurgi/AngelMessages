import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen that displays detailed view of a specific angel message
/// 
/// Accessed via navigation with messageId parameter from go_router
class MessageDetailScreen extends StatelessWidget {
  /// Creates a message detail screen
  /// 
  /// The [messageId] is extracted from GoRouterState.pathParameters
  const MessageDetailScreen({
    super.key,
    required this.messageId,
  });

  /// ID of the message to display
  final String messageId;

  /// Factory constructor to create screen from GoRouterState parameters
  /// 
  /// Extracts messageId from route path parameters
  static MessageDetailScreen fromState(GoRouterState state) {
    final messageId = state.pathParameters['messageId'];
    if (messageId == null) {
      throw ArgumentError('messageId parameter is required');
    }
    return MessageDetailScreen(messageId: messageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
        // AppBar automatically includes back button when canPop is true
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message ID: $messageId',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Placeholder for future message content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Angel message content will be displayed here',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
