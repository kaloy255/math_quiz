import 'package:flutter/material.dart';
import 'dark_theme_colors.dart';
import 'color_utils.dart';

/// 🎨 Theme Helper for MathQuest
/// 
/// Provides centralized theme utilities for consistent dark/light mode support.
/// Uses DarkThemeColors for all dark mode values.
class ThemeHelper {
  // ============================================================================
  // BACKGROUND GRADIENTS
  // ============================================================================
  
  /// Get background gradient based on theme
  static LinearGradient getBackgroundGradient(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return isDark
        ? DarkThemeColors.backgroundGradient
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8E8E8), Color(0xFFFFF9E6)],
          );
  }

  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================
  
  /// Get card background color based on theme
  static Color getCardColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.cardBg
        : const Color(0xFFD4EDD0); // Light green card
  }

  /// Get container background color based on theme
  static Color getContainerColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.scaffoldBg
        : const Color(0xFFFFF9E6); // Cream background
  }
  
  /// Get elevated surface color (for modals, dialogs)
  static Color getElevatedColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.elevatedBg
        : Colors.white;
  }
  
  /// Get app bar background color
  static Color getAppBarColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.appBarBg
        : const Color(0xFF6BBF59);
  }

  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  
  /// Get primary text color based on theme
  static Color getTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.textPrimary
        : Colors.black87;
  }

  /// Get secondary text color based on theme
  static Color getSecondaryTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.textSecondary
        : Colors.grey;
  }
  
  /// Get tertiary text color (hints, placeholders)
  static Color getTertiaryTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.textTertiary
        : Colors.grey[600]!;
  }
  
  /// Get inverted text color (for colored backgrounds)
  static Color getInvertedTextColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.textInverted
        : Colors.white;
  }

  // ============================================================================
  // UI ELEMENT COLORS
  // ============================================================================
  
  /// Get border color based on theme
  static Color getBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.border
        : Colors.grey[300]!;
  }
  
  /// Get divider color based on theme
  static Color getDividerColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.divider
        : Colors.grey[200]!;
  }
  
  /// Get hover state color
  static Color getHoverColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.hover
        : Colors.grey[100]!;
  }

  /// Get ripple effect color
  static Color getRippleColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.ripple
        : Colors.grey[300]!;
  }

  // ============================================================================
  // ACCENT COLORS (Mathie-inspired greens)
  // ============================================================================
  
  /// Get primary green accent color (matches Mathie's brand)
  static Color getPrimaryGreen(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.primaryGreen // Bright mint green
        : const Color(0xFF6BBF59); // Original green
  }
  
  /// Get secondary green accent color
  static Color getSecondaryGreen(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.secondaryGreen
        : const Color(0xFF5AA849);
  }
  
  /// Get button green color (for primary CTAs)
  static Color getButtonGreen(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.buttonGreen
        : const Color(0xFF6BBF59);
  }

  /// Get accent gradient for headers and buttons
  static LinearGradient getAccentGradient(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return isDark
        ? DarkThemeColors.greenGradient
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6BBF59), Color(0xFF5AA849)],
          );
  }
  
  /// Get header/AppBar gradient
  static LinearGradient getHeaderGradient(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return isDark
        ? DarkThemeColors.headerGradient
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6BBF59), Color(0xFF5AA849)],
          );
  }
  
  /// Get card gradient (subtle)
  static LinearGradient getCardGradient(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return isDark
        ? DarkThemeColors.cardGradient
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD4EDD0), Color(0xFFC8E6C0)],
          );
  }

  /// Get secondary accent color
  static Color getSecondaryAccent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.tertiaryGreen
        : const Color(0xFF6BBF59);
  }

  // ============================================================================
  // STATUS COLORS
  // ============================================================================
  
  /// Get success color (correct answers, achievements)
  static Color getSuccessColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.success
        : const Color(0xFF4CAF50);
  }
  
  /// Get warning color (time running out, caution)
  static Color getWarningColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.warning
        : const Color(0xFFFF9800);
  }
  
  /// Get error color (wrong answers, validation errors)
  static Color getErrorColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.error
        : const Color(0xFFF44336);
  }
  
  /// Get info color (hints, tooltips)
  static Color getInfoColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? DarkThemeColors.info
        : const Color(0xFF2196F3);
  }
  
  /// Get status background color
  static Color getStatusBackground(
    BuildContext context,
    String status,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (!isDark) {
      // Light mode status backgrounds
      switch (status.toLowerCase()) {
        case 'success':
          return Colors.green[50]!;
        case 'warning':
          return Colors.orange[50]!;
        case 'error':
          return Colors.red[50]!;
        case 'info':
          return Colors.blue[50]!;
        default:
          return Colors.grey[50]!;
      }
    }
    
    return DarkThemeColors.getStatusBackground(status);
  }

  // ============================================================================
  // SHADOWS & EFFECTS
  // ============================================================================
  
  /// Get elevation shadow (Material Design standard)
  static List<BoxShadow> getElevation(
    BuildContext context,
    double elevation,
  ) {
    final isDark = isDarkMode(context);
    return isDark
        ? ColorUtils.elevation(elevation)
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: elevation * 2,
              offset: Offset(0, elevation / 2),
            ),
          ];
  }
  
  /// Get glow effect for dark mode buttons/cards
  static List<BoxShadow> getGlow(
    BuildContext context, {
    Color? color,
    double blur = 12,
  }) {
    final isDark = isDarkMode(context);
    if (!isDark) return [];
    
    return [
      ColorUtils.glow(
        color: color ?? DarkThemeColors.primaryGreen,
        blur: blur,
      ),
    ];
  }
  
  /// Get shimmer gradient for loading states
  static LinearGradient getShimmerGradient(BuildContext context) {
    final isDark = isDarkMode(context);
    return isDark
        ? ColorUtils.shimmerGradient()
        : LinearGradient(
            colors: [
              Colors.grey[200]!,
              Colors.grey[100]!,
              Colors.grey[200]!,
            ],
            stops: const [0.0, 0.5, 1.0],
          );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Check if dark mode is active
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  
  /// Get adaptive color (light/dark aware)
  static Color adaptive(
    BuildContext context, {
    required Color light,
    required Color dark,
  }) {
    return ColorUtils.adaptiveFromContext(
      context,
      light: light,
      dark: dark,
    );
  }
  
  /// Get contrasting text color for a background
  static Color getContrastingText(Color backgroundColor) {
    return ColorUtils.getContrastingTextColor(backgroundColor);
  }
  
  /// Calculate contrast ratio between two colors
  static double getContrastRatio(Color foreground, Color background) {
    return ColorUtils.contrastRatio(foreground, background);
  }
  
  /// Check if color contrast meets WCAG AA
  static bool meetsAccessibility(Color foreground, Color background) {
    return ColorUtils.meetsWCAGAA(foreground, background);
  }
}
