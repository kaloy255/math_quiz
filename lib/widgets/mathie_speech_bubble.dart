import 'package:flutter/material.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';

/// 🎭 Mathie Speech Bubble Widget
///
/// A custom speech bubble designed for dark mode support.
/// Features:
/// - Theme-aware colors (dark/light)
/// - Green border with glow in dark mode
/// - Customizable text and rotation
/// - Tail pointer for character direction
class MathieSpeechBubble extends StatelessWidget {
  // Light-mode bubble tuning knobs (change only affects light theme).
  static const double _lightBubbleWidth = 230.0;
  static const double _lightBubbleHeight = 220.0;
  static const double _lightBubblePaddingX = 24.0;
  static const double _lightBubblePaddingY = 18.0;
  static const double _lightBubbleFontSize = 12.0;
  static const double _lightTextRotationAdjust = -0.25;
  static const double _lightTextOffsetX = 0.0;
  static const double _lightTextOffsetY = 0.0;

  // Dark-mode bubble tuning knobs (change only affects dark theme).
  static const double _darkBubbleWidth = 300.0;
  static const double _darkBubbleHeight = 220.0;
  static const double _darkBubblePaddingX = 20.0;
  static const double _darkBubblePaddingY = 30.0;
  static const double _darkBubbleFontSize = 14.0;
  static const double _darkTextRotationAdjust = -0.30;
  static const double _darkTextOffsetX = 8.0;
  static const double _darkTextOffsetY = -20.0;

  final String text;
  final double rotation;
  final Offset offset;
  final bool showTail;
  final TailDirection tailDirection;
  final bool mirrorDarkBubble;
  final bool mirrorLightBubble;
  final BubbleTuningOverrides? lightOverrides;
  final BubbleTuningOverrides? darkOverrides;

