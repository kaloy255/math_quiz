import 'package:flutter/material.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';

/// 🎨 Custom Card Components for MathQuest
///
/// Features:
/// - Dark mode support with borders and elevation
/// - Optional glow effects
/// - Responsive sizing
/// - Multiple variants (standard, premium, stat)

/// Standard Card
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool withBorder;
  final bool withGlow;
  final Color? backgroundColor;
  final double? elevation;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.withBorder = true,
    this.withGlow = false,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        border: withBorder
            ? Border.all(color: ThemeHelper.getBorderColor(context), width: 1)
            : null,
        boxShadow: [
          ...ThemeHelper.getElevation(context, elevation ?? 4),
          if (isDark && withGlow)
            ...ThemeHelper.getGlow(
              context,
              color: ThemeHelper.getPrimaryGreen(context),
              blur: 8,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 16),
          ),
          child: Padding(
            padding: padding ?? ResponsiveHelper.cardPadding(context),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Premium Card (with green accent and glow)
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const PremiumCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        border: Border.all(
          color: ThemeHelper.getPrimaryGreen(context).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          ...ThemeHelper.getElevation(context, 4),
          if (isDark)
            ...ThemeHelper.getGlow(
              context,
              color: ThemeHelper.getPrimaryGreen(context),
              blur: 12,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 16),
          ),
          child: Padding(
            padding: padding ?? ResponsiveHelper.cardPadding(context),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Stat Card (XP, Badge display)
class StatCard extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool premium;

  const StatCard({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
    required this.value,
    this.onTap,
    this.premium = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ResponsiveHelper.cardPadding(context),
        decoration: BoxDecoration(
          color: isDark
              ? ThemeHelper.getCardColor(context)
              : const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 12),
          ),
          border: premium
              ? Border.all(
                  color: ThemeHelper.getPrimaryGreen(context).withOpacity(0.3),
                  width: 2,
                )
              : Border.all(
                  color: ThemeHelper.getBorderColor(context),
                  width: 1,
                ),
          boxShadow: [
            ...ThemeHelper.getElevation(context, 2),
            if (isDark && premium)
              ...ThemeHelper.getGlow(
                context,
                color: ThemeHelper.getPrimaryGreen(context),
              ),
          ],
        ),
        child: Row(
          children: [
            // Icon or Image
            if (imagePath != null)
              Container(
                width: ResponsiveHelper.iconSize(context, 48),
                height: ResponsiveHelper.iconSize(context, 48),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black87 : Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(context, 8),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(context, 8),
                  ),
                  child: Image.asset(imagePath!, fit: BoxFit.cover),
                ),
              )
            else if (icon != null)
              Container(
                width: ResponsiveHelper.iconSize(context, 48),
                height: ResponsiveHelper.iconSize(context, 48),
                decoration: BoxDecoration(
                  color: ThemeHelper.getPrimaryGreen(context),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(context, 8),
                  ),
                ),
                child: Icon(
                  icon,
                  size: ResponsiveHelper.iconSize(context, 24),
                  color: Colors.white,
                ),
              ),
            SizedBox(width: ResponsiveHelper.spacing(context, 12)),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                      fontWeight: FontWeight.w600,
                      color: ThemeHelper.getSecondaryTextColor(context),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 20),
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quiz Card (for quiz selection)
class QuizCard extends StatelessWidget {
  final String title;
  final int? bestScore;
  final int? remainingXP;
  final VoidCallback onTap;
  final bool isLocked;

  const QuizCard({
    super.key,
    required this.title,
    this.bestScore,
    this.remainingXP,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(context, 12)),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 16),
        ),
        border: Border.all(
          color: ThemeHelper.getBorderColor(context),
          width: 1,
        ),
        boxShadow: ThemeHelper.getElevation(context, 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 16),
          ),
          child: Padding(
            padding: ResponsiveHelper.cardPadding(context),
            child: Row(
              children: [
                // Quiz icon
                Container(
                  width: ResponsiveHelper.iconSize(context, 48),
                  height: ResponsiveHelper.iconSize(context, 48),
                  decoration: BoxDecoration(
                    color: isLocked
                        ? ThemeHelper.getBorderColor(context)
                        : ThemeHelper.getPrimaryGreen(context),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 12),
                    ),
                  ),
                  child: Icon(
                    isLocked ? Icons.lock : Icons.quiz,
                    color: Colors.white,
                    size: ResponsiveHelper.iconSize(context, 24),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 16)),
                // Title and stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: isLocked
                              ? ThemeHelper.getSecondaryTextColor(context)
                              : ThemeHelper.getTextColor(context),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                      Row(
                        children: [
                          if (bestScore != null) ...[
                            Icon(
                              Icons.star,
                              size: ResponsiveHelper.iconSize(context, 16),
                              color: ThemeHelper.getWarningColor(context),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 4),
                            ),
                            Text(
                              'Best: $bestScore%',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  14,
                                ),
                                color: ThemeHelper.getSecondaryTextColor(
                                  context,
                                ),
                              ),
                            ),
                          ],
                          if (bestScore != null && remainingXP != null)
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 12),
                            ),
                          if (remainingXP != null) ...[
                            Icon(
                              Icons.emoji_events,
                              size: ResponsiveHelper.iconSize(context, 16),
                              color: ThemeHelper.getPrimaryGreen(context),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 4),
                            ),
                            Text(
                              '${remainingXP}XP',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  14,
                                ),
                                color: ThemeHelper.getPrimaryGreen(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: isLocked
                      ? ThemeHelper.getTertiaryTextColor(context)
                      : ThemeHelper.getPrimaryGreen(context),
                  size: ResponsiveHelper.iconSize(context, 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
