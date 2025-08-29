import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_theme.dart';
import '../models/startup_idea.dart';

class LeaderboardCard extends StatelessWidget {
  final StartupIdea idea;
  final int rank;
  final bool isDarkMode;
  final bool showVotes;

  const LeaderboardCard({
    super.key,
    required this.idea,
    required this.rank,
    required this.isDarkMode,
    required this.showVotes,
  });

  Color _getRankColor() {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return isDarkMode 
            ? AppTheme.textSecondaryDark 
            : AppTheme.textSecondaryLight;
    }
  }

  IconData _getRankIcon() {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events_outlined;
      case 3:
        return Icons.emoji_events_outlined;
      default:
        return Icons.circle;
    }
  }

  String _getRankEmoji() {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }

  LinearGradient? _getCardGradient() {
    if (rank <= 3) {
      switch (rank) {
        case 1:
          return const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case 2:
          return const LinearGradient(
            colors: [Color(0xFFC0C0C0), Color(0xFF999999)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case 3:
          return const LinearGradient(
            colors: [Color(0xFFCD7F32), Color(0xFFB8860B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cardGradient = _getCardGradient();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: cardGradient ?? (isDarkMode 
            ? AppTheme.darkCardGradient 
            : AppTheme.cardGradient),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: rank <= 3
              ? _getRankColor().withOpacity(0.3)
              : (isDarkMode 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05)),
          width: rank <= 3 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: rank <= 3
                ? _getRankColor().withOpacity(0.3)
                : Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: rank <= 3 ? 20 : 12,
            offset:  Offset(0, rank <= 3 ? 8 : 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: rank <= 3
                    ? LinearGradient(
                        colors: [
                          _getRankColor(),
                          _getRankColor().withOpacity(0.8),
                        ],
                      )
                    : null,
                color: rank > 3
                    ? (isDarkMode 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1))
                    : null,
                shape: BoxShape.circle,
                boxShadow: rank <= 3
                    ? [
                        BoxShadow(
                          color: _getRankColor().withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: rank <= 3
                    ? Text(
                        _getRankEmoji(),
                        style: const TextStyle(fontSize: 24),
                      )
                    : Text(
                        '#$rank',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode 
                              ? AppTheme.textPrimaryDark 
                              : AppTheme.textPrimaryLight,
                        ),
                      ),
              ),
            ).animate().scale(delay: Duration(milliseconds: rank * 100), duration: 600.ms)
             .shimmer(delay: Duration(milliseconds: rank * 100 + 600), duration: 1500.ms),

            const SizedBox(width: 16),

            // Idea Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Startup Name
                  Text(
                    idea.name,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: rank <= 3
                          ? Colors.white
                          : (isDarkMode 
                              ? AppTheme.textPrimaryDark 
                              : AppTheme.textPrimaryLight),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Tagline
                  Text(
                    idea.tagline,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: rank <= 3
                          ? Colors.white.withOpacity(0.9)
                          : (isDarkMode 
                              ? AppTheme.textSecondaryDark 
                              : AppTheme.textSecondaryLight),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Stats Row
                  Row(
                    children: [
                      // AI Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: rank <= 3
                              ? Colors.white.withOpacity(0.2)
                              : (isDarkMode 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.psychology,
                              size: 14,
                              color: rank <= 3
                                  ? Colors.white
                                  : (isDarkMode 
                                      ? AppTheme.textSecondaryDark 
                                      : AppTheme.textSecondaryLight),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${idea.aiRating}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: rank <= 3
                                    ? Colors.white
                                    : (isDarkMode 
                                        ? AppTheme.textSecondaryDark 
                                        : AppTheme.textSecondaryLight),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Votes
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: rank <= 3
                              ? Colors.white.withOpacity(0.2)
                              : (isDarkMode 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.how_to_vote,
                              size: 14,
                              color: rank <= 3
                                  ? Colors.white
                                  : (isDarkMode 
                                      ? AppTheme.textSecondaryDark 
                                      : AppTheme.textSecondaryLight),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${idea.votes}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: rank <= 3
                                    ? Colors.white
                                    : (isDarkMode 
                                        ? AppTheme.textSecondaryDark 
                                        : AppTheme.textSecondaryLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Primary Metric (Votes or Rating)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: rank <= 3
                        ? Colors.white.withOpacity(0.2)
                        : (isDarkMode 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    showVotes ? Icons.how_to_vote : Icons.psychology,
                    color: rank <= 3
                        ? Colors.white
                        : (isDarkMode 
                            ? AppTheme.textPrimaryDark 
                            : AppTheme.textPrimaryLight),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  showVotes ? '${idea.votes}' : '${idea.aiRating}',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: rank <= 3
                        ? Colors.white
                        : (isDarkMode 
                            ? AppTheme.textPrimaryDark 
                            : AppTheme.textPrimaryLight),
                  ),
                ),
                Text(
                  showVotes ? 'votes' : '/100',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: rank <= 3
                        ? Colors.white.withOpacity(0.8)
                        : (isDarkMode 
                            ? AppTheme.textSecondaryDark 
                            : AppTheme.textSecondaryLight),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}