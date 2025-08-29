import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_theme.dart';
import '../models/startup_idea.dart';

class IdeaCard extends StatefulWidget {
  final StartupIdea idea;
  final bool hasVoted;
  final bool isDarkMode;
  final VoidCallback onVote;
  final VoidCallback onShare;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.hasVoted,
    required this.isDarkMode,
    required this.onVote,
    required this.onShare,
  });

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Color _getRatingColor() {
    if (widget.idea.aiRating >= 80) return const Color(0xFF4CAF50);
    if (widget.idea.aiRating >= 60) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: widget.isDarkMode 
            ? AppTheme.darkCardGradient 
            : AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Startup Name
                    Expanded(
                      child: Text(
                        widget.idea.name,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.isDarkMode 
                              ? AppTheme.textPrimaryDark 
                              : AppTheme.textPrimaryLight,
                        ),
                      ),
                    ),
                    
                    // AI Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRatingColor(),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _getRatingColor().withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.psychology,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.idea.aiRating}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tagline
                Text(
                  widget.idea.tagline,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.isDarkMode 
                        ? AppTheme.textSecondaryDark 
                        : AppTheme.textSecondaryLight,
                  ),
                ),

                const SizedBox(height: 16),

                // Expandable Description
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: widget.isDarkMode 
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.black.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.isDarkMode 
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.05),
                                ),
                              ),
                              child: Text(
                                widget.idea.description,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: widget.isDarkMode 
                                      ? AppTheme.textPrimaryDark 
                                      : AppTheme.textPrimaryLight,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                // Action Row
                Row(
                  children: [
                    // Vote Button
                    GestureDetector(
                      onTap: widget.hasVoted ? null : widget.onVote,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: widget.hasVoted
                              ? null
                              : (widget.isDarkMode 
                                  ? AppTheme.darkGradient 
                                  : AppTheme.primaryGradient),
                          color: widget.hasVoted
                              ? (widget.isDarkMode 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1))
                              : null,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: widget.hasVoted
                              ? null
                              : [
                                  BoxShadow(
                                    color: (widget.isDarkMode 
                                        ? AppTheme.primaryDark 
                                        : AppTheme.primaryLight).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.hasVoted 
                                  ? Icons.how_to_vote 
                                  : Icons.how_to_vote_outlined,
                              color: widget.hasVoted
                                  ? (widget.isDarkMode 
                                      ? AppTheme.textSecondaryDark 
                                      : AppTheme.textSecondaryLight)
                                  : Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.idea.votes}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: widget.hasVoted
                                    ? (widget.isDarkMode 
                                        ? AppTheme.textSecondaryDark 
                                        : AppTheme.textSecondaryLight)
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().scale(duration: 200.ms),

                    const SizedBox(width: 12),

                    // Share Button
                    GestureDetector(
                      onTap: widget.onShare,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode 
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.isDarkMode 
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.1),
                          ),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          color: widget.isDarkMode 
                              ? AppTheme.textSecondaryDark 
                              : AppTheme.textSecondaryLight,
                          size: 16,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Expand/Collapse Button
                    GestureDetector(
                      onTap: _toggleExpanded,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode 
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: widget.isDarkMode 
                                ? AppTheme.textSecondaryDark 
                                : AppTheme.textSecondaryLight,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Created date
                    Text(
                      _formatDate(widget.idea.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: widget.isDarkMode 
                            ? AppTheme.textSecondaryDark 
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}