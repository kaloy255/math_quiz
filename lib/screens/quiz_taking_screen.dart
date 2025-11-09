import 'dart:async';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/theme_helper.dart';

class QuizTakingScreen extends StatefulWidget {
  final String quizTitle;
  final String quarter;
  final String quizId;

  const QuizTakingScreen({
    super.key,
    required this.quizTitle,
    required this.quarter,
    required this.quizId,
  });

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  int _currentQuestionIndex = 0;
  Map<int, String> _selectedAnswers = {};
  bool _quizCompleted = false;
  int? _xpEarned;
  String _badgeEarned = '';
  bool _showReview = false;
  int _timeSpent = 0; // Time spent in seconds

  // Timer state
  int _timeRemaining = 0; // in seconds
  Timer? _timer;
  bool _timeUp = false;
  DateTime? _quizStartTime;

  // Static sample questions for each quiz
  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _getQuestionsForQuiz(widget.quizId);
    _timeRemaining = _getTimeLimitForQuiz(widget.quizId);
    _quizStartTime = DateTime.now(); // Track when quiz started
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_timeRemaining > 0 && !_quizCompleted) {
          _timeRemaining--;
        } else if (_timeRemaining == 0 && !_quizCompleted) {
          _timeUp = true;
          timer.cancel();
          _autoSubmitQuiz();
        }
      });
    });
  }

  Future<void> _autoSubmitQuiz() async {
    if (_quizCompleted) return;

    // Save results before showing completion
    await _saveQuizResults();

    setState(() {
      _quizCompleted = true;
    });
  }

  int _getTimeLimitForQuiz(String quizId) {
    // Different time limits for different quizzes
    switch (quizId) {
      case '1':
        return 480; // 8 minutes - Introduction level
      case '2':
        return 600; // 10 minutes - Basic concepts
      case '3':
        return 540; // 9 minutes - Operations
      case '4':
        return 660; // 11 minutes - Medium difficulty
      case '5':
        return 600; // 10 minutes - Evaluation
      case '6':
        return 720; // 12 minutes - Advanced
      case '7':
        return 780; // 13 minutes - Complex/Review
      default:
        return 600; // 10 minutes default
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatTimeSpent(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    } else {
      return '${remainingSeconds}s';
    }
  }

  List<Map<String, dynamic>> _getQuestionsForQuiz(String quizId) {
    // Return sample questions based on quiz ID and quarter
    // Questions vary by quarter and quiz topic

    // Create unique questions based on quarter and quiz ID
    final quarter = int.tryParse(widget.quarter) ?? 1;
    final quizNum = int.tryParse(quizId) ?? 1;

    // Generate unique questions for each quiz by combining quarter + quiz ID
    final uniqueKey = '$quarter-$quizNum';

    return _getQuestionsByKey(uniqueKey);
  }

  List<Map<String, dynamic>> _getQuestionsByKey(String uniqueKey) {
    // Generate unique questions based on the key (quarter-quizId combination)
    final hash = uniqueKey.hashCode.abs() % 1000;

    // Comprehensive question pools with varied algebra topics

    final allSimplifyQuestions = [
      {
        'q': 'Simplify: 3x + 5x',
        'o': ['8x', '15x', '8x²', 'x'],
        'a': '8x',
      },
      {
        'q': 'Simplify: 7x - 3x',
        'o': ['4x', '21x', '4x²', 'x'],
        'a': '4x',
      },
      {
        'q': 'Combine like terms: 2x + 3y + 5x',
        'o': ['7x + 3y', '10xy', '7x²y', '7x + 5y'],
        'a': '7x + 3y',
      },
      {
        'q': 'Simplify: 4a + 2a - a',
        'o': ['5a', '6a', '7a', '3a'],
        'a': '5a',
      },
      {
        'q': 'Simplify: -2x + 8x',
        'o': ['6x', '-6x', '10x', '16x'],
        'a': '6x',
      },
      {
        'q': 'Combine: 3m + 2m + 5m',
        'o': ['10m', '30m', '10m²', 'm'],
        'a': '10m',
      },
      {
        'q': 'Simplify: 6x + 4 - 2x',
        'o': ['4x + 4', '8x', '4x - 4', '12x'],
        'a': '4x + 4',
      },
      {
        'q': 'Simplify: 9y - 5y + y',
        'o': ['5y', '4y', '14y', '3y'],
        'a': '5y',
      },
    ];

    final allTFQuestions = [
      {'q': 'A variable is always represented by a letter.', 'a': 'True'},
      {'q': 'The expression 3x + 5 has exactly 3 terms.', 'a': 'False'},
      {'q': 'In 4x², the coefficient is 4 and the exponent is 2.', 'a': 'True'},
      {'q': 'All polynomials must have a constant term.', 'a': 'False'},
      {'q': 'Like terms have the same variable and exponent.', 'a': 'True'},
      {'q': 'The commutative property applies to subtraction.', 'a': 'False'},
      {'q': 'A monomial has exactly one term.', 'a': 'True'},
      {'q': 'The expression x/3 is a polynomial.', 'a': 'False'},
    ];

    final allExpandQuestions = [
      {
        'q': 'Expand: 2(3x + 4)',
        'o': ['6x + 8', '6x + 4', '5x + 8', '6x² + 8'],
        'a': '6x + 8',
      },
      {
        'q': 'Expand: 3(x - 5)',
        'o': ['3x - 15', '3x - 5', '3x + 15', 'x - 15'],
        'a': '3x - 15',
      },
      {
        'q': 'Expand: -2(4x + 3)',
        'o': ['-8x - 6', '-8x + 6', '8x - 6', '-8x + 3'],
        'a': '-8x - 6',
      },
      {
        'q': 'Expand: 5(2a - 3)',
        'o': ['10a - 15', '10a - 3', '7a - 15', '10a + 15'],
        'a': '10a - 15',
      },
      {
        'q': 'Expand: 4(3m + 2)',
        'o': ['12m + 8', '12m + 2', '7m + 8', '12m² + 8'],
        'a': '12m + 8',
      },
      {
        'q': 'Expand: -3(x - 4)',
        'o': ['-3x + 12', '-3x - 12', '3x - 12', '-3x + 4'],
        'a': '-3x + 12',
      },
      {
        'q': 'Expand: 2(5y - 1)',
        'o': ['10y - 2', '10y - 1', '7y - 2', '10y + 2'],
        'a': '10y - 2',
      },
      {
        'q': 'Expand: 6(a + b)',
        'o': ['6a + 6b', '6ab', 'a + 6b', '6a + b'],
        'a': '6a + 6b',
      },
    ];

    final allSolveQuestions = [
      {
        'q': 'Solve: x + 7 = 15',
        'o': ['x = 8', 'x = 22', 'x = -8', 'x = 7'],
        'a': 'x = 8',
      },
      {
        'q': 'Solve: 5x = 25',
        'o': ['x = 5', 'x = 20', 'x = 125', 'x = 30'],
        'a': 'x = 5',
      },
      {
        'q': 'Solve: x - 12 = 8',
        'o': ['x = 20', 'x = 4', 'x = -4', 'x = -20'],
        'a': 'x = 20',
      },
      {
        'q': 'Solve: 3x = 21',
        'o': ['x = 7', 'x = 18', 'x = 24', 'x = 63'],
        'a': 'x = 7',
      },
      {
        'q': 'Solve: x + 9 = 14',
        'o': ['x = 5', 'x = 23', 'x = -5', 'x = 14'],
        'a': 'x = 5',
      },
      {
        'q': 'Solve: 4x = 28',
        'o': ['x = 7', 'x = 24', 'x = 32', 'x = 112'],
        'a': 'x = 7',
      },
      {
        'q': 'Solve: x - 5 = 11',
        'o': ['x = 16', 'x = 6', 'x = -6', 'x = -16'],
        'a': 'x = 16',
      },
      {
        'q': 'Solve: 2x = 18',
        'o': ['x = 9', 'x = 16', 'x = 20', 'x = 36'],
        'a': 'x = 9',
      },
    ];

    final allTermsQuestions = [
      {'q': 'The expression 3x + 2y + 5 has three terms.', 'a': 'True'},
      {'q': 'The expression 7x has exactly one term.', 'a': 'True'},
      {'q': 'The expression 2x² + 3x + 1 has three terms.', 'a': 'True'},
      {'q': 'The expression 5a + 2b + 3c + 4 has four terms.', 'a': 'True'},
      {'q': 'The expression 9x + 11 is a monomial.', 'a': 'False'},
      {'q': 'The expression 3x has one term.', 'a': 'True'},
      {'q': 'Every algebraic expression has at least two terms.', 'a': 'False'},
      {
        'q': 'The expression 4x + 8 can be simplified to one term.',
        'a': 'True',
      },
    ];

    final allCoeffQuestions = [
      {
        'q': 'What is the coefficient of x in 5x + 3?',
        'o': ['5', '3', 'x', '8'],
        'a': '5',
      },
      {
        'q': 'What is the constant term in 7x + 9?',
        'o': ['9', '7', 'x', '16'],
        'a': '9',
      },
      {
        'q': 'What is the coefficient of y in 8y - 5?',
        'o': ['8', '-5', 'y', '3'],
        'a': '8',
      },
      {
        'q': 'What is the coefficient of x in -6x + 2?',
        'o': ['-6', '2', 'x', '-4'],
        'a': '-6',
      },
      {
        'q': 'What is the constant in 4a + 12?',
        'o': ['12', '4', 'a', '16'],
        'a': '12',
      },
      {
        'q': 'What is the coefficient of z in 9z - 7?',
        'o': ['9', '-7', 'z', '2'],
        'a': '9',
      },
      {
        'q': 'What is the constant term in 3x + 0?',
        'o': ['0', '3', 'x', '3x'],
        'a': '0',
      },
      {
        'q': 'What is the coefficient of x in x + 5?',
        'o': ['1', '5', 'x', '6'],
        'a': '1',
      },
    ];

    final allFinalQuestions = [
      {
        'q': 'Solve: 2x + 5 = 13',
        'o': ['x = 4', 'x = 8', 'x = 18', 'x = 26'],
        'a': 'x = 4',
      },
      {
        'q': 'Solve: 3x - 4 = 11',
        'o': ['x = 5', 'x = 7', 'x = 15', 'x = 9'],
        'a': 'x = 5',
      },
      {
        'q': 'Solve: x/3 = 4',
        'o': ['x = 12', 'x = 7', 'x = 1', 'x = 4'],
        'a': 'x = 12',
      },
      {
        'q': 'Solve: 4x + 3 = 19',
        'o': ['x = 4', 'x = 5', 'x = 16', 'x = 22'],
        'a': 'x = 4',
      },
      {
        'q': 'Solve: 2x - 6 = 8',
        'o': ['x = 7', 'x = 4', 'x = 14', 'x = 2'],
        'a': 'x = 7',
      },
      {
        'q': 'Solve: x + 8 = 17',
        'o': ['x = 9', 'x = 25', 'x = -9', 'x = 8'],
        'a': 'x = 9',
      },
      {
        'q': 'Solve: 5x + 2 = 22',
        'o': ['x = 4', 'x = 20', 'x = 24', 'x = 110'],
        'a': 'x = 4',
      },
      {
        'q': 'Solve: 3x + 7 = 16',
        'o': ['x = 3', 'x = 9', 'x = 23', 'x = 48'],
        'a': 'x = 3',
      },
    ];

    // Select different questions based on hash
    final q1 = allSimplifyQuestions[hash % allSimplifyQuestions.length];
    final q2 = allTFQuestions[(hash + 1) % allTFQuestions.length];
    final q3 = allExpandQuestions[(hash + 2) % allExpandQuestions.length];
    final q4 = allSolveQuestions[(hash + 3) % allSolveQuestions.length];
    final q5 = allTermsQuestions[(hash + 4) % allTermsQuestions.length];
    final q6 = allCoeffQuestions[(hash + 5) % allCoeffQuestions.length];
    final q7 = allFinalQuestions[(hash + 6) % allFinalQuestions.length];

    return [
      {
        'question': q1['q'],
        'type': 'multiple_choice',
        'options': q1['o'],
        'correctAnswer': q1['a'],
      },
      {
        'question': q2['q'],
        'type': 'true_false',
        'options': null,
        'correctAnswer': q2['a'],
      },
      {
        'question': q3['q'],
        'type': 'multiple_choice',
        'options': q3['o'],
        'correctAnswer': q3['a'],
      },
      {
        'question': q4['q'],
        'type': 'multiple_choice',
        'options': q4['o'],
        'correctAnswer': q4['a'],
      },
      {
        'question': q5['q'],
        'type': 'true_false',
        'options': null,
        'correctAnswer': q5['a'],
      },
      {
        'question': q6['q'],
        'type': 'multiple_choice',
        'options': q6['o'],
        'correctAnswer': q6['a'],
      },
      {
        'question': q7['q'],
        'type': 'multiple_choice',
        'options': q7['o'],
        'correctAnswer': q7['a'],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      body: Container(
        decoration: BoxDecoration(
          color: ThemeHelper.getContainerColor(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
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
                    Expanded(
                      child: Text(
                        _showReview ? 'Review Answers' : widget.quizTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!_showReview && !_quizCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _timeRemaining <= 60
                              ? Colors.red
                              : const Color(0xFF6BBF59),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime(_timeRemaining),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Question Counter
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6BBF59),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentQuestionIndex + 1}/${_questions.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              if (_quizCompleted)
                Expanded(
                  child: _showReview ? _buildReviewView() : _buildResultsView(),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildQuestionView(),
                  ),
                ),

              // Navigation Buttons
              if (!_quizCompleted)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentQuestionIndex > 0
                            ? _previousQuestion
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6BBF59),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: _submitQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6BBF59),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _currentQuestionIndex == _questions.length - 1
                              ? 'Submit Quiz'
                              : 'Next',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionView() {
    final question = _questions[_currentQuestionIndex];
    final selectedAnswer = _selectedAnswers[_currentQuestionIndex];
    final isTrueFalse = question['type'] == 'true_false';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (isTrueFalse) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6BBF59),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'TRUE or FALSE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Options or True/False Buttons
        Expanded(
          child: isTrueFalse
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTrueFalseButton('True', 'True', selectedAnswer),
                    const SizedBox(height: 16),
                    _buildTrueFalseButton('False', 'False', selectedAnswer),
                  ],
                )
              : ListView.builder(
                  itemCount: question['options'].length,
                  itemBuilder: (context, index) {
                    final option = question['options'][index];
                    final isSelected = selectedAnswer == option;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAnswers[_currentQuestionIndex] = option;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFD4EDD0)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF6BBF59)
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF6BBF59)
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF6BBF59),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseButton(
    String label,
    String value,
    String? selectedAnswer,
  ) {
    final isSelected = selectedAnswer == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAnswers[_currentQuestionIndex] = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4EDD0) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6BBF59) : Colors.grey[300]!,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF6BBF59) : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveQuizResults() async {
    if (_quizCompleted) return; // Already saved

    // Calculate time spent
    if (_quizStartTime != null) {
      final timeElapsed = DateTime.now().difference(_quizStartTime!);
      _timeSpent = timeElapsed.inSeconds;
    }

    int correctAnswers = 0;
    List<int> correctIndices = [];

    // Track which questions were answered correctly
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctAnswer']) {
        correctAnswers++;
        correctIndices.add(i); // Track the index of correct answers
      }
    }
    final score = (correctAnswers / _questions.length * 100).round();
    _badgeEarned = _getBadgeForScore(score);

    // Create unique quiz ID by combining quizId with quarter to track XP separately
    final uniqueQuizId = '${widget.quizId}-Q${widget.quarter}';

    // Save to database and get the XP earned (only for NEW correct answers)
    final xpEarned = await DatabaseService.saveQuizAttempt(
      quizId: uniqueQuizId, // Use unique ID per quarter
      quizTitle: widget.quizTitle,
      score: score,
      totalQuestions: _questions.length,
      correctAnswers: correctAnswers,
      quarter: widget.quarter,
      correctQuestionIndices: correctIndices,
    );

    // Set the XP earned for this attempt (only for newly correct answers)
    _xpEarned = xpEarned;
  }

  String _getBadgeForScore(int score) {
    if (score == 100) return 'Perfect Master';
    if (score >= 90) return 'Math Genius';
    if (score >= 80) return 'Excellent Student';
    if (score >= 70) return 'Good Learner';
    return '';
  }

  Widget _buildResultsView() {
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }
    final score = (correctAnswers / _questions.length * 100).round();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    score >= 70 ? '🎉 Great Job!' : 'Keep Learning!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: score >= 70
                          ? const Color(0xFFD4EDD0)
                          : const Color(0xFFFFD4D4),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        score >= 70 ? 'PASSED' : 'FAILED',
                        style: TextStyle(
                          fontSize: score >= 70 ? 20 : 22,
                          fontWeight: FontWeight.bold,
                          color: score >= 70
                              ? const Color(0xFF6BBF59)
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You got $correctAnswers out of ${_questions.length} correct!',
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  // Time Spent Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${_formatTimeSpent(_timeSpent)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_xpEarned != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4EDD0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars, color: Color(0xFF6BBF59)),
                          const SizedBox(width: 8),
                          Text(
                            '+$_xpEarned XP',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6BBF59),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex = 0;
                        _showReview = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Review Answers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6BBF59),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _questions[_currentQuestionIndex]['question'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...(_questions[_currentQuestionIndex]['type'] ==
                          'multiple_choice'
                      ? _questions[_currentQuestionIndex]['options']
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildReviewOption(
                                entry.value,
                                entry.key,
                                _currentQuestionIndex,
                              ),
                            )
                      : _buildReviewTrueFalse(_currentQuestionIndex)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentQuestionIndex > 0
                        ? () {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentQuestionIndex < _questions.length - 1
                        ? () {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showReview = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6BBF59),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Back to Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewOption(String option, int index, int questionIndex) {
    final question = _questions[questionIndex];
    final correctAnswer = question['correctAnswer'];
    final userAnswer = _selectedAnswers[questionIndex];
    final isCorrect = option == correctAnswer;
    final isUserAnswer = option == userAnswer;
    final isWrongAnswer = isUserAnswer && !isCorrect;
    final isUnanswered = userAnswer == null || userAnswer.isEmpty;

    Color bgColor = Colors.white;
    if (isCorrect) {
      bgColor = const Color(0xFFD4EDD0); // Green for correct
    } else if (isWrongAnswer) {
      bgColor = const Color(0xFFFFD4D4); // Red for wrong
    } else if (isUnanswered && isCorrect) {
      bgColor = const Color(
        0xFFD4EDD0,
      ); // Green for correct answer when unanswered
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF6BBF59)
              : isWrongAnswer
              ? Colors.red
              : Colors.grey[300]!,
          width: isCorrect || isWrongAnswer ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF6BBF59)
                  : isWrongAnswer
                  ? Colors.red
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCorrect
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : isWrongAnswer
                  ? const Icon(Icons.close, color: Colors.white, size: 20)
                  : Text(
                      String.fromCharCode(65 + index),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCorrect || isWrongAnswer
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
          if (isUserAnswer && !isCorrect)
            const Icon(Icons.error, color: Colors.red, size: 24),
          if (isCorrect && isUserAnswer)
            const Icon(Icons.check_circle, color: Color(0xFF6BBF59), size: 24),
          if (isCorrect && !isUserAnswer && !isWrongAnswer)
            const Icon(Icons.check_circle, color: Color(0xFF6BBF59), size: 24),
        ],
      ),
    );
  }

  List<Widget> _buildReviewTrueFalse(int questionIndex) {
    final question = _questions[questionIndex];
    final correctAnswer = question['correctAnswer'];
    final userAnswer = _selectedAnswers[questionIndex];
    final isUnanswered = userAnswer == null || userAnswer.isEmpty;

    return [
      _buildTrueFalseReviewButton(
        'True',
        'True',
        questionIndex,
        correctAnswer,
        userAnswer,
        isUnanswered,
      ),
      const SizedBox(height: 12),
      _buildTrueFalseReviewButton(
        'False',
        'False',
        questionIndex,
        correctAnswer,
        userAnswer,
        isUnanswered,
      ),
    ];
  }

  Widget _buildTrueFalseReviewButton(
    String label,
    String value,
    int questionIndex,
    String correctAnswer,
    String? userAnswer,
    bool isUnanswered,
  ) {
    final isCorrect = value == correctAnswer;
    final isUserAnswer = value == userAnswer;
    final isWrongAnswer = isUserAnswer && !isCorrect;

    Color bgColor = Colors.white;
    if (isCorrect) {
      bgColor = const Color(0xFFD4EDD0);
    } else if (isWrongAnswer) {
      bgColor = const Color(0xFFFFD4D4);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF6BBF59)
              : isWrongAnswer
              ? Colors.red
              : Colors.grey[300]!,
          width: isCorrect || isWrongAnswer ? 3 : 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isCorrect
                  ? const Color(0xFF6BBF59)
                  : isWrongAnswer
                  ? Colors.red
                  : Colors.black87,
            ),
          ),
          if (isCorrect) const SizedBox(width: 8),
          if (isCorrect)
            const Icon(Icons.check_circle, color: Color(0xFF6BBF59)),
          if (isWrongAnswer) const SizedBox(width: 8),
          if (isWrongAnswer) const Icon(Icons.error, color: Colors.red),
        ],
      ),
    );
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }

  void _submitQuiz() async {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Save results before showing completion
      await _saveQuizResults();

      setState(() {
        _quizCompleted = true;
      });
    }
  }
}
