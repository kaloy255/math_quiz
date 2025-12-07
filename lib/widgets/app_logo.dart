import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double padding;
  final bool withGlow;
  final Color? backgroundColor;

  const AppLogo({
    super.key,
    this.size = 40,
    this.padding = 6,
    this.withGlow = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSize = ResponsiveHelper.iconSize(context, size);
    final borderRadius = BorderRadius.circular(
      ResponsiveHelper.borderRadius(context, 8),
    );
    final bgColor = backgroundColor ?? ThemeHelper.getElevatedColor(context);
    final borderColor = ThemeHelper.getPrimaryGreen(context);
    final showGlow = withGlow && ThemeHelper.isDarkMode(context);

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          if (showGlow)
            ...ThemeHelper.getGlow(
              context,
              color: borderColor,
              blur: 8,
            ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Image.asset(
          'assets/logo-app.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

