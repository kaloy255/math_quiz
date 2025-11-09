import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class RoleSelectionScreen extends StatelessWidget {
  final bool isSignup;

  const RoleSelectionScreen({super.key, this.isSignup = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MathQuestAppBar(showBackButton: true),
      backgroundColor: ThemeHelper.getContainerColor(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.maxContentWidth(context),
            ),
            child: Container(
              margin: ResponsiveHelper.margin(
                context,
                horizontal: ResponsiveHelper.contentPadding(context),
              ),
              padding: ResponsiveHelper.cardPadding(context),
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose Role',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 32),
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 40)),
                  SizedBox(
                    width: double.infinity,
                    height: ResponsiveHelper.height(context, 60),
                    child: ElevatedButton(
                      onPressed: () {
                        if (isSignup) {
                          Navigator.pushNamed(context, '/teacher-signup');
                        } else {
                          Navigator.pushNamed(context, '/teacher-login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6BBF59),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 30),
                          ),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "I'M A TEACHER",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 20)),
                  SizedBox(
                    width: double.infinity,
                    height: ResponsiveHelper.height(context, 60),
                    child: ElevatedButton(
                      onPressed: () {
                        if (isSignup) {
                          Navigator.pushNamed(context, '/student-signup');
                        } else {
                          Navigator.pushNamed(context, '/student-login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6BBF59),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 30),
                          ),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "I'M A STUDENT",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
