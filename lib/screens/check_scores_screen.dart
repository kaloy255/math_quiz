import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/classroom_model.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';

class CheckScoresScreen extends StatefulWidget {
  const CheckScoresScreen({super.key});

  @override
  State<CheckScoresScreen> createState() => _CheckScoresScreenState();
}

class _CheckScoresScreenState extends State<CheckScoresScreen> {
  List<UserModel> _students = [];
  String _selectedQuarter = '1st Quarter';
  int _selectedQuizNumber = 1;
  bool _loading = true;
  UserModel? _currentTeacher;
  List<ClassroomModel> _classrooms = [];
  String? _selectedClassroomCode;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final user = DatabaseService.getCurrentUser();
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final teacherClassrooms = user.role == 'teacher'
        ? DatabaseService.getClassroomsByTeacher(user.id)
        : <ClassroomModel>[];
    final classroomCodes = teacherClassrooms
        .map((c) => c.classroomCode)
        .toSet();

    String? activeClassroom = _selectedClassroomCode;
    if (classroomCodes.isNotEmpty) {
      if (activeClassroom == null ||
          !classroomCodes.contains(activeClassroom)) {
        activeClassroom = teacherClassrooms.first.classroomCode;
      }
    } else if (activeClassroom == null &&
        user.classroomCode != null &&
        user.classroomCode!.isNotEmpty) {
      activeClassroom = user.classroomCode;
    }

