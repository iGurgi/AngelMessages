import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angel_messages/providers/message_providers.dart';
import 'package:angel_messages/widgets/starfield_background.dart';
import 'package:angel_messages/theme/app_theme.dart';

class MessageDetailScreen extends ConsumerStatefulWidget {
  const MessageDetailScreen({
    required this.messageId,
    super.key,
  });

  final String messageId;

  @override
  ConsumerState<MessageDetailScreen> createState() =>
      _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Trigger fade-in animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });

    // Mark message as viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messageDetailProvider(widget.messageId).notifier)
          .markAsViewed(widget.messageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageAsync = ref.watch(messageDetailProvider(widget.messageId));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.deepPurple,
      body: StarfieldBackground(
        child: messageAsync.when(
          data: (message) {
            if (message == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Message not found',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              child: Stack(
                children: [
                  // Main content
                  Center(
                    child: AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Decorative element
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppTheme.softGold.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 48,
                                color: AppTheme.softGold,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Message title
                            Text(
                              message.title,
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Divider
                            Container(
                              height: 2,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.softGold,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Message body
                            Flexible(
                              child: SingleChildScrollView(
                                child: Text(
                                  message.body,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 18,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      heroTag: 'close',
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: AppTheme.softGold,
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.softGold),
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.white70,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load message',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
