import 'dart:math';

import 'package:flutter/material.dart';

class StarfieldPainter extends CustomPainter {
  StarfieldPainter({
    required this.starCount,
    this.animationValue = 0.0,
  }) : _random = Random(42);

  final int starCount;
  final double animationValue;
  final Random _random;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var i = 0; i < starCount; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 2 + 0.5;
      
      // Animate opacity with a slight offset per star
      final opacity = (sin((animationValue + i * 0.1) * 2 * pi) + 1) / 2;
      paint.color = Colors.white.withOpacity(opacity * 0.8);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw some larger, brighter stars
    paint.color = Colors.white;
    for (var i = 0; i < starCount ~/ 10; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 3 + 1;
      
      // Cross-shaped star
      final centerX = x;
      final centerY = y;
      
      // Vertical line
      canvas.drawLine(
        Offset(centerX, centerY - radius * 2),
        Offset(centerX, centerY + radius * 2),
        paint..strokeWidth = 1,
      );
      
      // Horizontal line
      canvas.drawLine(
        Offset(centerX - radius * 2, centerY),
        Offset(centerX + radius * 2, centerY),
        paint,
      );
      
      // Center circle
      canvas.drawCircle(Offset(x, y), radius, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
