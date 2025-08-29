import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../models/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/floating_action_menu.dart';
import 'idea_submission_screen.dart';
import 'idea_listing_screen.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  late AnimationController _textController;
  int _selectedIndex = 0;

  // final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // _screens.addAll([
    //   _buildWelcomeScreen(),
    //   IdeaListingScreen(isDarkMode: widget.isDarkMode),
    //   LeaderboardScreen(isDarkMode: widget.isDarkMode),
    // ]);

    // Start animations
    _cardController.forward();
    _textController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Widget _buildWelcomeScreen() {
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with theme toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.all(12),
                        //   decoration: BoxDecoration(
                        //     color: widget.isDarkMode
                        //         ? Colors.white.withOpacity(0.1)
                        //         : Colors.black.withOpacity(0.05),
                        //     borderRadius: BorderRadius.circular(16),
                        //     border: Border.all(
                        //       color: widget.isDarkMode
                        //           ? Colors.white.withOpacity(0.2)
                        //           : Colors.black.withOpacity(0.1),
                        //     ),
                        //   ),
                        //   child: Icon(
                        //     Icons.lightbulb_outline,
                        //     color: widget.isDarkMode
                        //         ? AppTheme.primaryDark
                        //         : AppTheme.primaryLight,
                        //     size: 28,
                        //   ),
                        // ).animate().scale(delay: 300.ms, duration: 600.ms)
                        //  .shimmer(delay: 900.ms, duration: 1000.ms),
                        GestureDetector(
                              onTap: widget.onThemeToggle,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient:
                                      widget.isDarkMode
                                          ? AppTheme.darkGradient
                                          : AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (widget.isDarkMode
                                              ? AppTheme.primaryDark
                                              : AppTheme.primaryLight)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  widget.isDarkMode
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            )
                            .animate()
                            .scale(delay: 400.ms, duration: 600.ms)
                            .rotate(delay: 1000.ms, duration: 500.ms),
                      ],
                    ),
                
                    const SizedBox(height: 60),
                
                    // Animated Title
                    AnimatedTextKit(
                        key: ValueKey(widget.isDarkMode),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'The Startup Idea\nEvaluator',
                          textStyle: GoogleFonts.inter(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color:
                                widget.isDarkMode
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.textPrimaryLight,
                            height: 1.2,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      totalRepeatCount: 1,
                    ),
                
                    const SizedBox(height: 16),
                
                    // Subtitle with gradient
                    ShaderMask(
                          shaderCallback:
                              (bounds) => (widget.isDarkMode
                                      ? AppTheme.darkGradient
                                      : AppTheme.primaryGradient)
                                  .createShader(bounds),
                          child: Text(
                            'AI + Voting App',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 2000.ms, duration: 800.ms)
                        .slideX(begin: -0.3, delay: 2000.ms, duration: 800.ms),
                
                    const SizedBox(height: 40),
                
                    // Feature Cards
                    AnimationLimiter(
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder:
                              (widget) => SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(child: widget),
                              ),
                          children: [
                            _buildFeatureCard(
                              icon: Icons.add_circle_outline,
                              title: 'Submit Ideas',
                              description:
                                  'Share your innovative startup concepts',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              delay: 2500,
                            ),
                            const SizedBox(height: 20),
                            _buildFeatureCard(
                              icon: Icons.psychology_outlined,
                              title: 'AI Evaluation',
                              description: 'Get instant AI-powered feedback',
                              gradient: const LinearGradient(
                                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                              ),
                              delay: 2700,
                            ),
                            const SizedBox(height: 20),
                            _buildFeatureCard(
                              icon: Icons.how_to_vote_outlined,
                              title: 'Community Voting',
                              description:
                                  'Vote on ideas from other entrepreneurs',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              ),
                              delay: 2900,
                            ),
                            const SizedBox(height: 20),
                            _buildFeatureCard(
                              icon: Icons.leaderboard_outlined,
                              title: 'Leaderboard',
                              description: 'See top-rated startup ideas',
                              gradient: const LinearGradient(
                                colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                              ),
                              delay: 3100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionMenu(
        isDarkMode: widget.isDarkMode,
        onSubmitIdea: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      IdeaSubmissionScreen(isDarkMode: widget.isDarkMode),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCirc)),
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
        onViewIdeas: () => setState(() => _selectedIndex = 1),
        onViewLeaderboard: () => setState(() => _selectedIndex = 2),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required LinearGradient gradient,
    required int delay,
  }) {
    return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
           gradient: widget.isDarkMode
          ? AppTheme.darkGradient
          : AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
        .slideX(
          begin: 0.3,
          delay: Duration(milliseconds: delay),
          duration: 600.ms,
        )
        .shimmer(
          delay: Duration(milliseconds: delay + 1000),
          duration: 1500.ms,
        );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildWelcomeScreen(),
      IdeaListingScreen(isDarkMode: widget.isDarkMode),
      LeaderboardScreen(isDarkMode: widget.isDarkMode),
    ];

    if (_selectedIndex == 0) {
      return screens[0];
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex - 1,
        children: screens.sublist(1),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient:
              widget.isDarkMode
                  ? AppTheme.darkCardGradient
                  : AppTheme.cardGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor:
              widget.isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
          unselectedItemColor:
              widget.isDarkMode
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              activeIcon: Icon(Icons.lightbulb),
              label: 'Ideas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_outlined),
              activeIcon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
          ],
        ),
      ),
    );
  }
}