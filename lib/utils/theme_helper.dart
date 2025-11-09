import 'package:flutter/material.dart';

class ThemeHelper {
  // Get background gradient based on theme
  static LinearGradient getBackgroundGradient(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return isDark
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF161B22),
              Color(0xFF0D1117),
            ], // Deep blue-black gradient
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8E8E8), Color(0xFFFFF9E6)],
          );
  }

  // Get card background color based on theme
  static Color getCardColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF161B22)
        : const Color(0xFFD4EDD0); // Dark surface color
  }

  // Get container background color based on theme
  static Color getContainerColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF0D1117)
        : const Color(0xFFFFF9E6); // Deep dark background
  }

  // Get text color based on theme
  static Color getTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? const Color(0xFFE6EDF3)
        : Colors.black87; // Light grayish-blue
  }

  // Get secondary text color based on theme
  static Color getSecondaryTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark ? const Color(0xFF8B949E) : Colors.grey; // Medium gray
  }

  // Get border color based on theme
  static Color getBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF30363D)
        : Colors.grey[300]!; // Subtle dark border
  }

  // Get primary accent color (teal for dark mode, green for light)
  static Color getPrimaryGreen(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF4ECDC4)
        : const Color(0xFF6BBF59); // Teal in dark, green in light
  }

  // Get accent gradient for headers and buttons
  static LinearGradient getAccentGradient(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4ECDC4), Color(0xFF44B3AA)], // Teal gradient
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6BBF59), Color(0xFF5AA849)], // Green gradient
          );
  }

  // Get secondary accent color (mint green for dark mode)
  static Color getSecondaryAccent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF7EE787)
        : const Color(0xFF6BBF59); // Mint green in dark
  }

  // Check if dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
