import 'package:flutter/material.dart';
import 'dark_theme_colors.dart';

/// 🎨 Color Utilities for MathQuest Dark Mode
/// 
/// Provides helper methods for color manipulation, contrast checking,
/// and adaptive color selection based on theme mode.
/// 
/// Features:
/// - WCAG contrast ratio calculation
/// - Adaptive color selection (light/dark aware)
/// - Color shade generation
/// - Glow effect creation
/// - Color opacity adjustments
class ColorUtils {
  // ============================================================================
  // ADAPTIVE COLOR SELECTION
  // ============================================================================
  
  /// Returns appropriate color based on current theme mode
  /// 
  /// Example:
  /// ```dart
  /// Color textColor = ColorUtils.adaptive(
  ///   light: Colors.black87,
  ///   dark: DarkThemeColors.textPrimary,
  ///   isDark: Theme.of(context).brightness == Brightness.dark,
  /// );
  /// ```
  static Color adaptive({
    required Color light,
    required Color dark,
    required bool isDark,
  }) {
    return isDark ? dark : light;
  }
  
  /// Get adaptive color from context (automatically detects theme)
  static Color adaptiveFromContext(
    BuildContext context, {
    required Color light,
    required Color dark,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return adaptive(light: light, dark: dark, isDark: isDark);
  }

  // ============================================================================
  // COLOR SHADE GENERATION
  // ============================================================================
  
  /// Generate a lighter or darker shade of a color
  /// 
  /// [amount] ranges from -1.0 (much darker) to 1.0 (much lighter)
  /// 
  /// Example:
  /// ```dart
  /// Color lighterGreen = ColorUtils.shade(Colors.green, 0.3); // 30% lighter
  /// Color darkerGreen = ColorUtils.shade(Colors.green, -0.3); // 30% darker
  /// ```
  static Color shade(Color base, double amount) {
    assert(amount >= -1.0 && amount <= 1.0);
    
    final hsl = HSLColor.fromColor(base);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Lighten a color by percentage (0.0 to 1.0)
  static Color lighten(Color color, double amount) {
    return shade(color, amount.abs());
  }
  
  /// Darken a color by percentage (0.0 to 1.0)
  static Color darken(Color color, double amount) {
    return shade(color, -amount.abs());
  }
  
  /// Increase color saturation
  static Color saturate(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0);
    
    final hsl = HSLColor.fromColor(color);
    final saturation = (hsl.saturation + amount).clamp(0.0, 1.0);
    
    return hsl.withSaturation(saturation).toColor();
  }
  
  /// Decrease color saturation (make more gray)
  static Color desaturate(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0);
    
    final hsl = HSLColor.fromColor(color);
    final saturation = (hsl.saturation - amount).clamp(0.0, 1.0);
    
    return hsl.withSaturation(saturation).toColor();
  }

  // ============================================================================
  // OPACITY & TRANSPARENCY
  // ============================================================================
  
  /// Adjust color opacity (alpha channel)
  /// 
  /// [opacity] ranges from 0.0 (fully transparent) to 1.0 (fully opaque)
  static Color withOpacity(Color color, double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return color.withValues(alpha: opacity);
  }
  
  /// Make color semi-transparent (50% opacity)
  static Color semi(Color color) => withOpacity(color, 0.5);
  
  /// Make color subtle (30% opacity)
  static Color subtle(Color color) => withOpacity(color, 0.3);
  
  /// Make color faint (10% opacity)
  static Color faint(Color color) => withOpacity(color, 0.1);

  // ============================================================================
  // GLOW EFFECTS FOR DARK MODE
  // ============================================================================
  
