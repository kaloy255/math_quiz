import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../widgets/app_bar_widget.dart';

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

    _currentTeacher = user;

    // Load students in teacher's classroom
    final usersBox = DatabaseService.getUsersBox();
    _students =
        usersBox.values
            .where(
              (u) =>
                  u.role == 'student' && u.classroomCode == user.classroomCode,
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      _loading = false;
    });
  }

  // Get quiz definitions dynamically (matches student_performance_screen.dart)
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
    if (_loading) {
      return Scaffold(
        appBar: const MathQuestAppBar(showBackButton: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final quarterNum = int.tryParse(_getQuarterNumber(_selectedQuarter)) ?? 1;
    final availableQuizzes = _getQuizzesForQuarter(quarterNum);

    return Scaffold(
      appBar: const MathQuestAppBar(showBackButton: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100]!, Colors.grey[50]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4EDD0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'CHECK SCORES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Quarter Selection
                const Text(
                  'QUARTER:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _selectedQuarter,
                  isExpanded: true,
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
                      _selectedQuizNumber =
                          1; // Reset to quiz 1 when quarter changes
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Quiz Number Selection
                const Text(
                  'QUIZ NUMBER:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Quiz Number Tabs
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableQuizzes.length,
                    itemBuilder: (context, index) {
                      final quizNum = index + 1;
                      final isSelected = _selectedQuizNumber == quizNum;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedQuizNumber = quizNum;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF6BBF59)
                                  : const Color(0xFFD4EDD0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$quizNum',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Grade & Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!, width: 1),
                  ),
                  child: Text(
                    'Grade & Section: ${_currentTeacher?.classroomCode ?? "N/A"}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Scores Table
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'NAME',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'SCORE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
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

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        student.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        scoreData != null
                                            ? '${scoreData['correctAnswers']}/${scoreData['totalQuestions']}'
                                            : 'No attempt',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: scoreData != null
                                              ? (scoreData['score'] >= 70
                                                    ? Colors.green[700]
                                                    : Colors.red[700])
                                              : Colors.grey[600],
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
    );
  }
}
