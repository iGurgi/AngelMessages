import 'dart:math';
import 'package:flutter/material.dart';

class StarfieldBackground extends StatefulWidget {
  const StarfieldBackground({
    required this.child,
    super.key,
  });

  final Widget child;

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
      duration: const Duration(seconds: 60),
    )..repeat();

    // Generate stars
    for (var i = 0; i < 100; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 1,
          speed: _random.nextDouble() * 0.5 + 0.1,
          opacity: _random.nextDouble() * 0.5 + 0.3,
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
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: StarfieldPainter(
                stars: _stars,
                animation: _controller.value,
              ),
              child: Container(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class Star {
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
}

class StarfieldPainter extends CustomPainter {
  StarfieldPainter({
    required this.stars,
    required this.animation,
  });

  final List<Star> stars;
  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final star in stars) {
      // Calculate animated position with vertical drift
      final animatedY = (star.y + (animation * star.speed)) % 1.0;
      final offset = Offset(
        star.x * size.width,
        animatedY * size.height,
      );

      // Twinkling effect
      final twinkle = sin(animation * 2 * pi * star.speed * 5);
      final currentOpacity = star.opacity + (twinkle * 0.2);

      paint.color = Colors.white.withOpacity(currentOpacity.clamp(0.0, 1.0));

      canvas.drawCircle(offset, star.size, paint);
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
