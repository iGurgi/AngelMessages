import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:angel_messages/core/theme/app_theme.dart';
import 'package:angel_messages/features/messages/presentation/widgets/starfield_background.dart';
import 'package:angel_messages/features/messages/providers/message_detail_provider.dart';

class MessageDetailScreen extends ConsumerStatefulWidget {
  final String messageId;

  const MessageDetailScreen({
    super.key,
    required this.messageId,
  });

  @override
  ConsumerState<MessageDetailScreen> createState() =>
      _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    // Mark message as viewed
    Future.microtask(() {
      ref
          .read(messageDetailProvider(widget.messageId).notifier)
          .markAsViewed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageAsync = ref.watch(messageDetailProvider(widget.messageId));

    return Scaffold(
      body: Stack(
        children: [
          // Animated starfield background
          const StarfieldBackground(),

          // Content
          messageAsync.when(
            data: (message) {
              if (message == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Message not found',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                );
              }

              return FadeTransition(
                opacity: _fadeAnimation,
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Glowing icon
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
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: 64,
                                    color: AppTheme.softGold,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Message title
                                Hero(
                                  tag: 'message_${message.id}',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      message.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: AppTheme.softGold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Message body
                                Text(
                                  message.body,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        height: 1.6,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),

                                // Category badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.mutedLavender.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppTheme.mutedLavender.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    message.category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: AppTheme.mutedLavender,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),

          // Close button
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingActionButton.small(
                  heroTag: 'close_button',
                  onPressed: () => context.pop(),
                  child: const Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
