import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/teacher_login_screen.dart';
import 'screens/teacher_signup_screen.dart';
import 'screens/teacher_dashboard_screen.dart';
import 'screens/student_login_screen.dart';
import 'screens/student_signup_screen.dart';
import 'screens/student_dashboard_screen.dart';
import 'screens/quiz_selection_screen.dart';
import 'screens/lesson_page_screen.dart';
import 'services/database_service.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'MathQuest',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/welcome': (context) => const WelcomeScreen(),
              '/role-selection': (context) =>
                  const RoleSelectionScreen(isSignup: false),
              '/role-selection-signup': (context) =>
                  const RoleSelectionScreen(isSignup: true),
              '/teacher-login': (context) => const TeacherLoginScreen(),
              '/teacher-signup': (context) => const TeacherSignupScreen(),
              '/teacher-dashboard': (context) => const TeacherDashboardScreen(),
              '/student-login': (context) => const StudentLoginScreen(),
              '/student-signup': (context) => const StudentSignupScreen(),
              '/student-dashboard': (context) => const StudentDashboardScreen(),
              '/quiz-selection': (context) => const QuizSelectionScreen(),
              '/lesson-page': (context) => const LessonPageScreen(),
              // Note: QuizTakingScreen and LessonListScreen use MaterialPageRoute for passing parameters
            },
          );
        },
      ),
    );
  }
}
