import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart'; // 👈 add this
import 'services/theme_service.dart';
import 'models/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _showSplash = true; // 1. Add this

  @override
  void initState() {
    super.initState();
    _loadThemePreference();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            _isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            _isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
        systemNavigationBarIconBrightness:
            _isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Startup Idea Evaluator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // 3. Show splash or home based on _showSplash
      home:
          _showSplash
              ? SplashScreen(
                isDarkMode: _isDarkMode,
                onThemeToggle: toggleTheme,
              )
              : HomeScreen(isDarkMode: _isDarkMode, onThemeToggle: toggleTheme),
    );
  }
}
