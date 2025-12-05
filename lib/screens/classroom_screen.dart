import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/classroom_model.dart';
import '../utils/theme_helper.dart';
import '../widgets/custom_app_bar.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  UserModel? _currentUser;
  UserModel? _teacher;
  ClassroomModel? _classroom;
  List<UserModel> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClassroomData();
  }

  void _loadClassroomData() {
    setState(() {
      _currentUser = DatabaseService.getCurrentUser();
      if (_currentUser != null &&
          _currentUser!.classroomCode != null &&
          _currentUser!.classroomCode!.isNotEmpty) {
        // Get classroom information from ClassroomModel
        _classroom = DatabaseService.getClassroomByCode(
          _currentUser!.classroomCode!,
        );

        // Get teacher information using teacherId from classroom
        if (_classroom != null && _classroom!.teacherId.isNotEmpty) {
          _teacher = _getTeacherById(_classroom!.teacherId);
        }

        _students = _getStudentsInClassroom(_currentUser!.classroomCode!);
      }
      _isLoading = false;
    });
  }

  UserModel? _getTeacherById(String teacherId) {
    try {
      final usersBox = DatabaseService.getUsersBox();
      return usersBox.values.firstWhere(
        (u) => u.id == teacherId && u.role == 'teacher',
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          password: '',
          role: '',
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  List<UserModel> _getStudentsInClassroom(String classroomCode) {
    try {
      final usersBox = DatabaseService.getUsersBox();
      return usersBox.values
          .where((u) => u.role == 'student' && u.classroomCode == classroomCode)
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.getTextColor(context);
    final secondaryText = ThemeHelper.getSecondaryTextColor(context);
    final cardColor = ThemeHelper.getCardColor(context);
    final elevatedColor = ThemeHelper.getElevatedColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final containerColor = ThemeHelper.getContainerColor(context);
    final dividerColor = ThemeHelper.getDividerColor(context);

    return Scaffold(
      backgroundColor: containerColor,
      appBar: const CustomAppBar(
        showBackButton: true,
        showProfileButton: true,
        title: 'Classroom',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // CLASSROOM Title
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: ThemeHelper.getElevation(context, 2),
                  ),
                  child: Text(
                    'CLASSROOM',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),

              // Main Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: ThemeHelper.getElevation(context, 3),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Teacher Information
                              Divider(height: 1, color: dividerColor),
                              const SizedBox(height: 16),
                              Text(
                                'TEACHER:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _teacher?.name ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(height: 1, color: dividerColor),
                              const SizedBox(height: 16),

                              // Grade & Section Information
                              Text(
                                'Grade & Section:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _classroom?.gradeAndSection ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: elevatedColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'NUMBER OF',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: secondaryText,
                                            ),
                                          ),
                                          Text(
                                            'STUDENTS',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: borderColor,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'NAME',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Student List
                              if (_students.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Text(
                                      'No students in this classroom yet',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: secondaryText,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ...List.generate(
                                  _students.length,
                                  (index) => _buildStudentRow(
                                    studentNumber: index + 1,
                                    student: _students[index],
                                  ),
                                ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentRow({
    required int studentNumber,
    required UserModel student,
  }) {
    final textColor = ThemeHelper.getTextColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final cardColor = ThemeHelper.getCardColor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: ThemeHelper.getElevation(context, 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$studentNumber',
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: borderColor, width: 1)),
              ),
              child: Text(
                student.name,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
