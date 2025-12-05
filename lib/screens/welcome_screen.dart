import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';
import 'student_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Check if user is already logged in and redirect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginAndRedirect();
    });
  }

  void _checkLoginAndRedirect() {
    if (DatabaseService.isLoggedIn()) {
      final user = DatabaseService.getCurrentUser();
      if (user != null) {
        // Redirect to appropriate dashboard based on role
        if (user.role == 'student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentDashboardScreen(),
            ),
          );
        } else if (user.role == 'teacher') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherDashboardScreen(),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back navigation when logged in
      onPopInvoked: (didPop) {
        if (didPop) return;
        // If user tries to go back and is logged in, redirect to dashboard
        if (DatabaseService.isLoggedIn()) {
          final user = DatabaseService.getCurrentUser();
          if (user != null) {
            if (user.role == 'student') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentDashboardScreen(),
                ),
              );
            } else if (user.role == 'teacher') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherDashboardScreen(),
                ),
              );
            }
          }
        }
      },
      child: Scaffold(
      appBar: const MathQuestAppBar(),
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
                horizontal: ResponsiveHelper.isMobile(context) ? 20 : 40,
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
                    'WELCOME',
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
                        Navigator.pushNamed(context, '/role-selection');
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
                        'LOG IN',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 20),
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
                        Navigator.pushNamed(context, '/role-selection-signup');
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
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 20),
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
      ),
    );
  }
}
