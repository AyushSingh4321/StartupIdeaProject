import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_theme.dart';

class FloatingActionMenu extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onSubmitIdea;
  final VoidCallback onViewIdeas;
  final VoidCallback onViewLeaderboard;

  const FloatingActionMenu({
    super.key,
    required this.isDarkMode,
    required this.onSubmitIdea,
    required this.onViewIdeas,
    required this.onViewLeaderboard,
  });

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.forward();
      _rotationController.forward();
    } else {
      _controller.reverse();
      _rotationController.reverse();
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required double delay,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _controller.value,
          child: Opacity(
            opacity: _controller.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode 
                          ? Colors.black.withOpacity(0.8)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.isDarkMode 
                            ? Colors.white 
                            : Colors.black87,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Button
                  GestureDetector(
                    onTap: () {
                      _toggleMenu();
                      onTap();
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideX(
              begin: 1.0,
              delay: Duration(milliseconds: (delay * 100).toInt()),
              duration: 200.ms,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Menu Items
        if (_isExpanded) ...[
          _buildMenuItem(
            icon: Icons.leaderboard,
            label: 'Leaderboard',
            onTap: widget.onViewLeaderboard,
            color: const Color.fromARGB(255, 8, 22, 40),
            delay: 0,
          ),
          _buildMenuItem(
            icon: Icons.lightbulb_outline,
            label: 'View Ideas',
            onTap: widget.onViewIdeas,
            // color: widget.isDarkMode 
            //     ? AppTheme.accentDark 
            //     : AppTheme.accentLight,
             color: const Color.fromARGB(255, 8, 22, 40),
            delay: 1,
          ),
          _buildMenuItem(
            icon: Icons.add,
            label: 'Submit Idea',
            onTap: widget.onSubmitIdea,
            // color: widget.isDarkMode 
            //     ? AppTheme.primaryDark 
            //     : AppTheme.primaryLight,
            color: const Color.fromARGB(255, 8, 22, 40),
            delay: 2,
          ),
        ],

        // Main FAB
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            // gradient: widget.isDarkMode 
            //     ? AppTheme.darkGradient 
            //     : AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (widget.isDarkMode 
                    ? const Color.fromARGB(255, 48, 48, 84)
                    : const Color.fromARGB(255, 94, 110, 155)), 
                    // .withOpacity(0.4),
                blurRadius: 0.02,
                // offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleMenu,
              borderRadius: BorderRadius.circular(32),
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 0.75,
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.menu,
                      color: Colors.white,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ),
        ).animate().scale(duration: 600.ms)
         .shimmer(delay: 1000.ms, duration: 2000.ms),
      ],
    );
  }
}