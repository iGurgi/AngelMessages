import 'package:flutter/material.dart';

/// A simple loading widget that displays a circular progress indicator
/// with loading text for the messages feature.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 16),
          Text(
            'Loading message...',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