  const MathieSpeechBubble({
    super.key,
    required this.text,
    this.rotation = -0.30,
    this.offset = const Offset(45, -10),
    this.showTail = true,
    this.tailDirection = TailDirection.bottomRight,
    this.mirrorDarkBubble = true,
    this.mirrorLightBubble = false,
    this.lightOverrides,
    this.darkOverrides,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bubbleAsset = isDark
        ? 'assets/images/mathie/bubble_green.png'
        : 'assets/images/mathie/bubble_chat.png';
    // Use the matching asset's sizing knobs so you can fine tune each bubble separately.
    final bubbleWidthConfig = isDark
        ? (darkOverrides?.width ?? _darkBubbleWidth)
        : (lightOverrides?.width ?? _lightBubbleWidth);
    final bubbleWidth = ResponsiveHelper.width(context, bubbleWidthConfig);
    final bubbleHeightConfig = isDark
        ? (darkOverrides?.height ?? _darkBubbleHeight)
        : (lightOverrides?.height ?? _lightBubbleHeight);
    final bubbleHeight = ResponsiveHelper.height(context, bubbleHeightConfig);
    final horizontalPaddingConfig = isDark
        ? (darkOverrides?.paddingX ?? _darkBubblePaddingX)
        : (lightOverrides?.paddingX ?? _lightBubblePaddingX);
    final horizontalPadding = ResponsiveHelper.spacing(
      context,
      horizontalPaddingConfig,
    );
    final verticalPaddingConfig = isDark
        ? (darkOverrides?.paddingY ?? _darkBubblePaddingY)
        : (lightOverrides?.paddingY ?? _lightBubblePaddingY);
    final verticalPadding = ResponsiveHelper.spacing(
      context,
      verticalPaddingConfig,
    );
    final textFontSizeConfig = isDark
        ? (darkOverrides?.fontSize ?? _darkBubbleFontSize)
        : (lightOverrides?.fontSize ?? _lightBubbleFontSize);
    final textFontSize = ResponsiveHelper.fontSize(context, textFontSizeConfig);
    // Use the text rotation knobs to slightly tilt the caption independently per theme.
    final textRotationAdjustment = isDark
        ? (darkOverrides?.textRotationAdjust ?? _darkTextRotationAdjust)
        : (lightOverrides?.textRotationAdjust ?? _lightTextRotationAdjust);
    // Text offset knobs let you nudge the caption horizontally/vertically per theme.
    final textOffsetXConfig = isDark
        ? (darkOverrides?.textOffsetX ?? _darkTextOffsetX)
        : (lightOverrides?.textOffsetX ?? _lightTextOffsetX);
    final textOffsetX = ResponsiveHelper.spacing(context, textOffsetXConfig);
    final textOffsetYConfig = isDark
        ? (darkOverrides?.textOffsetY ?? _darkTextOffsetY)
        : (lightOverrides?.textOffsetY ?? _lightTextOffsetY);
    final textOffsetY = ResponsiveHelper.spacing(context, textOffsetYConfig);
    // Dark bubble sits on a bright neon asset, so force black text for better contrast.
    final textColor = isDark ? Colors.black : ThemeHelper.getTextColor(context);

    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        // Adjust `offset` (x, y) and `rotation` parameters via widget props to reposition the bubble.
        angle: rotation,
        child: SizedBox(
          width: bubbleWidth,
          height: bubbleHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: _buildBubbleImage(
                  isDark: isDark,
                  bubbleAsset: bubbleAsset,
                  bubbleWidth: bubbleWidth,
                  bubbleHeight: bubbleHeight,
                  mirrorDarkBubble: mirrorDarkBubble,
                  mirrorLightBubble: mirrorLightBubble,
                ),
              ),
              Padding(
                // Adjust padding knobs above if you need the text closer/further from the border.
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) => Transform.translate(
                    offset: Offset(textOffsetX, textOffsetY),
                    child: Transform.rotate(
                      // Counter-rotate the text so it stays readable even if the bubble is tilted.
                      angle: -rotation + textRotationAdjustment,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: textFontSize,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubbleImage({
    required bool isDark,
    required String bubbleAsset,
    required double bubbleWidth,
    required double bubbleHeight,
    required bool mirrorDarkBubble,
    required bool mirrorLightBubble,
  }) {
    Widget image = Image.asset(
      bubbleAsset,
      width: bubbleWidth,
      height: bubbleHeight,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) =>
          _buildFallbackBubble(context),
    );

    final shouldMirror =
        (isDark && mirrorDarkBubble) || (!isDark && mirrorLightBubble);

    if (shouldMirror) {
      // Mirror the asset so the tail points toward Mathie.
      image = Transform.scale(
        scaleX: -1,
        scaleY: 1,
        alignment: Alignment.center,
        child: image,
      );
    }

    return image;
  }

  Widget _buildFallbackBubble(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return CustomPaint(
      painter: _SpeechBubblePainter(
        bubbleColor: isDark ? ThemeHelper.getCardColor(context) : Colors.white,
        borderColor: isDark
            ? ThemeHelper.getPrimaryGreen(context)
            : ThemeHelper.getBorderColor(context),
        showGlow: isDark,
        tailDirection: tailDirection,
      ),
      child: const SizedBox.expand(),
    );
  }
}

/// Optional per-theme overrides so individual screens can fine tune bubble sizing/text.
class BubbleTuningOverrides {
  final double? width;
  final double? height;
  final double? paddingX;
  final double? paddingY;
  final double? fontSize;
  final double? textRotationAdjust;
  final double? textOffsetX;
  final double? textOffsetY;

  const BubbleTuningOverrides({
    this.width,
    this.height,
    this.paddingX,
    this.paddingY,
    this.fontSize,
    this.textRotationAdjust,
    this.textOffsetX,
    this.textOffsetY,
  });
}

enum TailDirection { bottomRight, bottomLeft, topRight, topLeft }

class _SpeechBubblePainter extends CustomPainter {
  final Color bubbleColor;
  final Color borderColor;
  final bool showGlow;
  final TailDirection tailDirection;

  _SpeechBubblePainter({
    required this.bubbleColor,
    required this.borderColor,
    required this.showGlow,
    required this.tailDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Glow effect for dark mode
    if (showGlow) {
      final glowPaint = Paint()
        ..color = borderColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;

      final path = _createBubblePath(size);
      canvas.drawPath(path, glowPaint);
    }

    // Main bubble
    final path = _createBubblePath(size);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  Path _createBubblePath(Size size) {
    final path = Path();
    final radius = 20.0;
    final tailSize = 12.0;

    // Main rounded rectangle
    path.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: tailDirection == TailDirection.bottomRight
            ? Radius.circular(4)
            : Radius.circular(radius),
      ),
    );

    // Add tail based on direction
    if (tailDirection == TailDirection.bottomRight) {
      path.moveTo(size.width - 10, size.height);
      path.lineTo(size.width, size.height + tailSize);
      path.lineTo(size.width, size.height);
    } else if (tailDirection == TailDirection.bottomLeft) {
      path.moveTo(10, size.height);
      path.lineTo(0, size.height + tailSize);
      path.lineTo(0, size.height);
    } else if (tailDirection == TailDirection.topRight) {
      path.moveTo(size.width - 10, 0);
      path.lineTo(size.width, -tailSize);
      path.lineTo(size.width, 0);
    } else if (tailDirection == TailDirection.topLeft) {
      path.moveTo(10, 0);
      path.lineTo(0, -tailSize);
      path.lineTo(0, 0);
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simplified version without rotation for easier use
class SimpleSpeechBubble extends StatelessWidget {
  final String text;
  final TailDirection tailDirection;

  const SimpleSpeechBubble({
    super.key,
    required this.text,
    this.tailDirection = TailDirection.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ThemeHelper.getCardColor(context) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(4),
        ),
        border: Border.all(
          color: isDark
              ? ThemeHelper.getPrimaryGreen(context)
              : ThemeHelper.getBorderColor(context),
          width: 2,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: ThemeHelper.getPrimaryGreen(context).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.spacing(context, 18),
        vertical: ResponsiveHelper.spacing(context, 14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: ResponsiveHelper.fontSize(context, 14),
          fontWeight: FontWeight.w600,
          color: ThemeHelper.getTextColor(context),
        ),
      ),
    );
  }
}
