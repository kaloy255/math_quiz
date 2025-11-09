import 'package:flutter/material.dart';

/// Responsive helper utility for creating adaptive layouts
class ResponsiveHelper {
  // Breakpoints for different screen sizes
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= tabletBreakpoint;
  }

  /// Get responsive padding
  static EdgeInsets padding(
    BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      final responsiveValue = _getResponsiveValue(context, all);
      return EdgeInsets.all(responsiveValue);
    }

    return EdgeInsets.only(
      left: left != null
          ? _getResponsiveValue(context, left)
          : (horizontal ?? 0),
      right: right != null
          ? _getResponsiveValue(context, right)
          : (horizontal ?? 0),
      top: top != null ? _getResponsiveValue(context, top) : (vertical ?? 0),
      bottom: bottom != null
          ? _getResponsiveValue(context, bottom)
          : (vertical ?? 0),
    );
  }

  /// Get responsive margin
  static EdgeInsets margin(
    BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      final responsiveValue = _getResponsiveValue(context, all);
      return EdgeInsets.all(responsiveValue);
    }

    return EdgeInsets.only(
      left: left != null
          ? _getResponsiveValue(context, left)
          : (horizontal ?? 0),
      right: right != null
          ? _getResponsiveValue(context, right)
          : (horizontal ?? 0),
      top: top != null ? _getResponsiveValue(context, top) : (vertical ?? 0),
      bottom: bottom != null
          ? _getResponsiveValue(context, bottom)
          : (vertical ?? 0),
    );
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.25;
    }
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.4;
    }
  }

  /// Get responsive width
  static double width(
    BuildContext context,
    double baseWidth, {
    double? maxWidth,
  }) {
    final responsiveValue = _getResponsiveValue(context, baseWidth);
    if (maxWidth != null && responsiveValue > maxWidth) {
      return maxWidth;
    }
    return responsiveValue;
  }

  /// Get responsive height
  static double height(
    BuildContext context,
    double baseHeight, {
    double? maxHeight,
  }) {
    final responsiveValue = _getResponsiveValue(context, baseHeight);
    if (maxHeight != null && responsiveValue > maxHeight) {
      return maxHeight;
    }
    return responsiveValue;
  }

  /// Get responsive spacing
  static double spacing(BuildContext context, double baseSpacing) {
    return _getResponsiveValue(context, baseSpacing);
  }

  /// Get responsive borderRadius
  static double borderRadius(BuildContext context, double baseRadius) {
    if (isMobile(context)) {
      return baseRadius;
    } else if (isTablet(context)) {
      return baseRadius * 1.1;
    } else {
      return baseRadius * 1.2;
    }
  }

  /// Get max content width (for centering content on large screens)
  static double maxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return tabletBreakpoint;
    } else {
      return desktopBreakpoint;
    }
  }

  /// Calculate responsive value based on screen size
  static double _getResponsiveValue(BuildContext context, double baseValue) {
    final width = screenWidth(context);
    if (width < mobileBreakpoint) {
      // Mobile: use base value
      return baseValue;
    } else if (width < tabletBreakpoint) {
      // Tablet: scale by 1.15
      return baseValue * 1.15;
    } else {
      // Desktop: scale by 1.3
      return baseValue * 1.3;
    }
  }

  /// Get responsive column count for grids
  static int gridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive horizontal padding for content
  static double contentPadding(BuildContext context) {
    if (isMobile(context)) {
      return 16;
    } else if (isTablet(context)) {
      return 24;
    } else {
      return 32;
    }
  }

  /// Get responsive card padding
  static EdgeInsets cardPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(24);
    }
  }
}