  /// Create a glow effect BoxShadow
  /// 
  /// Perfect for buttons, cards, and interactive elements in dark mode
  /// 
  /// Example:
  /// ```dart
  /// Container(
  ///   decoration: BoxDecoration(
  ///     color: DarkThemeColors.cardBg,
  ///     boxShadow: [ColorUtils.glow(DarkThemeColors.primaryGreen)],
  ///   ),
  /// )
  /// ```
  static BoxShadow glow({
    Color color = DarkThemeColors.primaryGreen,
    double blur = 12,
    double spread = 0,
    Offset offset = Offset.zero,
    double opacity = 0.3,
  }) {
    return BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      spreadRadius: spread,
      offset: offset,
    );
  }
  
  /// Create multiple glow layers for intense effect
  static List<BoxShadow> multiGlow({
    Color color = DarkThemeColors.primaryGreen,
    int layers = 2,
  }) {
    return List.generate(layers, (index) {
      final intensity = 1.0 - (index * 0.4);
      return glow(
        color: color,
        blur: 12 + (index * 6.0),
        opacity: 0.3 * intensity,
      );
    });
  }
  
  /// Create a subtle inner glow effect
  static BoxShadow innerGlow({
    Color color = DarkThemeColors.primaryGreen,
    double blur = 8,
  }) {
    return BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: blur,
      spreadRadius: -2,
      offset: Offset.zero,
    );
  }

  // ============================================================================
  // ELEVATION & SHADOWS
  // ============================================================================
  
  /// Create elevation shadow for dark mode
  /// 
  /// [elevation] ranges from 0 to 24 (Material Design standard)
  static List<BoxShadow> elevation(double elevation) {
    if (elevation <= 0) return [];
    
    return [
      BoxShadow(
        color: DarkThemeColors.shadow,
        blurRadius: elevation * 2,
        spreadRadius: 0,
        offset: Offset(0, elevation / 2),
      ),
    ];
  }
  
  /// Create soft elevation (less pronounced)
  static List<BoxShadow> softElevation(double elevation) {
    if (elevation <= 0) return [];
    
    return [
      BoxShadow(
        color: DarkThemeColors.shadow.withValues(alpha: 0.15),
        blurRadius: elevation * 3,
        spreadRadius: 0,
        offset: Offset(0, elevation / 3),
      ),
    ];
  }

  // ============================================================================
  // CONTRAST RATIO CALCULATION (WCAG)
  // ============================================================================
  
  /// Calculate relative luminance of a color (WCAG formula)
  /// 
  /// Returns value between 0 (darkest) and 1 (lightest)
  static double _relativeLuminance(Color color) {
    final r = _luminanceComponent(color.red / 255.0);
    final g = _luminanceComponent(color.green / 255.0);
    final b = _luminanceComponent(color.blue / 255.0);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }
  
  /// Calculate luminance component (WCAG formula helper)
  static double _luminanceComponent(double component) {
    return component <= 0.03928
        ? component / 12.92
        : ((component + 0.055) / 1.055) * ((component + 0.055) / 1.055);
  }
  
  /// Calculate contrast ratio between two colors (WCAG standard)
  /// 
  /// Returns value between 1 (no contrast) and 21 (maximum contrast)
  /// 
  /// WCAG Standards:
  /// - AA Normal Text: 4.5:1
  /// - AA Large Text: 3:1
  /// - AAA Normal Text: 7:1
  /// - AAA Large Text: 4.5:1
  /// 
  /// Example:
  /// ```dart
  /// double ratio = ColorUtils.contrastRatio(
  ///   DarkThemeColors.textPrimary,
  ///   DarkThemeColors.scaffoldBg,
  /// );
  /// print('Contrast: ${ratio.toStringAsFixed(2)}:1');
  /// ```
  static double contrastRatio(Color foreground, Color background) {
    final lum1 = _relativeLuminance(foreground);
    final lum2 = _relativeLuminance(background);
    
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  // ============================================================================
  // WCAG COMPLIANCE CHECKS
  // ============================================================================
  
  /// Check if contrast meets WCAG AA for normal text (4.5:1)
  static bool meetsWCAGAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 4.5;
  }
  
  /// Check if contrast meets WCAG AA for large text (3:1)
  static bool meetsWCAGAALarge(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 3.0;
  }
  
  /// Check if contrast meets WCAG AAA for normal text (7:1)
  static bool meetsWCAGAAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 7.0;
  }
  
  /// Check if contrast meets WCAG AAA for large text (4.5:1)
  static bool meetsWCAGAAALarge(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 4.5;
  }
  
  /// Get compliance level string
  static String getComplianceLevel(Color foreground, Color background) {
    final ratio = contrastRatio(foreground, background);
    
    if (ratio >= 7.0) return 'AAA (Normal & Large)';
    if (ratio >= 4.5) return 'AA (Normal) / AAA (Large)';
    if (ratio >= 3.0) return 'AA (Large only)';
    return 'Fails WCAG';
  }

  // ============================================================================
  // COLOR MIXING & BLENDING
  // ============================================================================
  
  /// Mix two colors together
  /// 
  /// [ratio] determines the blend (0.0 = all color1, 1.0 = all color2)
  static Color mix(Color color1, Color color2, double ratio) {
    assert(ratio >= 0.0 && ratio <= 1.0);
    
    final r = (color1.red * (1 - ratio) + color2.red * ratio).round();
    final g = (color1.green * (1 - ratio) + color2.green * ratio).round();
    final b = (color1.blue * (1 - ratio) + color2.blue * ratio).round();
    final a = (color1.alpha * (1 - ratio) + color2.alpha * ratio).round();
    
    return Color.fromARGB(a, r, g, b);
  }
  
  /// Overlay a color on top of another with opacity
  static Color overlay(Color base, Color overlay, double opacity) {
    return mix(base, overlay, opacity);
  }

  // ============================================================================
  // GRADIENT HELPERS
  // ============================================================================
  
  /// Create a vertical gradient from light to dark
  static LinearGradient verticalGradient(Color topColor, Color bottomColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [topColor, bottomColor],
    );
  }
  
  /// Create a horizontal gradient from left to right
  static LinearGradient horizontalGradient(Color leftColor, Color rightColor) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [leftColor, rightColor],
    );
  }
  
  /// Create a diagonal gradient (top-left to bottom-right)
  static LinearGradient diagonalGradient(Color startColor, Color endColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [startColor, endColor],
    );
  }
  
  /// Create a radial gradient
  static RadialGradient radialGradient(Color centerColor, Color edgeColor) {
    return RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [centerColor, edgeColor],
    );
  }

  // ============================================================================
  // SHIMMER ANIMATION GRADIENT
  // ============================================================================
  
  /// Create shimmer gradient for loading states
  static LinearGradient shimmerGradient({
    Color baseColor = DarkThemeColors.cardBg,
    Color highlightColor = DarkThemeColors.shimmer,
  }) {
    return LinearGradient(
      begin: const Alignment(-1.0, 0.0),
      end: const Alignment(1.0, 0.0),
      colors: [
        baseColor,
        highlightColor,
        baseColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Convert color to hex string
  static String toHex(Color color, {bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    }
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
  
  /// Parse hex string to Color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  /// Check if color is considered "light"
  static bool isLight(Color color) {
    return _relativeLuminance(color) > 0.5;
  }
  
  /// Check if color is considered "dark"
  static bool isDark(Color color) {
    return !isLight(color);
  }
  
  /// Get contrasting text color (black or white) for best readability
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLight(backgroundColor) ? Colors.black87 : Colors.white;
  }

  // ============================================================================
  // DEBUG & TESTING
  // ============================================================================
  
  /// Print color information for debugging
  static void debugColor(Color color, String name) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🎨 Color Debug: $name');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Hex: ${toHex(color, includeAlpha: true)}');
    print('RGB: (${color.red}, ${color.green}, ${color.blue})');
    print('Alpha: ${(color.alpha / 255 * 100).toStringAsFixed(0)}%');
    print('Luminance: ${(_relativeLuminance(color) * 100).toStringAsFixed(1)}%');
    print('Type: ${isLight(color) ? "Light" : "Dark"}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
  
  /// Print contrast ratio between two colors
  static void debugContrast(Color foreground, Color background) {
    final ratio = contrastRatio(foreground, background);
    final level = getComplianceLevel(foreground, background);
    
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📊 Contrast Analysis');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Foreground: ${toHex(foreground)}');
    print('Background: ${toHex(background)}');
    print('Ratio: ${ratio.toStringAsFixed(2)}:1');
    print('Compliance: $level');
    print('AA Normal: ${meetsWCAGAA(foreground, background) ? "✅" : "❌"}');
    print('AA Large: ${meetsWCAGAALarge(foreground, background) ? "✅" : "❌"}');
    print('AAA Normal: ${meetsWCAGAAA(foreground, background) ? "✅" : "❌"}');
    print('AAA Large: ${meetsWCAGAAALarge(foreground, background) ? "✅" : "❌"}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}

