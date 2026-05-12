import 'dart:math';

import 'package:angel_messages/core/routing/app_router.dart';
import 'package:angel_messages/core/theme/app_theme.dart';
// TODO: After build_runner, switch to generated providers
// import 'package:angel_messages/shared/providers/providers.dart';
import 'package:angel_messages/shared/providers/providers_manual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

/// Message detail screen with immersive starfield background
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

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    // Mark message as viewed
    _markAsViewed();
  }

  Future<void> _markAsViewed() async {
    final repository = await ref.read(messageRepositoryProvider.future);
    await repository.markMessageAsViewed(widget.messageId);
    // Invalidate messages list to update UI
    ref.invalidate(messagesProvider);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageAsync = ref.watch(messageProvider(widget.messageId));

    return Scaffold(
      body: Stack(
        children: [
          // Starfield background
          const Positioned.fill(
            child: StarfieldBackground(),
          ),
          // Content
          messageAsync.when(
            data: (message) {
              if (message == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.softGold,
                      ),
                      const Gap(16),
                      Text(
                        'Message not found',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                );
              }

              return FadeTransition(
                opacity: _fadeAnimation,
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.mutedLavender.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.mutedLavender.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              message.category.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: AppTheme.mutedLavender,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                            ),
                          ),
                          const Gap(32),
                          // Title
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.softGold.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              message.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: AppTheme.softGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Gap(32),
                          // Body
                          Text(
                            message.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  height: 1.8,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(48),
                          // Decorative element
                          Icon(
                            Icons.auto_awesome,
                            size: 32,
                            color: AppTheme.softGold.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppTheme.softGold,
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          // Close button
          Positioned(
            top: 48,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: 'close_button',
              onPressed: () => AppRouter.navigateBack(context),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for animated starfield background
class StarfieldBackground extends StatefulWidget {
  const StarfieldBackground({super.key});

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate random stars
    for (var i = 0; i < 100; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 1,
          opacity: _random.nextDouble() * 0.5 + 0.3,
          twinkleSpeed: _random.nextDouble() * 2 + 1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarfieldPainter(
            stars: _stars,
            animationValue: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

/// Star data class
class Star {
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });

  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;
}

/// Painter for starfield
class StarfieldPainter extends CustomPainter {
  StarfieldPainter({
    required this.stars,
    required this.animationValue,
  });

  final List<Star> stars;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (final star in stars) {
      final x = star.x * size.width;
      final y = star.y * size.height;
      
      // Calculate twinkle effect
      final twinkle = (sin((animationValue * star.twinkleSpeed) * 2 * pi) + 1) / 2;
      paint.color = Colors.white.withOpacity(star.opacity * twinkle);

      canvas.drawCircle(
        Offset(x, y),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) => true;
}
