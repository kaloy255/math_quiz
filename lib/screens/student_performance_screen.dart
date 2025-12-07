import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/classroom_model.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';

class StudentPerformanceScreen extends StatefulWidget {
  const StudentPerformanceScreen({super.key});

  @override
  State<StudentPerformanceScreen> createState() =>
      _StudentPerformanceScreenState();
}

class _StudentPerformanceScreenState extends State<StudentPerformanceScreen> {
  List<UserModel> _students = [];
  List<ClassroomModel> _classrooms = [];
  String? _selectedClassroomCode;
  String _selectedQuarter = '1st Quarter';
  bool _loading = true;

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

    // Load students in the selected or default classroom
    final usersBox = DatabaseService.getUsersBox();
    final students = usersBox.values.where((u) {
      if (u.role != 'student') return false;
      final codeToMatch = activeClassroom ?? user.classroomCode;
      if (codeToMatch == null || codeToMatch.isEmpty) return false;
      return u.classroomCode == codeToMatch;
    }).toList();

    setState(() {
      _students = students;
      _classrooms = teacherClassrooms;
      _selectedClassroomCode = activeClassroom;
      _loading = false;
    });
  }

  // Dynamic method to get quiz definitions (mirrors quiz_selection_screen.dart)
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

  // Dynamically get all quiz IDs for a quarter based on quiz definitions
  List<String> _getAllQuizIdsForQuarter(String quarter) {
    // Convert display quarter to numeric format
    final quarterNum = _getQuarterNumber(quarter);
    final numericQuarter = int.tryParse(quarterNum) ?? 1;

    // Get quiz definitions dynamically
    final quizzes = _getQuizzesForQuarter(numericQuarter);

    // Convert to quiz IDs in the format used for storage
    // Format: "1-Q1", "2-Q1", etc. (matches quiz_taking_screen.dart format)
    return quizzes.map((quiz) => '${quiz['id']}-Q$quarterNum').toList();
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

  Map<String, dynamic> _computePassFail(String quarter, String quizId) {
    final attemptsBox = Hive.box('quizAttempts');
    final allAttempts = attemptsBox.values.toList();
    final studentIds = _students.map((e) => e.id).toSet();

    // Convert display quarter to storage format for filtering
    final quarterNum = _getQuarterNumber(quarter);

    // Best score per student for this quiz and quarter
    final Map<String, int> bestScoreByStudent = {};

    for (final a in allAttempts) {
      // Filter by both quarter (using storage format) and quizId
      if (a['quarter'] == quarterNum &&
          a['quizId'] == quizId &&
          studentIds.contains(a['userId'])) {
        final sid = a['userId'] as String;
        final score = a['score'] as int;

        // Keep only the best score per student
        if (!bestScoreByStudent.containsKey(sid) ||
            score > bestScoreByStudent[sid]!) {
          bestScoreByStudent[sid] = score;
        }
      }
    }

    // Calculate passed/failed based on best scores
    int passed = 0;
    int failed = 0;

    bestScoreByStudent.forEach((_, score) {
      // Pass threshold is 70%
      if (score >= 70) {
        passed++;
      } else {
        failed++;
      }
    });

    final total = passed + failed;
    final passedPct = total == 0 ? 0.0 : (passed / total) * 100.0;
    final failedPct = total == 0 ? 0.0 : (failed / total) * 100.0;

    return {
      'passed': passed,
      'failed': failed,
      'passedPct': passedPct,
      'failedPct': failedPct,
      'totalStudents': total,
      'studentScores': bestScoreByStudent, // For debugging if needed
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      appBar: const CustomAppBar(showBackButton: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (_loading)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeHelper.getPrimaryGreen(context),
                    ),
                ),
              ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: ResponsiveHelper.padding(
                      context,
                      all: ResponsiveHelper.contentPadding(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveHelper.maxContentWidth(context),
                      ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          // Title card
                          CustomCard(
                            withGlow: isDark,
                            child: Center(
                            child: Text(
                              "STUDENT'S PERFORMANCE",
                              style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    16,
                                  ),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                  color: ThemeHelper.getTextColor(context),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 16),
                        ),

                          if (_classrooms.isNotEmpty)
                            Column(
                          children: [
                                _buildClassroomFilter(context),
                                SizedBox(
                                  height: ResponsiveHelper.spacing(context, 12),
                                ),
                              ],
                            ),

                          // Quarter selector
                          CustomCard(
                            child: Row(
                              children: [
                                Text(
                              'Quarter:',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    color: ThemeHelper.getTextColor(context),
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.spacing(context, 8),
                                ),
                                Expanded(
                                  child: DropdownButton<String>(
                              value: _selectedQuarter,
                                    isExpanded: true,
                                    dropdownColor: ThemeHelper.getCardColor(
                                      context,
                                    ),
                                    style: TextStyle(
                                      color: ThemeHelper.getTextColor(context),
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        14,
                                      ),
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
                                });
                              },
                                  ),
                            ),
                          ],
                        ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 12),
                          ),

                        // Always render charts for all quizzes in this quarter
                        ..._buildAllChartsForQuarter(),
                      ],
                      ),
                    ),
                  ),
                ),
            ],
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

  List<Widget> _buildAllChartsForQuarter() {
    final isDark = ThemeHelper.isDarkMode(context);
    final quizIds = _getAllQuizIdsForQuarter(_selectedQuarter);

    return List<Widget>.generate(quizIds.length, (index) {
      final quizId = quizIds[index];
      final stats = _computePassFail(_selectedQuarter, quizId);
      final passed = stats['passed'] as int;
      final failed = stats['failed'] as int;
      final passedPct = stats['passedPct'] as double;
      final failedPct = stats['failedPct'] as double;
      final hasData = (passed + failed) > 0;

      // Theme-aware colors
      final passedColor = isDark
          ? ThemeHelper.getButtonGreen(context)
          : Colors.cyan;
      final failedColor = ThemeHelper.getErrorColor(context);

      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(context, 16)),
        child: CustomCard(
          withGlow: isDark,
        child: Column(
          children: [
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: failedColor, label: 'FAILED'),
                  SizedBox(
                    width: ResponsiveHelper.isSmallMobile(context)
                        ? ResponsiveHelper.spacing(context, 8)
                        : ResponsiveHelper.spacing(context, 16),
                  ),
                  _LegendDot(color: passedColor, label: 'PASSED'),
              ],
            ),
              SizedBox(height: ResponsiveHelper.spacing(context, 12)),
            SizedBox(
                height: ResponsiveHelper.isSmallMobile(context)
                    ? ResponsiveHelper.height(context, 180)
                    : ResponsiveHelper.height(context, 220),
              child: _PieChart(
                passedFraction: (passed + failed) == 0
                    ? 0.0
                    : passed / (passed + failed),
                  passedColor: passedColor,
                  failedColor: failedColor,
                hasData: hasData,
                  noDataColor: isDark
                      ? ThemeHelper.getDividerColor(context)
                      : const Color(0xFFE0E0E0),
                  noDataInnerColor: isDark
                      ? ThemeHelper.getCardColor(context)
                      : Colors.white,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Padding(
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: ResponsiveHelper.isSmallMobile(context) ? 12 : 24,
                ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'PASSED ${passedPct.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        fontWeight: FontWeight.w600,
                          color: ThemeHelper.getTextColor(context),
                      ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'FAILED ${failedPct.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        fontWeight: FontWeight.w600,
                          color: ThemeHelper.getTextColor(context),
                      ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
              SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Text(
              'QUIZ ${index + 1}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 16),
                  fontWeight: FontWeight.w700,
                  color: ThemeHelper.getTextColor(context),
                ),
            ),
          ],
          ),
        ),
      );
    });
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Row(
      children: [
        Container(
          width: ResponsiveHelper.width(context, 10),
          height: ResponsiveHelper.height(context, 10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isDark
                ? ThemeHelper.getGlow(context, color: color, blur: 4)
                : null,
          ),
        ),
        SizedBox(width: ResponsiveHelper.spacing(context, 6)),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 12),
            color: ThemeHelper.getTextColor(context),
          ),
        ),
      ],
    );
  }
}

