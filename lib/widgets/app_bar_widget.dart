import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class MathQuestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;

  const MathQuestAppBar({super.key, this.showBackButton = false, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF6BBF59),
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: ResponsiveHelper.iconSize(context, 24),
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: (title == null || title == 'MathQuest')
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: ResponsiveHelper.iconSize(context, 32),
                  height: ResponsiveHelper.iconSize(context, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 8),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/app_logo.png',
                      width: ResponsiveHelper.iconSize(context, 28),
                      height: ResponsiveHelper.iconSize(context, 28),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                Text(
                  'MathQuest',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.fontSize(context, 24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Text(
              title!,
              style: TextStyle(
                color: Colors.black,
                fontSize: ResponsiveHelper.fontSize(context, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
