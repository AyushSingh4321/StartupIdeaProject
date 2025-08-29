import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isDarkMode;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDarkMode,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode 
                  ? AppTheme.textPrimaryDark 
                  : AppTheme.textPrimaryLight,
            ),
          ),
        ),

        // Text Field Container
        AnimatedBuilder(
          animation: _focusController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: _isFocused
                    ? (widget.isDarkMode 
                        ? AppTheme.darkCardGradient 
                        : AppTheme.cardGradient)
                    : null,
                color: !_isFocused
                    ? (widget.isDarkMode 
                        ? AppTheme.surfaceDark 
                        : AppTheme.surfaceLight)
                    : null,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused
                      ? (widget.isDarkMode 
                          ? AppTheme.primaryDark 
                          : AppTheme.primaryLight)
                      : (widget.isDarkMode 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1)),
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: (widget.isDarkMode 
                              ? AppTheme.primaryDark 
                              : AppTheme.primaryLight).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                maxLines: widget.maxLines,
                validator: widget.validator,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: widget.isDarkMode 
                      ? AppTheme.textPrimaryDark 
                      : AppTheme.textPrimaryLight,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: widget.isDarkMode 
                        ? AppTheme.textSecondaryDark 
                        : AppTheme.textSecondaryLight,
                  ),
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: widget.isDarkMode 
                          ? AppTheme.darkGradient 
                          : AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: widget.maxLines > 1 ? 20 : 16,
                  ),
                  errorStyle: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 600.ms)
     .slideY(begin: 0.3, duration: 600.ms);
  }
}