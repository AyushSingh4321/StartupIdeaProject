import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_theme.dart';

class SortFilterBar extends StatelessWidget {
  final String sortBy;
  final Function(String) onSortChanged;
  final bool isDarkMode;

  const SortFilterBar({
    super.key,
    required this.sortBy,
    required this.onSortChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Sort by Rating
          Expanded(
            child: GestureDetector(
              onTap: () => onSortChanged('rating'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: sortBy == 'rating'
                      ? (isDarkMode 
                          ? AppTheme.darkGradient 
                          : AppTheme.primaryGradient)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.psychology,
                      color: sortBy == 'rating'
                          ? Colors.white
                          : (isDarkMode 
                              ? AppTheme.textSecondaryDark 
                              : AppTheme.textSecondaryLight),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Rating',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: sortBy == 'rating'
                            ? Colors.white
                            : (isDarkMode 
                                ? AppTheme.textSecondaryDark 
                                : AppTheme.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Sort by Votes
          Expanded(
            child: GestureDetector(
              onTap: () => onSortChanged('votes'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: sortBy == 'votes'
                      ? (isDarkMode 
                          ? AppTheme.darkGradient 
                          : AppTheme.primaryGradient)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.how_to_vote,
                      color: sortBy == 'votes'
                          ? Colors.white
                          : (isDarkMode 
                              ? AppTheme.textSecondaryDark 
                              : AppTheme.textSecondaryLight),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Votes',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: sortBy == 'votes'
                            ? Colors.white
                            : (isDarkMode 
                                ? AppTheme.textSecondaryDark 
                                : AppTheme.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}