import 'package:flutter/material.dart';
import 'settings_screen.dart';

class TeacherSettingsScreen extends StatelessWidget {
  const TeacherSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen(userRole: 'teacher');
  }
}
