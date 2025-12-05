import 'package:flutter/material.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';

/// 🎨 Custom Button Components for MathQuest
///
/// Features:
/// - Dark mode support with glow effects
/// - Responsive sizing
/// - Loading states
/// - Multiple variants (primary, secondary, outlined, text)
/// - Icon support

/// Primary Button (Green with glow in dark mode)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      width: width,
      height: height ?? ResponsiveHelper.height(context, 50),
      decoration: isDark && onPressed != null
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              boxShadow: ThemeHelper.getGlow(
                context,
                color: ThemeHelper.getButtonGreen(context),
                blur: 12,
              ),
            )
          : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeHelper.getButtonGreen(context),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.spacing(context, 24),
            vertical: ResponsiveHelper.spacing(context, 12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(context, 12),
            ),
          ),
          disabledBackgroundColor: ThemeHelper.getBorderColor(context),
          disabledForegroundColor: ThemeHelper.getTertiaryTextColor(context),
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveHelper.iconSize(context, 20),
                height: ResponsiveHelper.iconSize(context, 20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.7),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: ResponsiveHelper.iconSize(context, 20)),
                    SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Secondary Button (Outlined with green border)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? ResponsiveHelper.height(context, 50),
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeHelper.getPrimaryGreen(context),
          side: BorderSide(
            color: onPressed != null
                ? ThemeHelper.getPrimaryGreen(context)
                : ThemeHelper.getBorderColor(context),
            width: 2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.spacing(context, 24),
            vertical: ResponsiveHelper.spacing(context, 12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.borderRadius(context, 12),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveHelper.iconSize(context, 20),
                height: ResponsiveHelper.iconSize(context, 20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ThemeHelper.getPrimaryGreen(context),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: ResponsiveHelper.iconSize(context, 20)),
                    SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Text Button (Minimal, green text)
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: ThemeHelper.getPrimaryGreen(context),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.spacing(context, 16),
          vertical: ResponsiveHelper.spacing(context, 8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: ResponsiveHelper.iconSize(context, 18)),
            SizedBox(width: ResponsiveHelper.spacing(context, 6)),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon Button (Circular with background)
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final bool withGlow;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.withGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final btnSize = size ?? ResponsiveHelper.iconSize(context, 48);

    return Container(
      width: btnSize,
      height: btnSize,
      decoration: isDark && withGlow && onPressed != null
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: ThemeHelper.getGlow(
                context,
                color: ThemeHelper.getPrimaryGreen(context),
              ),
            )
          : null,
      child: Material(
        color:
            backgroundColor ??
            (isDark ? ThemeHelper.getCardColor(context) : Colors.grey[200]),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              color:
                  iconColor ??
                  (onPressed != null
                      ? ThemeHelper.getPrimaryGreen(context)
                      : ThemeHelper.getTertiaryTextColor(context)),
              size: btnSize * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Action Button (Square with icon, used in dashboard)
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: ResponsiveHelper.cardPadding(context),
        decoration: BoxDecoration(
          color: ThemeHelper.isDarkMode(context)
              ? ThemeHelper.getCardColor(context)
              : const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 12),
          ),
          border: Border.all(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
          boxShadow: ThemeHelper.getElevation(context, 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.iconSize(context, 32),
              color: ThemeHelper.getPrimaryGreen(context),
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 14),
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
