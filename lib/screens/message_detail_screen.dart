import 'package:angel_messages/providers/messages_provider.dart';
import 'package:angel_messages/widgets/starfield_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MessageDetailScreen extends ConsumerStatefulWidget {
  const MessageDetailScreen({
    required this.messageId,
    super.key,
  });

  final String messageId;

  @override
  ConsumerState<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasMarkedAsViewed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _markAsViewed() {
    if (!_hasMarkedAsViewed) {
      _hasMarkedAsViewed = true;
      ref.read(messagesProvider.notifier).markAsViewed(widget.messageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageAsync = ref.watch(messageByIdProvider(widget.messageId));
    final theme = Theme.of(context);

    // Mark as viewed when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsViewed();
    });

    return Scaffold(
      body: messageAsync.when(
        data: (message) {
          if (message == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const Gap(16),
                  Text(
                    'Message not found',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Animated starfield background
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: StarfieldPainter(
                        starCount: 100,
                        animationValue: _animationController.value,
                      ),
                    );
                  },
                ),
              ),
              // Content
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Hero(
                    tag: 'message-${message.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Decorative top icon
                              Icon(
                                Icons.auto_awesome,
                                size: 48,
                                color: theme.colorScheme.secondary,
                              ),
                              const Gap(24),
                              // Title
                              Text(
                                message.title,
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(32),
                              // Body
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.colorScheme.secondary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.secondary.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  message.body,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                    height: 1.8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Gap(24),
                              // Category
                              Text(
                                message.category.toUpperCase(),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: () {
                    context.pop();
                  },
                  heroTag: null,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const Gap(16),
              Text(
                'Error loading message',
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
