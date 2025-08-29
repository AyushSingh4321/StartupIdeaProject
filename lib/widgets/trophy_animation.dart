import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/app_theme.dart';

class TrophyAnimation extends StatelessWidget {
  final AnimationController controller;
  final bool isDarkMode;

  const TrophyAnimation({
    super.key,
    required this.controller,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (controller.value * 0.2),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.emoji_events,
              size: 64,
              color: Colors.white,
            ),
          ),
        );
      },
    ).animate().scale(duration: 800.ms)
     .shimmer(delay: 1000.ms, duration: 2000.ms);
  }
}