    final usersBox = DatabaseService.getUsersBox();
    final students =
        usersBox.values
            .where(
              (u) =>
                  u.role == 'student' &&
                  (activeClassroom != null && activeClassroom.isNotEmpty
                      ? u.classroomCode == activeClassroom
                      : user.classroomCode != null &&
                            u.classroomCode == user.classroomCode),
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      _currentTeacher = user;
      _students = students;
      _classrooms = teacherClassrooms;
      _selectedClassroomCode = activeClassroom;
      _loading = false;
    });
  }

  // Get quiz definitions dynamically (matches student_performance_screen.dart)
  List<Map<String, String>> _getQuizzesForQuarter(int quarter) {
    switch (quarter) {
      case 1:
        return [
          {'id': '1', 'title': 'Quiz 1'},
          {'id': '2', 'title': 'Quiz 2'},
          {'id': '3', 'title': 'Quiz 3'},
          {'id': '4', 'title': 'Quiz 4'},
          {'id': '5', 'title': 'Quiz 5'},
          {'id': '6', 'title': 'Quiz 6'},
          {'id': '7', 'title': 'Quiz 7'},
          {'id': '8', 'title': 'Quiz 8'},
          {'id': '9', 'title': 'Quiz 9'},
        ];
      case 2:
        return [
          {'id': '1', 'title': 'Quiz 1'},
          {'id': '2', 'title': 'Quiz 2'},
          {'id': '3', 'title': 'Quiz 3'},
          {'id': '4', 'title': 'Quiz 4'},
          {'id': '5', 'title': 'Quiz 5'},
          {'id': '6', 'title': 'Quiz 6'},
          {'id': '7', 'title': 'Quiz 7'},
          {'id': '8', 'title': 'Quiz 8'},
          {'id': '9', 'title': 'Quiz 9'},
        ];
      case 3:
        return [];
      case 4:
        return [];
      default:
        return [];
    }
  }

  String _getQuarterNumber(String quarter) {
    switch (quarter) {
      case '1st Quarter':
        return '1';
      case '2nd Quarter':
        return '2';
      default:
        return '1';
    }
  }

  // Get first attempt score for a student on a specific quiz
  Map<String, dynamic>? _getFirstAttemptScore(
    String studentId,
    int quizNumber,
  ) {
    final attemptsBox = Hive.box('quizAttempts');
    final allAttempts = attemptsBox.values.toList();
    final quarterNum = _getQuarterNumber(_selectedQuarter);
    final quizId = '$quizNumber-Q$quarterNum';

    // Find all attempts for this student and quiz
    final studentAttempts = allAttempts
        .where(
          (a) =>
              a['userId'] == studentId &&
              a['quizId'] == quizId &&
              a['quarter'] == quarterNum,
        )
        .toList();

    if (studentAttempts.isEmpty) return null;

    // Sort by completion date to get first attempt
    studentAttempts.sort(
      (a, b) => DateTime.parse(
        a['completedAt'],
      ).compareTo(DateTime.parse(b['completedAt'])),
    );

    final firstAttempt = studentAttempts.first;
    return {
      'score': firstAttempt['score'] as int,
      'totalQuestions': firstAttempt['totalQuestions'] as int,
      'correctAnswers': firstAttempt['correctAnswers'] as int,
      'completedAt': firstAttempt['completedAt'] as String,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    if (_loading) {
      return Scaffold(
        backgroundColor: ThemeHelper.getContainerColor(context),
        appBar: const CustomAppBar(showBackButton: true),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ThemeHelper.getPrimaryGreen(context),
            ),
          ),
        ),
      );
    }

    final quarterNum = int.tryParse(_getQuarterNumber(_selectedQuarter)) ?? 1;
    final availableQuizzes = _getQuizzesForQuarter(quarterNum);

    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      appBar: const CustomAppBar(showBackButton: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Padding(
            padding: ResponsiveHelper.padding(
              context,
              all: ResponsiveHelper.contentPadding(context),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.maxContentWidth(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomCard(
                    withGlow: isDark,
                    child: Center(
                      child: Text(
                        'CHECK SCORES',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 24),
                          fontWeight: FontWeight.bold,
                          color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 20)),

                  if (_classrooms.isNotEmpty) ...[
                    _buildClassroomFilter(context),
                    SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                  ],

                  // Quarter Selection
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QUARTER:',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 14),
                            fontWeight: FontWeight.bold,
                            color: ThemeHelper.getTextColor(context),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                        DropdownButton<String>(
                          value: _selectedQuarter,
                          isExpanded: true,
                          dropdownColor: ThemeHelper.getCardColor(context),
                          style: TextStyle(
                            color: ThemeHelper.getTextColor(context),
                            fontSize: ResponsiveHelper.fontSize(context, 14),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: '1st Quarter',
                              child: Text('1st Quarter'),
                            ),
                            DropdownMenuItem(
                              value: '2nd Quarter',
                              child: Text('2nd Quarter'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() {
                              _selectedQuarter = v;
                              _selectedQuizNumber =
                                  1; // Reset to quiz 1 when quarter changes
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                  // Quiz Number Selection
                  Text(
                    'QUIZ NUMBER:',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 8)),

                  // Quiz Number Tabs
                  SizedBox(
                    height: ResponsiveHelper.height(context, 40),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableQuizzes.length,
                      itemBuilder: (context, index) {
                        final quizNum = index + 1;
                        final isSelected = _selectedQuizNumber == quizNum;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: ResponsiveHelper.spacing(context, 8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedQuizNumber = quizNum;
                              });
                            },
                            child: Container(
                              padding: ResponsiveHelper.padding(
                                context,
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ThemeHelper.getButtonGreen(context)
                                    : (isDark
                                          ? ThemeHelper.getElevatedColor(
                                              context,
                                            )
                                          : const Color(0xFFD4EDD0)),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(context, 8),
                                ),
                                border: isSelected && isDark
                                    ? Border.all(
                                        color: ThemeHelper.getPrimaryGreen(
                                          context,
                                        ),
                                        width: 2,
                                      )
                                    : null,
                                boxShadow: isSelected && isDark
                                    ? ThemeHelper.getGlow(
                                        context,
                                        color: ThemeHelper.getPrimaryGreen(
                                          context,
                                        ),
                                        blur: 6,
                                      )
                                    : null,
                              ),
                              child: Text(
                                '$quizNum',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    14,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : ThemeHelper.getTextColor(context),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 20)),

                  // Grade & Section
                  CustomCard(
                    child: Row(
                      children: [
                        Icon(
                          Icons.class_,
                          size: ResponsiveHelper.iconSize(context, 18),
                          color: isDark
                              ? ThemeHelper.getPrimaryGreen(context)
                              : ThemeHelper.getButtonGreen(context),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                        Expanded(
                          child: Text(
                            'Grade & Section: ${_activeClassroomLabel}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 14),
                              fontWeight: FontWeight.w600,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                  // Scores Table
                  Expanded(
                    child: CustomCard(
                      withGlow: isDark,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: ResponsiveHelper.padding(context, all: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? ThemeHelper.getElevatedColor(context)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  ResponsiveHelper.borderRadius(context, 8),
                                ),
                                topRight: Radius.circular(
                                  ResponsiveHelper.borderRadius(context, 8),
                                ),
                              ),
                              border: isDark
                                  ? Border(
                                      bottom: BorderSide(
                                        color: ThemeHelper.getDividerColor(
                                          context,
                                        ),
                                        width: 1,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: ResponsiveHelper.isSmallMobile(context)
                                      ? 2
                                      : 3,
                                  child: Text(
                                    'NAME',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        14,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      color: ThemeHelper.getTextColor(context),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: ResponsiveHelper.isSmallMobile(context)
                                      ? 1
                                      : 2,
                                  child: Text(
                                    'SCORE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        14,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      color: ThemeHelper.getTextColor(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Table Body
                          Expanded(
                            child: ListView.builder(
                              itemCount: _students.length,
                              itemBuilder: (context, index) {
                                final student = _students[index];
                                final scoreData = _getFirstAttemptScore(
                                  student.id,
                                  _selectedQuizNumber,
                                );
                                final isEvenRow = index.isEven;

                                return Container(
                                  padding: ResponsiveHelper.padding(
                                    context,
                                    all: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isEvenRow
                                        ? (isDark
                                              ? ThemeHelper.getElevatedColor(
                                                  context,
                                                ).withOpacity(0.3)
                                              : const Color(0xFFF8FBF7))
                                        : (isDark
                                              ? ThemeHelper.getCardColor(
                                                  context,
                                                )
                                              : Colors.white),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isDark
                                            ? ThemeHelper.getDividerColor(
                                                context,
                                              )
                                            : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex:
                                            ResponsiveHelper.isSmallMobile(
                                              context,
                                            )
                                            ? 2
                                            : 3,
                                        child: Text(
                                          student.name,
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.fontSize(
                                              context,
                                              14,
                                            ),
                                            color: ThemeHelper.getTextColor(
                                              context,
                                            ),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex:
                                            ResponsiveHelper.isSmallMobile(
                                              context,
                                            )
                                            ? 1
                                            : 2,
                                        child: Text(
                                          scoreData != null
                                              ? '${scoreData['correctAnswers']}/${scoreData['totalQuestions']}'
                                              : 'No attempt',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.fontSize(
                                              context,
                                              14,
                                            ),
                                            color: scoreData != null
                                                ? (scoreData['score'] >= 70
                                                      ? ThemeHelper.getButtonGreen(
                                                          context,
                                                        )
                                                      : ThemeHelper.getErrorColor(
                                                          context,
                                                        ))
                                                : ThemeHelper.getSecondaryTextColor(
                                                    context,
                                                  ),
                                            fontWeight: scoreData != null
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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

  Widget _buildClassroomFilter(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.getTextColor(context);

    return CustomCard(
      withGlow: isDark,
      child: Padding(
        padding: ResponsiveHelper.padding(
          context,
          horizontal: ResponsiveHelper.spacing(context, 16),
          vertical: ResponsiveHelper.spacing(context, 12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: ThemeHelper.getPrimaryGreen(context),
              size: ResponsiveHelper.iconSize(context, 20),
            ),
            SizedBox(width: ResponsiveHelper.spacing(context, 12)),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedClassroomCode,
                  isExpanded: true,
                  dropdownColor: ThemeHelper.getCardColor(context),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: ThemeHelper.getPrimaryGreen(context),
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                  hint: Text(
                    'Select classroom',
                    style: TextStyle(
                      color: ThemeHelper.getSecondaryTextColor(context),
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                    ),
                  ),
                  items: _classrooms.map((classroom) {
                    return DropdownMenuItem<String>(
                      value: classroom.classroomCode,
                      child: Text(_formatClassroomOption(classroom)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedClassroomCode = value;
                      _loading = true;
                    });
                    _loadData();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatClassroomOption(ClassroomModel classroom) {
    final section = classroom.gradeAndSection?.trim();
    final label = (section != null && section.isNotEmpty)
        ? section
        : (classroom.classroomName.isNotEmpty
              ? classroom.classroomName
              : classroom.classroomCode);
    return '$label (${classroom.classroomCode})';
  }

  String get _activeClassroomLabel {
    final match = _getSelectedClassroom();
    if (match != null) {
      if (match.gradeAndSection != null &&
          match.gradeAndSection!.trim().isNotEmpty) {
        return match.gradeAndSection!;
      }
      if (match.classroomName.isNotEmpty) {
        return match.classroomName;
      }
      return match.classroomCode;
    }

    if (_currentTeacher?.classroomName?.isNotEmpty == true) {
      return _currentTeacher!.classroomName!;
    }

    return _currentTeacher?.classroomCode ?? 'N/A';
  }

  ClassroomModel? _getSelectedClassroom() {
    if (_selectedClassroomCode == null) return null;
    for (final classroom in _classrooms) {
      if (classroom.classroomCode == _selectedClassroomCode) {
        return classroom;
      }
    }
    return null;
  }
}
