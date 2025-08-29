import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../models/app_theme.dart';
import '../models/startup_idea.dart';
import '../services/storage_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/idea_card.dart';
import '../widgets/sort_filter_bar.dart';

class IdeaListingScreen extends StatefulWidget {
  final bool isDarkMode;

  const IdeaListingScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<IdeaListingScreen> createState() => _IdeaListingScreenState();
}

class _IdeaListingScreenState extends State<IdeaListingScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _refreshController;
  
  List<StartupIdea> _ideas = [];
  List<String> _votedIds = [];
  bool _isLoading = true;
  String _sortBy = 'rating'; // 'rating' or 'votes'
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _loadIdeas();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadIdeas() async {
    setState(() => _isLoading = true);
    
    final ideas = await StorageService.loadIdeas();
    final votedIds = await StorageService.getVotedIds();
    
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate loading
    
    setState(() {
      _ideas = ideas;
      _votedIds = votedIds;
      _isLoading = false;
    });
    
    _sortIdeas();
  }

  Future<void> _refreshIdeas() async {
    setState(() => _isRefreshing = true);
    _refreshController.forward();
    
    await _loadIdeas();
    
    setState(() => _isRefreshing = false);
    _refreshController.reset();
  }

  void _sortIdeas() {
    setState(() {
      if (_sortBy == 'rating') {
        _ideas.sort((a, b) => b.aiRating.compareTo(a.aiRating));
      } else {
        _ideas.sort((a, b) => b.votes.compareTo(a.votes));
      }
    });
  }

  Future<void> _voteForIdea(StartupIdea idea) async {
    if (_votedIds.contains(idea.id)) {
      Fluttertoast.showToast(
        msg: "You've already voted for this idea!",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    final updatedIdea = idea.copyWith(votes: idea.votes + 1);
    await StorageService.updateIdea(updatedIdea);
    await StorageService.markAsVoted(idea.id);

    setState(() {
      final index = _ideas.indexWhere((i) => i.id == idea.id);
      if (index != -1) {
        _ideas[index] = updatedIdea;
      }
      _votedIds.add(idea.id);
    });

    _sortIdeas();

    Fluttertoast.showToast(
      msg: "🗳️ Vote cast successfully!",
      backgroundColor: widget.isDarkMode 
          ? AppTheme.primaryDark 
          : AppTheme.primaryLight,
      textColor: Colors.white,
    );
  }

  void _shareIdea(StartupIdea idea) {
    Share.share(
      '🚀 Check out this startup idea: "${idea.name}"\n\n'
      '💡 ${idea.tagline}\n\n'
      '🤖 AI Rating: ${idea.aiRating}/100\n'
      '🗳️ Votes: ${idea.votes}\n\n'
      '${idea.description}\n\n'
      'Shared from Startup Idea Evaluator',
      subject: 'Startup Idea: ${idea.name}',
    );
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
            margin: const EdgeInsets.only(bottom: 20),
            height: 200,
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
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: widget.isDarkMode 
                  ? AppTheme.darkGradient 
                  : AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Colors.white,
            ),
          ).animate().scale(duration: 800.ms)
           .shimmer(delay: 1000.ms, duration: 2000.ms),
          
          const SizedBox(height: 32),
          
          Text(
            'No Ideas Yet!',
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
            'Be the first to submit a startup idea\nand get AI feedback!',
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
                          gradient: widget.isDarkMode 
                              ? AppTheme.darkGradient 
                              : AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (widget.isDarkMode 
                                  ? AppTheme.primaryDark 
                                  : AppTheme.primaryLight).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          color: Colors.white,
                          size: 28,
                        ),
                      ).animate().scale(delay: 100.ms, duration: 600.ms)
                       .rotate(delay: 700.ms, duration: 500.ms),
                      
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Startup Ideas',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode 
                                    ? AppTheme.textPrimaryDark 
                                    : AppTheme.textPrimaryLight,
                              ),
                            ),
                            Text(
                              '${_ideas.length} ideas submitted',
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
                      
                      // Refresh Button
                      GestureDetector(
                        onTap: _refreshIdeas,
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                          child: AnimatedBuilder(
                            animation: _refreshController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _refreshController.value * 2 * 3.14159,
                                child: Icon(
                                  Icons.refresh,
                                  color: widget.isDarkMode 
                                      ? AppTheme.textPrimaryDark 
                                      : AppTheme.textPrimaryLight,
                                ),
                              );
                            },
                          ),
                        ),
                      ).animate().scale(delay: 300.ms, duration: 600.ms),
                    ],
                  ),
                ),

                // Sort Filter Bar
                SortFilterBar(
                  sortBy: _sortBy,
                  onSortChanged: (newSort) {
                    setState(() => _sortBy = newSort);
                    _sortIdeas();
                  },
                  isDarkMode: widget.isDarkMode,
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms)
                 .slideY(begin: -0.3, delay: 400.ms, duration: 600.ms),

                // Ideas List
                Expanded(
                  child: _isLoading
                      ? _buildLoadingShimmer()
                      : _ideas.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _refreshIdeas,
                              backgroundColor: widget.isDarkMode 
                                  ? AppTheme.surfaceDark 
                                  : AppTheme.surfaceLight,
                              color: widget.isDarkMode 
                                  ? AppTheme.primaryDark 
                                  : AppTheme.primaryLight,
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(24),
                                  itemCount: _ideas.length,
                                  itemBuilder: (context, index) {
                                    final idea = _ideas[index];
                                    final hasVoted = _votedIds.contains(idea.id);
                                    
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 600),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: IdeaCard(
                                            idea: idea,
                                            hasVoted: hasVoted,
                                            isDarkMode: widget.isDarkMode,
                                            onVote: () => _voteForIdea(idea),
                                            onShare: () => _shareIdea(idea),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
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