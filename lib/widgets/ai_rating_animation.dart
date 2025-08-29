import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_theme.dart';

class AIRatingAnimation extends StatefulWidget {
  final int rating;
  final bool isDarkMode;

  const AIRatingAnimation({
    super.key,
    required this.rating,
    required this.isDarkMode,
  });

  @override
  State<AIRatingAnimation> createState() => _AIRatingAnimationState();
}

class _AIRatingAnimationState extends State<AIRatingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.rating / 100.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _getRatingColor() {
    if (widget.rating >= 80) return const Color(0xFF4CAF50);
    if (widget.rating >= 60) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String _getRatingText() {
    if (widget.rating >= 90) return 'Exceptional!';
    if (widget.rating >= 80) return 'Excellent!';
    if (widget.rating >= 70) return 'Great!';
    if (widget.rating >= 60) return 'Good!';
    return 'Needs Work';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: widget.isDarkMode 
            ? AppTheme.darkCardGradient 
            : AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getRatingColor().withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getRatingColor().withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // AI Icon with pulse animation
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getRatingColor(),
                        _getRatingColor().withOpacity(0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getRatingColor().withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // AI Rating Text
          Text(
            'AI Rating',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode 
                  ? AppTheme.textPrimaryDark 
                  : AppTheme.textPrimaryLight,
            ),
          ),

          const SizedBox(height: 16),

          // Circular Progress Indicator
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    backgroundColor: widget.isDarkMode 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isDarkMode 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                  ),
                ),
                
                // Animated progress circle
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: 8,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(_getRatingColor()),
                      ),
                    );
                  },
                ),
                
                // Rating number
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    final displayRating = (_progressAnimation.value * widget.rating).round();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$displayRating',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _getRatingColor(),
                          ),
                        ),
                        Text(
                          '/100',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: widget.isDarkMode 
                                ? AppTheme.textSecondaryDark 
                                : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Rating feedback text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getRatingColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getRatingColor().withOpacity(0.3),
              ),
            ),
            child: Text(
              _getRatingText(),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getRatingColor(),
              ),
            ),
          ).animate().fadeIn(delay: 1500.ms, duration: 600.ms)
           .scale(delay: 1500.ms, duration: 600.ms),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms)
     .scale(delay: 200.ms, duration: 600.ms);
  }
}