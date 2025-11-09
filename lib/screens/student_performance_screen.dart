import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class StudentPerformanceScreen extends StatefulWidget {
  const StudentPerformanceScreen({super.key});

  @override
  State<StudentPerformanceScreen> createState() =>
      _StudentPerformanceScreenState();
}

class _StudentPerformanceScreenState extends State<StudentPerformanceScreen> {
  List<UserModel> _students = [];
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

    // Load students in teacher's classroom
    final usersBox = DatabaseService.getUsersBox();
    _students = usersBox.values
        .where(
          (u) => u.role == 'student' && u.classroomCode == user.classroomCode,
        )
        .toList();

    // Build quizId list for the initial quarter (from attempts, for has-data check)
    // (No need to store in a variable since we get it dynamically now)

    setState(() {
      _loading = false;
    });
  }

  // Dynamic method to get quiz definitions (mirrors quiz_selection_screen.dart)
  List<Map<String, String>> _getQuizzesForQuarter(int quarter) {
    switch (quarter) {
      case 1:
        return [
          {'id': '1', 'title': 'Introduction to Variables'},
          {'id': '2', 'title': 'Expressions and Operations'},
          {'id': '3', 'title': 'Order of Operations'},
          {'id': '4', 'title': 'Simplifying Expressions'},
          {'id': '5', 'title': 'Evaluating Expressions'},
          {'id': '6', 'title': 'Properties of Real Numbers'},
        ];
      case 2:
        return [
          {'id': '1', 'title': 'One-Step Equations'},
          {'id': '2', 'title': 'Two-Step Equations'},
          {'id': '3', 'title': 'Multi-Step Equations'},
          {'id': '4', 'title': 'Equations with Variables'},
          {'id': '5', 'title': 'Word Problems Part 1'},
          {'id': '6', 'title': 'Translating Phrases'},
          {'id': '7', 'title': 'Linear Functions'},
        ];
      case 3:
        return [
          {'id': '1', 'title': 'Factoring Polynomials'},
          {'id': '2', 'title': 'Quadratic Equations'},
          {'id': '3', 'title': 'Solving Quadratics'},
          {'id': '4', 'title': 'Quadratic Formula'},
          {'id': '5', 'title': 'Systems of Equations'},
          {'id': '6', 'title': 'Graphing Linear Inequalities'},
        ];
      case 4:
        return [
          {'id': '1', 'title': 'Rational Expressions'},
          {'id': '2', 'title': 'Radical Equations'},
          {'id': '3', 'title': 'Exponential Functions'},
          {'id': '4', 'title': 'Polynomial Operations'},
          {'id': '5', 'title': 'Advanced Word Problems'},
          {'id': '6', 'title': 'Function Notation'},
          {'id': '7', 'title': 'Algebra Review'},
        ];
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
      case '3rd Quarter':
        return '3';
      case '4th Quarter':
        return '4';
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100]!, Colors.grey[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6BBF59), Color(0xFF5AA849)],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Color(0xFF6BBF59),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'MathQuest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              if (_loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title chip
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4EDD0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              "STUDENT'S PERFORMANCE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Quarter selector
                        Row(
                          children: [
                            const Text(
                              'Quarter:',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: _selectedQuarter,
                              items: const [
                                DropdownMenuItem(
                                  value: '1st Quarter',
                                  child: Text('1st Quarter'),
                                ),
                                DropdownMenuItem(
                                  value: '2nd Quarter',
                                  child: Text('2nd Quarter'),
                                ),
                                DropdownMenuItem(
                                  value: '3rd Quarter',
                                  child: Text('3rd Quarter'),
                                ),
                                DropdownMenuItem(
                                  value: '4th Quarter',
                                  child: Text('4th Quarter'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() {
                                  _selectedQuarter = v;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Always render charts for all quizzes in this quarter
                        ..._buildAllChartsForQuarter(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAllChartsForQuarter() {
    final quizIds = _getAllQuizIdsForQuarter(_selectedQuarter);
    return List<Widget>.generate(quizIds.length, (index) {
      final quizId = quizIds[index];
      final stats = _computePassFail(_selectedQuarter, quizId);
      final passed = stats['passed'] as int;
      final failed = stats['failed'] as int;
      final passedPct = stats['passedPct'] as double;
      final failedPct = stats['failedPct'] as double;
      final hasData = (passed + failed) > 0;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5DC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          children: [
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LegendDot(color: Colors.red, label: 'FAILED'),
                SizedBox(width: 16),
                _LegendDot(color: Colors.cyan, label: 'PASSED'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: _PieChart(
                passedFraction: (passed + failed) == 0
                    ? 0.0
                    : passed / (passed + failed),
                passedColor: Colors.cyan,
                failedColor: Colors.red,
                hasData: hasData,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'PASSED ${passedPct.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'FAILED ${failedPct.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'QUIZ ${index + 1}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    });
  }

  // Deprecated single-card builder removed
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _PieChart extends StatelessWidget {
  final double passedFraction; // 0..1
  final Color passedColor;
  final Color failedColor;
  final bool hasData;
  const _PieChart({
    required this.passedFraction,
    required this.passedColor,
    required this.failedColor,
    required this.hasData,
  });
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PiePainter(
        passedFraction: passedFraction,
        passedColor: passedColor,
        failedColor: failedColor,
        hasData: hasData,
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
  _PiePainter({
    required this.passedFraction,
    required this.passedColor,
    required this.failedColor,
    required this.hasData,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2 - 8;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    if (!hasData) {
      // Draw an empty placeholder doughnut to indicate no data yet
      paint.color = const Color(0xFFE0E0E0);
      canvas.drawCircle(center, radius, paint);
      final innerPaint = Paint()..color = Colors.white;
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
