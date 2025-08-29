import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../models/app_theme.dart';
import '../models/startup_idea.dart';
import '../services/storage_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/trophy_animation.dart';

class LeaderboardScreen extends StatefulWidget {
  final bool isDarkMode;

  const LeaderboardScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _trophyController;
  
  List<StartupIdea> _topIdeas = [];
  bool _isLoading = true;
  String _leaderboardType = 'votes'; // 'votes' or 'rating'

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _loadLeaderboard();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _trophyController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);
    
    final ideas = await StorageService.loadIdeas();
    
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate loading
    
    setState(() {
      if (_leaderboardType == 'votes') {
        _topIdeas = ideas..sort((a, b) => b.votes.compareTo(a.votes));
      } else {
        _topIdeas = ideas..sort((a, b) => b.aiRating.compareTo(a.aiRating));
      }
      
      // Take only top 10
      if (_topIdeas.length > 10) {
        _topIdeas = _topIdeas.take(10).toList();
      }
      
      _isLoading = false;
    });

    if (_topIdeas.isNotEmpty) {
      _trophyController.forward();
    }
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: widget.isDarkMode 
              ? Colors.grey[800]! 
              : Colors.grey[300]!,
          highlightColor: widget.isDarkMode 
              ? Colors.grey[700]! 
              : Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TrophyAnimation(
            controller: _trophyController,
            isDarkMode: widget.isDarkMode,
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'No Rankings Yet!',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode 
                  ? AppTheme.textPrimaryDark 
                  : AppTheme.textPrimaryLight,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          
          const SizedBox(height: 16),
          
          Text(
            'Submit ideas and vote to see\nthe leaderboard in action!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: widget.isDarkMode 
                  ? AppTheme.textSecondaryDark 
                  : AppTheme.textSecondaryLight,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.isDarkMode 
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDarkMode 
              ? Colors.white.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _leaderboardType = 'votes');
                _loadLeaderboard();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _leaderboardType == 'votes'
                      ? (widget.isDarkMode 
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
                      color: _leaderboardType == 'votes'
                          ? Colors.white
                          : (widget.isDarkMode 
                              ? AppTheme.textSecondaryDark 
                              : AppTheme.textSecondaryLight),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'By Votes',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _leaderboardType == 'votes'
                            ? Colors.white
                            : (widget.isDarkMode 
                                ? AppTheme.textSecondaryDark 
                                : AppTheme.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _leaderboardType = 'rating');
                _loadLeaderboard();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _leaderboardType == 'rating'
                      ? (widget.isDarkMode 
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
                      color: _leaderboardType == 'rating'
                          ? Colors.white
                          : (widget.isDarkMode 
                              ? AppTheme.textSecondaryDark 
                              : AppTheme.textSecondaryLight),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'By AI Rating',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _leaderboardType == 'rating'
                            ? Colors.white
                            : (widget.isDarkMode 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(
            controller: _backgroundController,
            isDarkMode: widget.isDarkMode,
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 28,
                        ),
                      ).animate().scale(delay: 100.ms, duration: 600.ms)
                       .shimmer(delay: 700.ms, duration: 2000.ms),
                      
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Leaderboard',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode 
                                    ? AppTheme.textPrimaryDark 
                                    : AppTheme.textPrimaryLight,
                              ),
                            ),
                            Text(
                              'Top performing ideas',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: widget.isDarkMode 
                                    ? AppTheme.textSecondaryDark 
                                    : AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms)
                       .slideX(begin: -0.3, delay: 200.ms, duration: 600.ms),
                    ],
                  ),
                ),

                // Toggle Buttons
                _buildToggleButtons().animate().fadeIn(delay: 300.ms, duration: 600.ms)
                 .slideY(begin: -0.3, delay: 300.ms, duration: 600.ms),

                // Leaderboard List
                Expanded(
                  child: _isLoading
                      ? _buildLoadingShimmer()
                      : _topIdeas.isEmpty
                          ? _buildEmptyState()
                          : AnimationLimiter(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(24),
                                itemCount: _topIdeas.length,
                                itemBuilder: (context, index) {
                                  final idea = _topIdeas[index];
                                  final rank = index + 1;
                                  
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 600),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: LeaderboardCard(
                                          idea: idea,
                                          rank: rank,
                                          isDarkMode: widget.isDarkMode,
                                          showVotes: _leaderboardType == 'votes',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}