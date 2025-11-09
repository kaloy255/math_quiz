import 'package:flutter/material.dart';
import '../services/database_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadDarkModePreference();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6BBF59),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF9E6),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6BBF59),
        foregroundColor: Colors.white,
      ),
      cardColor: const Color(0xFFD4EDD0),
      fontFamily: 'Roboto',
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(
          0xFF4ECDC4,
        ), // Teal for dark mode (softer than green)
        brightness: Brightness.dark,
        background: const Color(
          0xFF0D1117,
        ), // Deep dark background (GitHub inspired)
        surface: const Color(0xFF161B22), // Card/surface color
        primary: const Color(0xFF4ECDC4), // Teal accent
        secondary: const Color(0xFF58A6FF), // Soft blue accent
        tertiary: const Color(0xFF7EE787), // Mint green accent
      ),
      scaffoldBackgroundColor: const Color(0xFF0D1117), // Deep dark background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF161B22), // Slightly lighter for headers
        foregroundColor: Color(0xFFE6EDF3),
      ),
      cardColor: const Color(0xFF161B22), // Dark card background
      dividerColor: const Color(0xFF30363D), // Subtle borders
      primaryColor: const Color(0xFF4ECDC4), // Teal primary
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xFFE6EDF3),
        ), // Light grayish-blue text
        bodyMedium: TextStyle(color: Color(0xFFE6EDF3)),
        bodySmall: TextStyle(
          color: Color(0xFF8B949E),
        ), // Medium gray for secondary text
      ),
      fontFamily: 'Roboto',
    );
  }

  Future<void> _loadDarkModePreference() async {
    final currentUser = DatabaseService.getCurrentUser();
    if (currentUser != null) {
      // Check if darkMode field exists in user preferences
      final preferencesBox = await DatabaseService.ensurePreferencesBoxOpen();
      final darkMode = preferencesBox.get(
        '${currentUser.id}_darkMode',
        defaultValue: false,
      );
      _isDarkMode = darkMode as bool;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    // Save preference to database
    final currentUser = DatabaseService.getCurrentUser();
    if (currentUser != null) {
      final preferencesBox = await DatabaseService.ensurePreferencesBoxOpen();
      await preferencesBox.put('${currentUser.id}_darkMode', _isDarkMode);
    }
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    // Save preference to database
    final currentUser = DatabaseService.getCurrentUser();
    if (currentUser != null) {
      final preferencesBox = await DatabaseService.ensurePreferencesBoxOpen();
      await preferencesBox.put('${currentUser.id}_darkMode', _isDarkMode);
    }
  }
}
