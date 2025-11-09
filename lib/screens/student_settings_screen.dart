import 'package:flutter/material.dart';
import 'settings_screen.dart';

class StudentSettingsScreen extends StatelessWidget {
  const StudentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen(userRole: 'student');
  }
}
