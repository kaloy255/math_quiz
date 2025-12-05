import 'package:flutter/material.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import 'app_logo.dart';

/// 🎨 Custom AppBar for MathQuest
///
/// Features:
/// - Dark mode support with new color system
/// - Responsive sizing
/// - Optional back button
/// - Optional actions
/// - Green gradient header
/// - Profile icon support
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showProfileButton;
  final VoidCallback? onProfileTap;
  final List<Widget>? actions;
  final bool showLogo;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showProfileButton = false,
    this.onProfileTap,
    this.actions,
    this.showLogo = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        gradient: ThemeHelper.getHeaderGradient(context),
        boxShadow: ThemeHelper.getElevation(context, 2),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: ResponsiveHelper.iconSize(context, 24),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: showLogo
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // M Logo
                  AppLogo(
                    withGlow: isDark,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                  Text(
                    title ?? 'MathQuest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(context, 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : title != null
            ? Text(
                title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(context, 20),
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        actions: [
          if (actions != null) ...actions!,
          if (showProfileButton)
            Padding(
              padding: EdgeInsets.only(
                right: ResponsiveHelper.spacing(context, 16),
              ),
              child: GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: ResponsiveHelper.iconSize(context, 40),
                  height: ResponsiveHelper.iconSize(context, 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: isDark
                        ? Border.all(
                            color: ThemeHelper.getPrimaryGreen(
                              context,
                            ).withOpacity(0.5),
                            width: 2,
                          )
                        : null,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: ResponsiveHelper.iconSize(context, 24),
                  ),
                ),
              ),
            ),
        ],
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// Simple AppBar variant without logo
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeHelper.getHeaderGradient(context),
        boxShadow: ThemeHelper.getElevation(context, 2),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: centerTitle,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.fontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: ResponsiveHelper.iconSize(context, 24),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