class _PieChart extends StatelessWidget {
  final double passedFraction; // 0..1
  final Color passedColor;
  final Color failedColor;
  final bool hasData;
  final Color noDataColor;
  final Color noDataInnerColor;

  const _PieChart({
    required this.passedFraction,
    required this.passedColor,
    required this.failedColor,
    required this.hasData,
    required this.noDataColor,
    required this.noDataInnerColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PiePainter(
        passedFraction: passedFraction,
        passedColor: passedColor,
        failedColor: failedColor,
        hasData: hasData,
        noDataColor: noDataColor,
        noDataInnerColor: noDataInnerColor,
      ),
      child: Container(),
    );
  }
}

class _PiePainter extends CustomPainter {
  final double passedFraction;
  final Color passedColor;
  final Color failedColor;
  final bool hasData;
  final Color noDataColor;
  final Color noDataInnerColor;

  _PiePainter({
    required this.passedFraction,
    required this.passedColor,
    required this.failedColor,
    required this.hasData,
    required this.noDataColor,
    required this.noDataInnerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2 - 8;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    if (!hasData) {
      // Draw an empty placeholder doughnut to indicate no data yet
      paint.color = noDataColor;
      canvas.drawCircle(center, radius, paint);
      final innerPaint = Paint()..color = noDataInnerColor;
      canvas.drawCircle(center, radius - 14, innerPaint);
      return;
    }

    // Failed slice
    final failedFraction = (1.0 - passedFraction).clamp(0.0, 1.0);
    paint.color = failedColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * failedFraction,
      true,
      paint,
    );

    // Passed slice on top
    paint.color = passedColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + 2 * math.pi * failedFraction,
      2 * math.pi * passedFraction,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
