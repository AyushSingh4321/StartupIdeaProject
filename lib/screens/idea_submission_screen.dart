import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../models/app_theme.dart';
import '../models/startup_idea.dart';
import '../services/storage_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/ai_rating_animation.dart';

class IdeaSubmissionScreen extends StatefulWidget {
  final bool isDarkMode;

  const IdeaSubmissionScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<IdeaSubmissionScreen> createState() => _IdeaSubmissionScreenState();
}

class _IdeaSubmissionScreenState extends State<IdeaSubmissionScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();

  late AnimationController _backgroundController;
  late AnimationController _submitController;
  late AnimationController _formController;
  late ConfettiController _confettiController;

  bool _isSubmitting = false;
  bool _showAIRating = false;
  int _aiRating = 0;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _submitController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _formController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _submitController.dispose();
    _formController.dispose();
    _confettiController.dispose();
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitIdea() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    _submitController.forward();

    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Generate fake AI rating
    final random = Random();
    _aiRating = 60 + random.nextInt(40); // Rating between 60-100

    setState(() {
      _showAIRating = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    // Create and save the idea
    final idea = StartupIdea(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      tagline: _taglineController.text.trim(),
      description: _descriptionController.text.trim(),
      aiRating: _aiRating,
      createdAt: DateTime.now(),
    );

    await StorageService.addIdea(idea);

    // Show confetti
    _confettiController.play();

    // Show success toast
    Fluttertoast.showToast(
      msg: "🎉 Idea submitted successfully! AI Rating: $_aiRating/100",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: widget.isDarkMode 
          ? AppTheme.primaryDark 
          : AppTheme.primaryLight,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      Navigator.pop(context, true);
    }
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

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: widget.isDarkMode 
                                ? AppTheme.textPrimaryDark 
                                : AppTheme.textPrimaryLight,
                          ),
                        ),
                      ).animate().scale(delay: 100.ms, duration: 400.ms),
                      
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: Text(
                          'Submit Your Idea',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.isDarkMode 
                                ? AppTheme.textPrimaryDark 
                                : AppTheme.textPrimaryLight,
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 600.ms)
                         .slideX(begin: -0.3, delay: 200.ms, duration: 600.ms),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Startup Name Field
                          CustomTextField(
                            controller: _nameController,
                            label: 'Startup Name',
                            hint: 'Enter your startup name',
                            icon: Icons.business_outlined,
                            isDarkMode: widget.isDarkMode,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a startup name';
                              }
                              return null;
                            },
                          ).animate().fadeIn(delay: 300.ms, duration: 600.ms)
                           .slideY(begin: 0.3, delay: 300.ms, duration: 600.ms),

                          const SizedBox(height: 24),

                          // Tagline Field
                          CustomTextField(
                            controller: _taglineController,
                            label: 'Tagline',
                            hint: 'A catchy one-liner for your startup',
                            icon: Icons.campaign_outlined,
                            isDarkMode: widget.isDarkMode,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a tagline';
                              }
                              return null;
                            },
                          ).animate().fadeIn(delay: 400.ms, duration: 600.ms)
                           .slideY(begin: 0.3, delay: 400.ms, duration: 600.ms),

                          const SizedBox(height: 24),

                          // Description Field
                          CustomTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Describe your startup idea in detail',
                            icon: Icons.description_outlined,
                            isDarkMode: widget.isDarkMode,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a description';
                              }
                              if (value.trim().length < 50) {
                                return 'Description should be at least 50 characters';
                              }
                              return null;
                            },
                          ).animate().fadeIn(delay: 500.ms, duration: 600.ms)
                           .slideY(begin: 0.3, delay: 500.ms, duration: 600.ms),

                          const SizedBox(height: 40),

                          // AI Rating Display
                          if (_showAIRating)
                            AIRatingAnimation(
                              rating: _aiRating,
                              isDarkMode: widget.isDarkMode,
                            ).animate().fadeIn(duration: 800.ms)
                             .scale(delay: 200.ms, duration: 600.ms),

                          const SizedBox(height: 40),

                          // Submit Button
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: widget.isDarkMode 
                                  ? AppTheme.darkGradient 
                                  : AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (widget.isDarkMode 
                                      ? AppTheme.primaryDark 
                                      : AppTheme.primaryLight).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitIdea,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _isSubmitting
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          _showAIRating ? 'Saving...' : 'AI Analyzing...',
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.psychology_outlined,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Submit for AI Review',
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ).animate().fadeIn(delay: 600.ms, duration: 600.ms)
                           .slideY(begin: 0.3, delay: 600.ms, duration: 600.ms)
                           .shimmer(delay: 1200.ms, duration: 2000.ms),
                        ],
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