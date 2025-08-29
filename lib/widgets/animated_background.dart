import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;
  final bool isDarkMode;

  const AnimatedBackground({
    super.key,
    required this.controller,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(
            animation: controller.value,
            isDarkMode: isDarkMode,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;

  BackgroundPainter({
    required this.animation,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Background gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDarkMode
          ? [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              const Color(0xFF0F172A),
            ]
          : [
              const Color(0xFFF8F9FA),
              const Color(0xFFE3F2FD),
              const Color(0xFFF3E5F5),
            ],
    );

    paint.shader = backgroundGradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Floating circles
    _drawFloatingCircles(canvas, size);
    
    // Animated waves
    _drawWaves(canvas, size);
  }

  void _drawFloatingCircles(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final circles = [
      {
        'x': size.width * 0.1,
        'y': size.height * 0.2,
        'radius': 60.0,
        'color': isDarkMode 
            ? const Color(0xFF6C63FF).withOpacity(0.1)
            : const Color(0xFF6C63FF).withOpacity(0.05),
        'speed': 1.0,
      },
      {
        'x': size.width * 0.8,
        'y': size.height * 0.3,
        'radius': 80.0,
        'color': isDarkMode 
            ? const Color(0xFFFF6B9D).withOpacity(0.08)
            : const Color(0xFFFF6B9D).withOpacity(0.04),
        'speed': 0.8,
      },
      {
        'x': size.width * 0.3,
        'y': size.height * 0.7,
        'radius': 100.0,
        'color': isDarkMode 
            ? const Color(0xFF4ECDC4).withOpacity(0.06)
            : const Color(0xFF4ECDC4).withOpacity(0.03),
        'speed': 1.2,
      },
      {
        'x': size.width * 0.7,
        'y': size.height * 0.8,
        'radius': 70.0,
        'color': isDarkMode 
            ? const Color(0xFFFFD93D).withOpacity(0.08)
            : const Color(0xFFFFD93D).withOpacity(0.04),
        'speed': 0.9,
      },
    ];

    for (final circle in circles) {
      final x = circle['x'] as double;
      final y = circle['y'] as double;
      final radius = circle['radius'] as double;
      final color = circle['color'] as Color;
      final speed = circle['speed'] as double;

      // Animate position
      final animatedX = x + math.sin(animation * 2 * math.pi * speed) * 30;
      final animatedY = y + math.cos(animation * 2 * math.pi * speed * 0.7) * 20;
      final animatedRadius = radius + math.sin(animation * 2 * math.pi * speed * 1.5) * 10;

      paint.color = color;
      canvas.drawCircle(
        Offset(animatedX, animatedY),
        animatedRadius,
        paint,
      );
    }
  }

  void _drawWaves(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final waveColors = isDarkMode
        ? [
            const Color(0xFF6C63FF).withOpacity(0.2),
            const Color(0xFFFF6B9D).withOpacity(0.15),
            const Color(0xFF4ECDC4).withOpacity(0.1),
          ]
        : [
            const Color(0xFF6C63FF).withOpacity(0.1),
            const Color(0xFFFF6B9D).withOpacity(0.08),
            const Color(0xFF4ECDC4).withOpacity(0.06),
          ];

    for (int i = 0; i < waveColors.length; i++) {
      paint.color = waveColors[i];
      
      final path = Path();
      final waveHeight = 40.0 + i * 10;
      final frequency = 0.02 + i * 0.005;
      final phase = animation * 2 * math.pi + i * math.pi / 3;
      
      path.moveTo(0, size.height * 0.5);
      
      for (double x = 0; x <= size.width; x += 5) {
        final y = size.height * 0.5 + 
                  math.sin(x * frequency + phase) * waveHeight;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}