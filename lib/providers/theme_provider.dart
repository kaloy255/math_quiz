import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/dark_theme_colors.dart';

/// 🎨 Theme Provider for MathQuest
/// 
/// Manages dark/light mode state and provides theme data.
/// Uses the new "Midnight Forest" dark theme with Mathie-inspired green accents.
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadDarkModePreference();
  }

  bool get isDarkMode => _isDarkMode;

  /// Light Theme (Original MathQuest Design)
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
        elevation: 0,
      ),
      cardColor: const Color(0xFFD4EDD0),
      fontFamily: 'Roboto',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6BBF59),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF6BBF59),
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Dark Theme ("Midnight Forest" - Mathie Edition)
  /// 
  /// Features:
  /// - Warm dark backgrounds to reduce eye strain
  /// - Mathie-inspired green accents (#7EE787, #58D68D)
  /// - WCAG AA/AAA compliant contrast ratios
  /// - Subtle elevation and glow effects
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme (Midnight Forest)
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        
        // Primary: Mathie's mint green
        primary: DarkThemeColors.primaryGreen,
        onPrimary: DarkThemeColors.textInverted,
        primaryContainer: DarkThemeColors.buttonGreen,
        onPrimaryContainer: DarkThemeColors.textInverted,
        
        // Secondary: Medium green
        secondary: DarkThemeColors.secondaryGreen,
        onSecondary: DarkThemeColors.textInverted,
        secondaryContainer: DarkThemeColors.tertiaryGreen,
        onSecondaryContainer: DarkThemeColors.textPrimary,
        
        // Tertiary: Achievement green
        tertiary: DarkThemeColors.achievementGreen,
        onTertiary: DarkThemeColors.textInverted,
        
        // Background
        background: DarkThemeColors.scaffoldBg,
        onBackground: DarkThemeColors.textPrimary,
        
        // Surface (cards, sheets)
        surface: DarkThemeColors.cardBg,
        onSurface: DarkThemeColors.textPrimary,
        surfaceVariant: DarkThemeColors.elevatedBg,
        onSurfaceVariant: DarkThemeColors.textSecondary,
        
        // Status colors
        error: DarkThemeColors.error,
        onError: Colors.white,
        errorContainer: DarkThemeColors.errorBg,
        onErrorContainer: DarkThemeColors.error,
        
        // Outline & Shadow
        outline: DarkThemeColors.border,
        outlineVariant: DarkThemeColors.divider,
        shadow: DarkThemeColors.shadow,
        scrim: DarkThemeColors.overlay,
        
        // Surface tints
        surfaceTint: DarkThemeColors.primaryGreen,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: DarkThemeColors.scaffoldBg,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: DarkThemeColors.appBarBg,
        foregroundColor: DarkThemeColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 4,
        shadowColor: DarkThemeColors.shadow,
        surfaceTintColor: DarkThemeColors.primaryGreen,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: DarkThemeColors.cardBg,
        elevation: 4,
        shadowColor: DarkThemeColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: DarkThemeColors.border,
            width: 1,
          ),
        ),
      ),
      cardColor: DarkThemeColors.cardBg,
      
      // Divider
      dividerColor: DarkThemeColors.divider,
      dividerTheme: DividerThemeData(
        color: DarkThemeColors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(color: DarkThemeColors.textPrimary),
        displayMedium: TextStyle(color: DarkThemeColors.textPrimary),
        displaySmall: TextStyle(color: DarkThemeColors.textPrimary),
        headlineLarge: TextStyle(color: DarkThemeColors.textPrimary),
        headlineMedium: TextStyle(color: DarkThemeColors.textPrimary),
        headlineSmall: TextStyle(color: DarkThemeColors.textPrimary),
        titleLarge: TextStyle(color: DarkThemeColors.textPrimary),
        titleMedium: TextStyle(color: DarkThemeColors.textPrimary),
        titleSmall: TextStyle(color: DarkThemeColors.textSecondary),
        bodyLarge: TextStyle(color: DarkThemeColors.textPrimary),
        bodyMedium: TextStyle(color: DarkThemeColors.textPrimary),
        bodySmall: TextStyle(color: DarkThemeColors.textSecondary),
        labelLarge: TextStyle(color: DarkThemeColors.textPrimary),
        labelMedium: TextStyle(color: DarkThemeColors.textSecondary),
        labelSmall: TextStyle(color: DarkThemeColors.textTertiary),
      ),
      primaryTextTheme: TextTheme(
        bodyLarge: TextStyle(color: DarkThemeColors.textPrimary),
        bodyMedium: TextStyle(color: DarkThemeColors.textPrimary),
        bodySmall: TextStyle(color: DarkThemeColors.textSecondary),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkThemeColors.primaryGreen,
          foregroundColor: DarkThemeColors.textInverted,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DarkThemeColors.primaryGreen,
          side: BorderSide(color: DarkThemeColors.primaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DarkThemeColors.primaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkThemeColors.cardBg,
        hintStyle: TextStyle(color: DarkThemeColors.textTertiary),
        labelStyle: TextStyle(color: DarkThemeColors.textSecondary),
        
        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: DarkThemeColors.border),
        ),
        
        // Enabled border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: DarkThemeColors.border),
        ),
        
        // Focused border (green glow)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DarkThemeColors.primaryGreen,
            width: 2,
          ),
        ),
        
        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DarkThemeColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DarkThemeColors.error,
            width: 2,
          ),
        ),
        
        errorStyle: TextStyle(color: DarkThemeColors.error),
        prefixIconColor: DarkThemeColors.textSecondary,
        suffixIconColor: DarkThemeColors.textSecondary,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: DarkThemeColors.textSecondary,
        size: 24,
      ),
      primaryIconTheme: IconThemeData(
        color: DarkThemeColors.primaryGreen,
        size: 24,
      ),
      
      // Misc
      primaryColor: DarkThemeColors.primaryGreen,
      disabledColor: DarkThemeColors.disabled,
      hintColor: DarkThemeColors.textTertiary,
      fontFamily: 'Roboto',
      
      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: DarkThemeColors.primaryGreen,
        linearTrackColor: DarkThemeColors.border,
        circularTrackColor: DarkThemeColors.border,
      ),
      
      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return DarkThemeColors.primaryGreen;
          }
          return DarkThemeColors.textTertiary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return DarkThemeColors.primaryGreen.withOpacity(0.5);
          }
          return DarkThemeColors.border;
        }),
      ),
      
      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return DarkThemeColors.primaryGreen;
          }
          return DarkThemeColors.border;
        }),
        checkColor: MaterialStateProperty.all(DarkThemeColors.textInverted),
      ),
      
      // Radio
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return DarkThemeColors.primaryGreen;
          }
          return DarkThemeColors.border;
        }),
      ),
      
      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: DarkThemeColors.primaryGreen,
        inactiveTrackColor: DarkThemeColors.border,
        thumbColor: DarkThemeColors.primaryGreen,
        overlayColor: DarkThemeColors.primaryGreen.withOpacity(0.2),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: DarkThemeColors.elevatedBg,
        elevation: 24,
        shadowColor: DarkThemeColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: DarkThemeColors.border),
        ),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: DarkThemeColors.elevatedBg,
        elevation: 16,
        shadowColor: DarkThemeColors.shadow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DarkThemeColors.elevatedBg,
        contentTextStyle: TextStyle(color: DarkThemeColors.textPrimary),
        actionTextColor: DarkThemeColors.primaryGreen,
        elevation: 8,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: DarkThemeColors.elevatedBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: DarkThemeColors.border),
        ),
        textStyle: TextStyle(color: DarkThemeColors.textPrimary),
      ),
      
      // ListTile
      listTileTheme: ListTileThemeData(
        tileColor: DarkThemeColors.cardBg,
        selectedTileColor: DarkThemeColors.hover,
        iconColor: DarkThemeColors.textSecondary,
        textColor: DarkThemeColors.textPrimary,
        selectedColor: DarkThemeColors.primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
