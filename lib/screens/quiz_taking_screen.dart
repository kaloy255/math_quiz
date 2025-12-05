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
  bool _showReview = false;
  int _timeSpent = 0; // Time spent in seconds

  // Timer state
  int _timeRemaining = 0; // in seconds
  Timer? _timer;
  DateTime? _quizStartTime;
  final Map<int, TextEditingController> _identificationControllers = {};

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
    for (final controller in _identificationControllers.values) {
      controller.dispose();
    }
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
    if (uniqueKey == '1-1') {
      return _getQuarter1Quiz1Questions();
    }
    if (uniqueKey == '1-2') {
      return _getQuarter1Quiz2Questions();
    }
    if (uniqueKey == '1-3') {
      return _getQuarter1Quiz3Questions();
    }
    if (uniqueKey == '1-4') {
      return _getQuarter1Quiz4Questions();
    }
    if (uniqueKey == '1-5') {
      return _getQuarter1Quiz5Questions();
    }
    if (uniqueKey == '1-6') {
      return _getQuarter1Quiz6Questions();
    }
    if (uniqueKey == '1-7') {
      return _getQuarter1Quiz7Questions();
    }
    if (uniqueKey == '1-8') {
      return _getQuarter1Quiz8Questions();
    }
    if (uniqueKey == '1-9') {
      return _getQuarter1Quiz9Questions();
    }
    if (uniqueKey == '2-1') {
      return _getQuarter2Quiz1Questions();
    }
    if (uniqueKey == '2-2') {
      return _getQuarter2Quiz2Questions();
    }
    if (uniqueKey == '2-3') {
      return _getQuarter2Quiz3Questions();
    }
    if (uniqueKey == '2-4') {
      return _getQuarter2Quiz4Questions();
    }
    if (uniqueKey == '2-5') {
      return _getQuarter2Quiz5Questions();
    }
    if (uniqueKey == '2-6') {
      return _getQuarter2Quiz6Questions();
    }
    if (uniqueKey == '2-7') {
      return _getQuarter2Quiz7Questions();
    }
    if (uniqueKey == '2-8') {
      return _getQuarter2Quiz8Questions();
    }
    if (uniqueKey == '2-9') {
      return _getQuarter2Quiz9Questions();
    }
    // Quarter 3 - Empty quizzes
    if (uniqueKey.startsWith('3-')) {
      return [];
    }
    // Quarter 4 - Empty quizzes
    if (uniqueKey.startsWith('4-')) {
      return [];
    }

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

  List<Map<String, dynamic>> _getQuarter1Quiz1Questions() {
    // Quiz items sourced from assets/quiz/quiz1.md
    final multipleChoice = [
      {
        'question': 'What is the standard form of a quadratic equation?',
        'type': 'multiple_choice',
        'options': [
          'ax + bx + c = 0',
          'ax^2 + bx + c = 0',
          'ax^3 + bx + c = 0',
          'x^2 + bx + c = 0',
        ],
        'correctAnswer': 'ax^2 + bx + c = 0',
      },
      {
        'question': 'Which of the following is NOT a quadratic equation?',
        'type': 'multiple_choice',
        'options': [
          '2x^2 + 3x - 5 = 0',
          'x^2 - 4 = 0',
          '5x + 7 = 0',
          '3x^2 - 9x = 0',
        ],
        'correctAnswer': '5x + 7 = 0',
      },
      {
        'question':
            'What is the value of the discriminant in the equation x^2 + 6x + 9 = 0?',
        'type': 'multiple_choice',
        'options': ['0', '9', '12', '36'],
        'correctAnswer': '0',
      },
      {
        'question': 'What are the roots of the equation x^2 - 9 = 0?',
        'type': 'multiple_choice',
        'options': ['3 and -3', '9 and -9', '0 and 9', '-9 and 0'],
        'correctAnswer': '3 and -3',
      },
      {
        'question': 'If x^2 - 7x + 10 = 0, what are the values of x?',
        'type': 'multiple_choice',
        'options': ['2 and 5', '-2 and -5', '10 and -7', '3 and 4'],
        'correctAnswer': '2 and 5',
      },
    ];

    final trueFalse = [
      {
        'question': 'A quadratic equation has a degree of 2.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The quadratic formula is (-b ± sqrt(b^2 - 4ac)) / (2a).',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'The discriminant tells us the number of real solutions of a quadratic equation.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'If the discriminant is negative, the equation has two real and equal roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'Factoring is one method of solving quadratic equations.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'Completing the square cannot be used to solve quadratic equations.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'If the discriminant equals zero, the quadratic has no real roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'The graph of a quadratic equation is called a parabola.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The axis of symmetry of y = x^2 + 4x + 3 is x = -2.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'In x^2 + 5x + 6 = 0, the sum of the roots is equal to -5.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question':
            'What do you call the highest power of the variable in a quadratic equation?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Degree',
      },
      {
        'question': 'What is the shape of the graph of a quadratic function?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Parabola',
      },
      {
        'question':
            'What do you call the method of solving quadratic equations using a formula?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Quadratic Formula',
      },
      {
        'question':
            'In the equation x^2 - 4x - 5 = 0, what is the product of the roots?',
        'type': 'identification',
        'options': null,
        'correctAnswer': '-5',
      },
      {
        'question':
            'In the equation x^2 + 3x + 2 = 0, what is the sum of the roots?',
        'type': 'identification',
        'options': null,
        'correctAnswer': '-3',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz2Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz2.md
    final multipleChoice = [
      {
        'question': 'What is the nature of roots if discriminant = 0?',
        'type': 'multiple_choice',
        'options': [
          'Real, rational, and equal',
          'Real, irrational, and unequal',
          'No real roots',
          'Real and unequal',
        ],
        'correctAnswer': 'Real, rational, and equal',
      },
      {
        'question': 'What is the value of the discriminant?',
        'type': 'multiple_choice',
        'options': ['b^2 - 4ac', 'b^2 + 4ac', '2b - 4ac', 'b - 4ac'],
        'correctAnswer': 'b^2 - 4ac',
      },
      {
        'question': 'What is the nature of roots of x^2 - 5x + 12 = 0?',
        'type': 'multiple_choice',
        'options': [
          'Not real',
          'Real and equal',
          'Real and unequal',
          'Rational and equal',
        ],
        'correctAnswer': 'Not real',
      },
      {
        'question': 'What is the expression b^2 - 4ac called?',
        'type': 'multiple_choice',
        'options': [
          'Discriminant',
          'Quadratic formula',
          'Sum of roots',
          'Product of roots',
        ],
        'correctAnswer': 'Discriminant',
      },
      {
        'question': 'Which equation has no real roots?',
        'type': 'multiple_choice',
        'options': [
          '-2r^2 + r + 7 = 0',
          'x^2 - 4 = 0',
          'x^2 + 4x + 4 = 0',
          'x^2 - 9 = 0',
        ],
        'correctAnswer': '-2r^2 + r + 7 = 0',
      },
    ];

    final trueFalse = [
      {
        'question': 'Discriminant helps determine nature of roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'If discriminant > 0 and perfect square, roots are irrational.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'If discriminant < 0, equation has no real roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Sum of roots of x^2 + 6x - 14 = 0 is -6.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Product of roots of x^2 + 6x - 14 = 0 is -14.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Equation x^2 + 4x + 4 = 0 has two equal real roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Formula for sum of roots is -b/a.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Formula for product of roots is c/a.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'If discriminant > 0 but not perfect square, roots are rational.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'Equation x^2 - 2x - 3 = 0 has sum of roots = -2.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'What is the expression b^2 - 4ac?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Discriminant',
      },
      {
        'question': 'What is the formula for sum of roots?',
        'type': 'identification',
        'options': null,
        'correctAnswer': '-b/a',
      },
      {
        'question': 'What is the formula for product of roots?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'c/a',
      },
      {
        'question': 'What is the nature of roots if discriminant < 0?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'No real roots',
      },
      {
        'question':
            'What is the nature of roots if discriminant > 0 and perfect square?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Rational and unequal',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz3Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz3.md
    final multipleChoice = [
      {
        'question': 'What is the standard form of x(x + 3) = 4?',
        'type': 'multiple_choice',
        'options': [
          'x^2 + 3x - 4 = 0',
          'x^2 + 3x + 4 = 0',
          'x^2 - 3x - 4 = 0',
          'x^2 - 3x + 4 = 0',
        ],
        'correctAnswer': 'x^2 + 3x - 4 = 0',
      },
      {
        'question': 'What are the roots of x^2 = 9?',
        'type': 'multiple_choice',
        'options': ['±3', '3 and -3', '9 and -9', '3 only'],
        'correctAnswer': '±3',
      },
      {
        'question': 'What is the standard form of (x - 6)^2 + (x + 7)^2 = 97?',
        'type': 'multiple_choice',
        'options': [
          '2x^2 + 2x + 85 = 0',
          '2x^2 - 2x + 85 = 0',
          'x^2 + 2x + 85 = 0',
          '2x^2 + 2x - 85 = 0',
        ],
        'correctAnswer': '2x^2 + 2x + 85 = 0',
      },
      {
        'question': 'What is the correct method to solve x^2 - 9 = 0?',
        'type': 'multiple_choice',
        'options': [
          'Extracting the root',
          'Factoring',
          'Quadratic formula',
          'Completing the square',
        ],
        'correctAnswer': 'Extracting the root',
      },
      {
        'question': 'What is the LCD for 4/x + x/2 = 3?',
        'type': 'multiple_choice',
        'options': ['2x', 'x', '2', '4x'],
        'correctAnswer': '2x',
      },
    ];

    final trueFalse = [
      {
        'question': 'x^2 = 36 can be changed into quadratic.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '(x + 2)^2 = 9 can be solved by factoring.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Rational algebraic equations always have real roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': '(x - 5)^2 + (x + 6)^2 = 20 involves square of binomials.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Quadratic formula can be used for any quadratic.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'x^2 + 4x + 4 = 0 has two distinct real roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'LCD removes fractions in rational equations.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'If discriminant is negative, no real roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '3x - 20 = 0 is quadratic.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'Extraneous root = solution not satisfying original equation.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question':
            'What is the method to remove denominators in rational equations?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Least Common Denominator',
      },
      {
        'question': 'What is the expression b^2 - 4ac?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Discriminant',
      },
      {
        'question': 'What is the formula -b/a?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Sum of the roots',
      },
      {
        'question': 'What is the formula c/a?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Product of the roots',
      },
      {
        'question':
            'What is the nature of roots if discriminant > 0 but not perfect square?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Irrational and unequal',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz4Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz4.md
    final multipleChoice = [
      {
        'question': 'What is the standard form of x(x + 2) = 24?',
        'type': 'multiple_choice',
        'options': [
          'x^2 + 2x - 24 = 0',
          'x^2 + 2x + 24 = 0',
          'x^2 - 2x - 24 = 0',
          'x^2 - 2x + 24 = 0',
        ],
        'correctAnswer': 'x^2 + 2x - 24 = 0',
      },
      {
        'question': 'What are the roots of x^2 = 49?',
        'type': 'multiple_choice',
        'options': ['±7', '7 and -7', '49 and -49', '7 only'],
        'correctAnswer': '±7',
      },
      {
        'question': 'What is the standard form of x(x + 5) = 50?',
        'type': 'multiple_choice',
        'options': [
          'x^2 + 5x - 50 = 0',
          'x^2 + 5x + 50 = 0',
          'x^2 - 5x - 50 = 0',
          'x^2 - 5x + 50 = 0',
        ],
        'correctAnswer': 'x^2 + 5x - 50 = 0',
      },
      {
        'question': 'What is the correct method to solve x^2 + 5x - 50 = 0?',
        'type': 'multiple_choice',
        'options': [
          'Factoring',
          'Extracting the root',
          'Quadratic formula',
          'Completing the square',
        ],
        'correctAnswer': 'Factoring',
      },
      {
        'question': 'What is the LCD for 3/x + 3/(x + 4) = 2?',
        'type': 'multiple_choice',
        'options': ['x(x + 4)', 'x', 'x + 4', '3x'],
        'correctAnswer': 'x(x + 4)',
      },
    ];

    final trueFalse = [
      {
        'question': 'x(x + 5) = 50 is quadratic.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'x^2 + 5x - 50 = 0 can be solved by factoring.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Rational equations always have two real solutions.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'x^2 + x = 42 involves quadratic expression.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'Quadratic formula can be used even if factoring is possible.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'x^2 + 4x + 4 = 0 has equal roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'LCD helps simplify rational equations.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'If discriminant = 0, two unequal roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'x + x^2 = 42 is not quadratic.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'Negative root can be rejected in age problems.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'What is the step-by-step word problem method?',
        'type': 'identification',
        'options': null,
        'correctAnswer': "Polya's method",
      },
      {
        'question': 'What is the expression to determine number/type of roots?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Discriminant',
      },
      {
        'question': 'What is the formula to solve any quadratic?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Quadratic formula',
      },
      {
        'question':
            'What is the process of changing rational equation into quadratic?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Transformation',
      },
      {
        'question': 'What is the nature of roots if discriminant = 0?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Real and equal',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz5Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz5.md
    final multipleChoice = [
      {
        'question': 'What is a quadratic equation?',
        'type': 'multiple_choice',
        'options': [
          'Variable raised to power of 2',
          'Variable raised to power of 3',
          'Variable raised to power of 1',
          'No variable',
        ],
        'correctAnswer': 'Variable raised to power of 2',
      },
      {
        'question': 'What is an example of standard form?',
        'type': 'multiple_choice',
        'options': ['x^2 + 5x + 6 = 0', 'x + 5 = 0', 'x^3 + 5x = 0', '5x = 0'],
        'correctAnswer': 'x^2 + 5x + 6 = 0',
      },
      {
        'question': 'What is the graph of a quadratic equation?',
        'type': 'multiple_choice',
        'options': ['Parabola', 'Line', 'Circle', 'Triangle'],
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'What is the highest exponent in a quadratic equation?',
        'type': 'multiple_choice',
        'options': ['2', '1', '3', '0'],
        'correctAnswer': '2',
      },
      {
        'question': 'What is a U-shaped curve?',
        'type': 'multiple_choice',
        'options': ['Parabola', 'Line', 'Circle', 'Ellipse'],
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'What is a real-life example of quadratic?',
        'type': 'multiple_choice',
        'options': [
          'Height of a thrown ball over time',
          'Distance at constant speed',
          'Number of days in a week',
          'Amount of water in a bottle',
        ],
        'correctAnswer': 'Height of a thrown ball over time',
      },
      {
        'question': 'What is the vertex of a parabola?',
        'type': 'multiple_choice',
        'options': [
          'Highest or lowest point',
          'Middle point',
          'Starting point',
          'Ending point',
        ],
        'correctAnswer': 'Highest or lowest point',
      },
      {
        'question': 'What is the quadratic formula?',
        'type': 'multiple_choice',
        'options': [
          'x = (-b ± √(b^2 - 4ac)) / 2a',
          'x = -b / 2a',
          'x = b^2 - 4ac',
          'x = a + b + c',
        ],
        'correctAnswer': 'x = (-b ± √(b^2 - 4ac)) / 2a',
      },
      {
        'question': 'What is the value under the square root?',
        'type': 'multiple_choice',
        'options': ['Discriminant', 'Sum', 'Product', 'Root'],
        'correctAnswer': 'Discriminant',
      },
      {
        'question': 'If discriminant < 0, what happens?',
        'type': 'multiple_choice',
        'options': [
          'No real roots',
          'Two real roots',
          'One real root',
          'Infinite roots',
        ],
        'correctAnswer': 'No real roots',
      },
    ];

    final trueFalse = [
      {
        'question': 'Quadratic equation always has degree 2.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Graph is always a straight line.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'Quadratic formula solves any quadratic.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Factoring finds roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Parabola can only open upward.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
    ];

    final identification = [
      {
        'question': 'What is the standard form?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'ax^2 + bx + c = 0',
      },
      {
        'question': 'What is the highest/lowest point?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Vertex',
      },
      {
        'question': 'What is the value under √ in formula?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Discriminant',
      },
      {
        'question': 'What is rewriting into perfect square?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Completing the square',
      },
      {
        'question': 'What is the curve formed?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Parabola',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz6Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz6.md
    final multipleChoice = [
      {
        'question': 'What is the standard form of a quadratic function?',
        'type': 'multiple_choice',
        'options': [
          'f(x) = ax^2 + bx + c',
          'f(x) = ax + b',
          'f(x) = ax^3 + bx + c',
          'f(x) = a',
        ],
        'correctAnswer': 'f(x) = ax^2 + bx + c',
      },
      {
        'question': 'Which is NOT a quadratic function?',
        'type': 'multiple_choice',
        'options': [
          'f(x) = 3x + 4',
          'f(x) = x^2 + 5x + 6',
          'f(x) = 2x^2 - 3x + 1',
          'f(x) = -x^2 + 4',
        ],
        'correctAnswer': 'f(x) = 3x + 4',
      },
      {
        'question': 'What is the graph of a quadratic function?',
        'type': 'multiple_choice',
        'options': ['Parabola', 'Line', 'Circle', 'Triangle'],
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'If a > 0, the parabola:',
        'type': 'multiple_choice',
        'options': [
          'Opens upward',
          'Opens downward',
          'Opens sideways',
          'Does not open',
        ],
        'correctAnswer': 'Opens upward',
      },
      {
        'question': 'What is a real-life example of quadratic function?',
        'type': 'multiple_choice',
        'options': [
          'Ball thrown in the air',
          'Car at constant speed',
          'Number of days',
          'Shape of a triangle',
        ],
        'correctAnswer': 'Ball thrown in the air',
      },
      {
        'question': 'What is the highest/lowest point?',
        'type': 'multiple_choice',
        'options': ['Vertex', 'Root', 'Axis', 'Intercept'],
        'correctAnswer': 'Vertex',
      },
      {
        'question': 'What is the vertical line dividing parabola?',
        'type': 'multiple_choice',
        'options': ['Axis of symmetry', 'Vertex', 'Root', 'Intercept'],
        'correctAnswer': 'Axis of symmetry',
      },
      {
        'question':
            'If second differences are equal in a table of values, it is:',
        'type': 'multiple_choice',
        'options': [
          'Quadratic function',
          'Linear function',
          'Constant function',
          'No function',
        ],
        'correctAnswer': 'Quadratic function',
      },
      {
        'question': 'What form shows vertex directly?',
        'type': 'multiple_choice',
        'options': [
          'Vertex form',
          'Standard form',
          'Factored form',
          'General form',
        ],
        'correctAnswer': 'Vertex form',
      },
      {
        'question': 'The graph of f(x) = -x^2 + 3 opens:',
        'type': 'multiple_choice',
        'options': ['Downward', 'Upward', 'Sideways', 'Does not open'],
        'correctAnswer': 'Downward',
      },
    ];

    final trueFalse = [
      {
        'question': 'Quadratic function always has highest exponent 2.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Graph is always a straight line.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'Vertex is the turning point.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'f(x) = 4x^3 + 2x + 1 is quadratic.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'If graph opens upward, it has minimum value.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'What is the U-shaped curve?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'What is f(x) = a(x - h)^2 + k?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Vertex form',
      },
      {
        'question': 'What has equal second differences?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Quadratic function',
      },
      {
        'question': 'What are the points where parabola crosses x-axis?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Roots',
      },
      {
        'question': 'What is a real-life example?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Path of a ball',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz7Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz7.md
    final multipleChoice = [
      {
        'question': 'What is the vertex form?',
        'type': 'multiple_choice',
        'options': [
          'y = a(x - h)^2 + k',
          'y = ax^2 + bx + c',
          'y = (x - r1)(x - r2)',
          'y = ax + b',
        ],
        'correctAnswer': 'y = a(x - h)^2 + k',
      },
      {
        'question': 'In vertex form, what is h?',
        'type': 'multiple_choice',
        'options': [
          'x-coordinate of vertex',
          'y-coordinate of vertex',
          'Coefficient',
          'Constant',
        ],
        'correctAnswer': 'x-coordinate of vertex',
      },
      {
        'question': 'In vertex form, what is k?',
        'type': 'multiple_choice',
        'options': [
          'y-coordinate of vertex',
          'x-coordinate of vertex',
          'Coefficient',
          'Constant',
        ],
        'correctAnswer': 'y-coordinate of vertex',
      },
      {
        'question': 'What is the shape of the graph?',
        'type': 'multiple_choice',
        'options': ['Parabola', 'Line', 'Circle', 'Ellipse'],
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'If a > 0, the parabola:',
        'type': 'multiple_choice',
        'options': [
          'Opens upward',
          'Opens downward',
          'Opens sideways',
          'Does not open',
        ],
        'correctAnswer': 'Opens upward',
      },
      {
        'question': 'If a < 0, the parabola:',
        'type': 'multiple_choice',
        'options': [
          'Opens downward',
          'Opens upward',
          'Opens sideways',
          'Does not open',
        ],
        'correctAnswer': 'Opens downward',
      },
      {
        'question': 'What is the vertex of y = (x - 3)^2 + 4?',
        'type': 'multiple_choice',
        'options': ['(3, 4)', '(-3, 4)', '(3, -4)', '(-3, -4)'],
        'correctAnswer': '(3, 4)',
      },
      {
        'question': 'What is the vertex of y = 2(x + 1)^2 - 5?',
        'type': 'multiple_choice',
        'options': ['(-1, -5)', '(1, -5)', '(-1, 5)', '(1, 5)'],
        'correctAnswer': '(-1, -5)',
      },
      {
        'question': 'What is the formula for h from standard form?',
        'type': 'multiple_choice',
        'options': ['-b / 2a', 'b / 2a', '-b / a', 'b^2 - 4ac'],
        'correctAnswer': '-b / 2a',
      },
      {
        'question': 'What is the vertex form of y = x^2 - 6x + 8?',
        'type': 'multiple_choice',
        'options': [
          'y = (x - 3)^2 - 1',
          'y = (x - 3)^2 + 1',
          'y = (x + 3)^2 - 1',
          'y = (x + 3)^2 + 1',
        ],
        'correctAnswer': 'y = (x - 3)^2 - 1',
      },
    ];

    final trueFalse = [
      {
        'question': 'Vertex form is y = a(x - h)^2 + k.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Vertex (h, k) is the midpoint.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'Completing the square converts standard to vertex form.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'If a > 0, parabola opens downward.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'In vertex form, a controls width/narrowness.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'What is the U-shaped curve?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'What is the highest/lowest point?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Vertex',
      },
      {
        'question': 'What is the value inside parentheses?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'x-coordinate of vertex',
      },
      {
        'question': 'What is the method to change to vertex form?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Completing the square',
      },
      {
        'question': 'What is the general form?',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'y = ax^2 + bx + c',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz8Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz8.md
    final multipleChoice = [
      {
        'question': 'The graph of a quadratic function is called:',
        'type': 'multiple_choice',
        'options': ['Parabola', 'Line', 'Circle', 'Triangle'],
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'What is the shape of a parabola when a is positive?',
        'type': 'multiple_choice',
        'options': [
          'Opens upward',
          'Opens downward',
          'Opens sideways',
          'Opens to the left',
        ],
        'correctAnswer': 'Opens upward',
      },
      {
        'question': 'Which of the following is in vertex form?',
        'type': 'multiple_choice',
        'options': [
          'y = ax^2 + bx + c',
          'y = a(x - h)^2 + k',
          'y = (x - r1)(x - r2)',
          'y = ax + b',
        ],
        'correctAnswer': 'y = a(x - h)^2 + k',
      },
      {
        'question': 'The vertex of the graph y = (x - 2)^2 + 3 is:',
        'type': 'multiple_choice',
        'options': ['(2, 3)', '(-2, 3)', '(3, 2)', '(-3, 2)'],
        'correctAnswer': '(2, 3)',
      },
      {
        'question':
            'In the equation y = a(x - h)^2 + k, the vertex is found at:',
        'type': 'multiple_choice',
        'options': ['(h, k)', '(a, k)', '(k, h)', '(b, c)'],
        'correctAnswer': '(h, k)',
      },
      {
        'question': 'What is the axis of symmetry in a quadratic graph?',
        'type': 'multiple_choice',
        'options': [
          'The line that divides the parabola into two equal parts',
          'The x-intercept',
          'The highest point of the graph',
          'The distance between roots',
        ],
        'correctAnswer':
            'The line that divides the parabola into two equal parts',
      },
      {
        'question': 'The graph of y = -x^2 + 4 opens:',
        'type': 'multiple_choice',
        'options': ['Downward', 'Upward', 'Sideways', 'None of the above'],
        'correctAnswer': 'Downward',
      },
      {
        'question': 'In the graph of y = 2(x - 1)^2 + 5, what is the vertex?',
        'type': 'multiple_choice',
        'options': ['(1, 5)', '(-1, 5)', '(5, 1)', '(1, -5)'],
        'correctAnswer': '(1, 5)',
      },
      {
        'question': 'When the value of a increases, the parabola becomes:',
        'type': 'multiple_choice',
        'options': ['Narrower', 'Wider', 'Flatter', 'Horizontal'],
        'correctAnswer': 'Narrower',
      },
      {
        'question':
            'Which real-life situation can be modeled by a quadratic graph?',
        'type': 'multiple_choice',
        'options': [
          'The path of a thrown ball',
          'The number of days in a week',
          'The amount of water in a bottle',
          'The distance of a car moving at constant speed',
        ],
        'correctAnswer': 'The path of a thrown ball',
      },
    ];

    final trueFalse = [
      {
        'question': 'The vertex is always at the middle of the parabola.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The axis of symmetry is always a horizontal line.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'The graph of y = x^2 is a parabola that opens upward.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'The constant k in the vertex form shows how much the graph moves left or right.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'The coefficient a tells us if the parabola opens upward or downward.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'The U-shaped curve formed by a quadratic function',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'The highest or lowest point of a parabola',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Vertex',
      },
      {
        'question': 'The line that divides the parabola into two equal parts',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Axis of symmetry',
      },
      {
        'question': 'General form of a quadratic function',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'y = ax^2 + bx + c',
      },
      {
        'question': 'Vertex of y = (x - 4)^2 + 2',
        'type': 'identification',
        'options': null,
        'correctAnswer': '(4, 2)',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter1Quiz9Questions() {
    // Quiz items sourced from assets/quiz/quarter1/quiz9.md
    final multipleChoice = [
      {
        'question': 'The graph of a quadratic function is called a:',
        'type': 'multiple_choice',
        'options': ['Parabola', 'Line', 'Circle', 'Ellipse'],
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'Which of the following is a quadratic function?',
        'type': 'multiple_choice',
        'options': ['y = x^2 + 5x + 6', 'y = 2x + 3', 'y = 3x^3 + 2', 'y = 7'],
        'correctAnswer': 'y = x^2 + 5x + 6',
      },
      {
        'question': 'The vertex of a parabola gives the _____ of the function.',
        'type': 'multiple_choice',
        'options': [
          'Maximum or minimum value',
          'x-intercept',
          'Slope',
          'Constant',
        ],
        'correctAnswer': 'Maximum or minimum value',
      },
      {
        'question': 'In y = ax^2 + bx + c, if a > 0, the parabola opens:',
        'type': 'multiple_choice',
        'options': ['Upward', 'Downward', 'Sideways', 'Diagonally'],
        'correctAnswer': 'Upward',
      },
      {
        'question': 'If a < 0, the parabola opens:',
        'type': 'multiple_choice',
        'options': ['Downward', 'Upward', 'To the right', 'To the left'],
        'correctAnswer': 'Downward',
      },
      {
        'question':
            'What is the formula to find the x-coordinate of the vertex?',
        'type': 'multiple_choice',
        'options': ['h = -b / 2a', 'h = -b / a', 'h = b^2 - 4ac', 'h = abc'],
        'correctAnswer': 'h = -b / 2a',
      },
      {
        'question':
            'The value of the function at the vertex gives the _____ value.',
        'type': 'multiple_choice',
        'options': ['Maximum or Minimum', 'Median', 'Average', 'Constant'],
        'correctAnswer': 'Maximum or Minimum',
      },
      {
        'question':
            'The roots or zeros of a quadratic function are found when:',
        'type': 'multiple_choice',
        'options': ['y = 0', 'x = 0', 'x = 1', 'y = 1'],
        'correctAnswer': 'y = 0',
      },
      {
        'question':
            'In real-life problems, quadratic functions can be used to find:',
        'type': 'multiple_choice',
        'options': [
          'Area, height, or profit',
          'Speed of light',
          'Number of days in a month',
          'Shape of a triangle',
        ],
        'correctAnswer': 'Area, height, or profit',
      },
      {
        'question':
            'What is the maximum height of a ball given by y = -5x^2 + 20x + 2?',
        'type': 'multiple_choice',
        'options': ['22', '25', '20', '15'],
        'correctAnswer': '22',
      },
    ];

    final trueFalse = [
      {
        'question':
            'A quadratic function always has a variable raised to the power of 3.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'The vertex represents the turning point of the graph.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'When a is positive, the graph of a quadratic function opens downward.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'Quadratic functions can be used to model the path of a thrown ball.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'The vertex form of a quadratic function is y = a(x - h)^2 + k.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'The U-shaped curve of a quadratic function',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Parabola',
      },
      {
        'question': 'The highest or lowest point of the graph',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Vertex',
      },
      {
        'question':
            'The vertical line dividing the parabola into two equal parts',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Axis of symmetry',
      },
      {
        'question': 'The value that makes the function equal to zero',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Root (or zero)',
      },
      {
        'question':
            'Process of finding the best possible solution (e.g., maximum profit, minimum cost)',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Optimization',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz1Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz1.md
    final multipleChoice = [
      {
        'question':
            'When multiplying powers with the same base, you _____ the exponents.',
        'type': 'multiple_choice',
        'options': ['Divide', 'Add', 'Subtract', 'Multiply'],
        'correctAnswer': 'Add',
      },
      {
        'question':
            'When dividing powers with the same base, you _____ the exponents.',
        'type': 'multiple_choice',
        'options': ['Add', 'Multiply', 'Subtract', 'Cancel'],
        'correctAnswer': 'Subtract',
      },
      {
        'question': 'What is the simplified form of (x^5 · x^3)?',
        'type': 'multiple_choice',
        'options': ['x^2', 'x^8', 'x^15', 'x^5'],
        'correctAnswer': 'x^8',
      },
      {
        'question': 'What is the value of x^0, where x ≠ 0?',
        'type': 'multiple_choice',
        'options': ['0', '2', '1', 'Undefined'],
        'correctAnswer': '1',
      },
      {
        'question': 'The expression x^(-3) is equal to:',
        'type': 'multiple_choice',
        'options': ['x^3', '1/x^3', '-x^3', '1/x^(-3)'],
        'correctAnswer': '1/x^3',
      },
      {
        'question': 'Which rule applies in ((x^2)^3 = x^6)?',
        'type': 'multiple_choice',
        'options': [
          'Power Rule',
          'Product Rule',
          'Zero Exponent Rule',
          'Quotient Rule',
        ],
        'correctAnswer': 'Power Rule',
      },
      {
        'question': 'What is the simplified form of (3^4 · 3^2)?',
        'type': 'multiple_choice',
        'options': ['3^2', '3^6', '3^8', '3^12'],
        'correctAnswer': '3^6',
      },
      {
        'question': 'What is the simplified form of ((2a)^3)?',
        'type': 'multiple_choice',
        'options': ['2a^3', '6a^3', '6a', '8a^3'],
        'correctAnswer': '8a^3',
      },
      {
        'question': 'Which of the following is the result of ((x^2 / y)^3)?',
        'type': 'multiple_choice',
        'options': ['x^6/y^3', 'x^3/y^6', 'x/y^3', 'x^3y^6'],
        'correctAnswer': 'x^6/y^3',
      },
      {
        'question':
            'When a base is raised to a negative exponent, the expression becomes a:',
        'type': 'multiple_choice',
        'options': ['Product', 'Reciprocal', 'Sum', 'Difference'],
        'correctAnswer': 'Reciprocal',
      },
    ];

    final trueFalse = [
      {
        'question': 'A variable raised to zero exponent always equals 1.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'In (x^m/x^n), exponents are added.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'Negative exponents can be made positive by moving the base across the fraction bar.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'The rule ((xy)^m = x^m y^m) is called the Power of a Product Rule.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '(x^(-2) = x^2).',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
    ];

    final identification = [
      {
        'question':
            'Rule where exponents are added when multiplying same bases.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Product Rule',
      },
      {
        'question': 'Rule used when raising a power to another power.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Power Rule',
      },
      {
        'question':
            'Rule used to transform negative exponents into positive exponents.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Negative Exponent Rule',
      },
      {
        'question':
            'The expression for anything raised to zero power is always equal to _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'One (1)',
      },
      {
        'question':
            'The rule used when distributing exponents to both numerator and denominator in a fraction.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Power of a Quotient Rule',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz2Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz2.md
    final multipleChoice = [
      {
        'question': 'In a joint variation, a variable varies directly as:',
        'type': 'multiple_choice',
        'options': [
          'One variable',
          'Two or more variables',
          'A constant',
          'No variable',
        ],
        'correctAnswer': 'Two or more variables',
      },
      {
        'question': 'Which equation represents joint variation?',
        'type': 'multiple_choice',
        'options': ['z = kx', 'z = k/x', 'z = kxy', 'z = k + x'],
        'correctAnswer': 'z = kxy',
      },
      {
        'question':
            'If z varies jointly as x and y, then doubling both x and y will make z:',
        'type': 'multiple_choice',
        'options': ['Double', 'Triple', 'Quadruple', 'Stay the same'],
        'correctAnswer': 'Quadruple',
      },
      {
        'question': 'In a combined variation, a variable varies:',
        'type': 'multiple_choice',
        'options': [
          'Directly and inversely at the same time',
          'Only directly',
          'Only inversely',
          'Neither',
        ],
        'correctAnswer': 'Directly and inversely at the same time',
      },
      {
        'question': 'Which of the following shows combined variation?',
        'type': 'multiple_choice',
        'options': ['z = kxy', 'z = k/xy', 'z = kx/y', 'z = k + xy'],
        'correctAnswer': 'z = kx/y',
      },
      {
        'question':
            'If z varies jointly as x and w, and z = 40 when x = 4 and w = 5, what is k?',
        'type': 'multiple_choice',
        'options': ['1', '2', '4', '8'],
        'correctAnswer': '2',
      },
      {
        'question':
            'If z varies jointly as p and h, and inversely as q, the equation is:',
        'type': 'multiple_choice',
        'options': ['z = kpqh', 'z = kp/qh', 'z = kph/q', 'z = q/kph'],
        'correctAnswer': 'z = kph/q',
      },
      {
        'question':
            'When one variable is directly proportional to two variables and inversely proportional to another, it is called:',
        'type': 'multiple_choice',
        'options': [
          'Direct variation',
          'Inverse variation',
          'Joint variation',
          'Combined variation',
        ],
        'correctAnswer': 'Combined variation',
      },
      {
        'question': 'Which of the following is NOT a joint variation?',
        'type': 'multiple_choice',
        'options': ['z = 3xy', 'z = kpqh', 'z = kx/y', 'z = 5ab'],
        'correctAnswer': 'z = kx/y',
      },
      {
        'question':
            'If z varies jointly as x and y, and k = 3, which equation is correct?',
        'type': 'multiple_choice',
        'options': ['z = 3xy', 'z = x + y', 'z = 3/xy', 'z = xy/3'],
        'correctAnswer': 'z = 3xy',
      },
    ];

    final trueFalse = [
      {
        'question': 'In a joint variation, the variables multiply each other.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The equation z = kx/y represents a joint variation only.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'If a relationship has both direct and inverse components, it is a combined variation.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'The constant of variation (k) is always solved using given values.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Joint variation involves addition of variables.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
    ];

    final identification = [
      {
        'question':
            'Variation involving two or more variables directly is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Joint Variation',
      },
      {
        'question':
            'A variation that combines direct and inverse relationships is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Combined Variation',
      },
      {
        'question':
            'The fixed number relating variables in a variation equation is the _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Constant of Variation (k)',
      },
      {
        'question': 'The equation of a joint variation is _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'z = kxy (general form)',
      },
      {
        'question': 'The equation of a combined variation is _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'z = kx/y (general form)',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz3Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz3.md
    final multipleChoice = [
      {
        'question':
            'y varies directly as x. When x = 9 and y = 27, what is y when x = 15?',
        'type': 'multiple_choice',
        'options': ['35', '40', '45', '50'],
        'correctAnswer': '45',
      },
      {
        'question':
            'The cost C of oranges varies directly as its weight w. If 4 kg costs ₱180, how much will 10 kg cost?',
        'type': 'multiple_choice',
        'options': ['300', '350', '400', '450'],
        'correctAnswer': '450',
      },
      {
        'question':
            'The time t to finish a job varies inversely as the number of workers n. If 8 workers finish in 15 hours, how long will 12 workers take?',
        'type': 'multiple_choice',
        'options': ['8', '10', '12', '15'],
        'correctAnswer': '10',
      },
      {
        'question':
            'The pressure P varies inversely as the volume V. If P = 50 kPa when V = 4 L, what is P when V = 10 L?',
        'type': 'multiple_choice',
        'options': ['12', '18', '20', '25'],
        'correctAnswer': '20',
      },
      {
        'question':
            'The distance d varies directly as the time t. If you travel 120 km in 3 hours, how far in 7 hours?',
        'type': 'multiple_choice',
        'options': ['210', '240', '260', '280'],
        'correctAnswer': '280',
      },
      {
        'question':
            'The intensity I varies inversely as the square of the distance d. If I = 80 at d = 2 m, what is I at d = 4 m?',
        'type': 'multiple_choice',
        'options': ['5', '10', '20', '40'],
        'correctAnswer': '20',
      },
      {
        'question':
            'y varies directly as x^2. If y = 108 when x = 6, find y when x = 3.',
        'type': 'multiple_choice',
        'options': ['18', '27', '30', '36'],
        'correctAnswer': '27',
      },
      {
        'question':
            'A varies inversely as B. When B = 12, A = 16. What is A when B = 24?',
        'type': 'multiple_choice',
        'options': ['4', '6', '8', '12'],
        'correctAnswer': '8',
      },
      {
        'question':
            'The speed s varies directly as distance d. If s = 12 at d = 15 km, find s at d = 25 km.',
        'type': 'multiple_choice',
        'options': ['15', '18', '20', '25'],
        'correctAnswer': '20',
      },
      {
        'question':
            'y varies inversely as x. If y = 2.5 when x = 4, what is x when y = 1?',
        'type': 'multiple_choice',
        'options': ['4', '6', '8', '10'],
        'correctAnswer': '10',
      },
    ];

    final trueFalse = [
      {
        'question':
            'Direct variation means that when one variable increases, the other also increases.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'In inverse variation, the product of the variables is constant.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'The graph of direct variation always passes through the origin.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The equation y = k/x represents direct variation.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'In direct variation, y/x = k.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The graph of inverse variation is a straight line.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'If y = 5x, then y decreases when x decreases.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Joint variation involves three or more variables.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The ratio y/x is constant in direct variation.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'The equation y = kx^2 is still a type of variation.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question':
            'Relationship where one variable increases as the other increases.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Direct variation',
      },
      {
        'question':
            'Relationship where one variable increases as the other decreases.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Inverse variation',
      },
      {
        'question': 'The constant number k in variation equations.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Constant of variation',
      },
      {
        'question': 'Equation form of inverse variation.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'y = k/x',
      },
      {
        'question': 'Graph of direct variation.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Straight line through origin',
      },
      {
        'question': 'Variation combining direct and inverse relations.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Combined variation',
      },
      {
        'question': 'Variation involving three or more variables.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Joint variation',
      },
      {
        'question': 'The variable that depends on another.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Dependent variable',
      },
      {
        'question': 'Variation where the product xy is constant.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Inverse variation',
      },
      {
        'question': 'Variation shown by y = kx^3.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Direct variation (cube)',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz4Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz4.md
    final multipleChoice = [
      {
        'question':
            'Thomas is 2 years more than twice Peter\'s age, and their product is 24. How old is Peter?',
        'type': 'multiple_choice',
        'options': ['8', '5', '4', '3'],
        'correctAnswer': '4',
      },
      {
        'question':
            'If one number is 5 more than another and their product is 14, what is the first number?',
        'type': 'multiple_choice',
        'options': ['2', '5', '7', '9'],
        'correctAnswer': '2',
      },
      {
        'question':
            'The length of a wall is 7 meters longer than its width, and the area is 30 m². What is the length?',
        'type': 'multiple_choice',
        'options': ['3 m', '10 m', '30 m', '40 m'],
        'correctAnswer': '10 m',
      },
      {
        'question':
            'Two integers sum to 16 and their product is 60. What are the numbers?',
        'type': 'multiple_choice',
        'options': ['-6 and 10', '6 and -10', '-6 and -10', '6 and 10'],
        'correctAnswer': '6 and 10',
      },
      {
        'question':
            'A motorcycle travels 2 kph faster than a car. It covered 480 km in 2 hours less than the car. Motorcycle speed is:',
        'type': 'multiple_choice',
        'options': ['20.93 kph', '22.93 kph', '40 kph', '80 kph'],
        'correctAnswer': '80 kph',
      },
      {
        'question':
            'The sum of a number and its reciprocal is 2. What number satisfies it?',
        'type': 'multiple_choice',
        'options': ['3', '2', '1', '-1'],
        'correctAnswer': '1',
      },
      {
        'question':
            'A rectangular field has width 5 m and length 25 m. What is its area?',
        'type': 'multiple_choice',
        'options': ['100 m²', '125 m²', '150 m²', '200 m²'],
        'correctAnswer': '125 m²',
      },
      {
        'question':
            'A condo rent is ₱1200. Four didn\'t attend, raising each share by ₱400. How many attended?',
        'type': 'multiple_choice',
        'options': ['4', '5', '6', '8'],
        'correctAnswer': '6',
      },
      {
        'question':
            'The area of a triangular frame is 52 in², height is 3 less than twice the base. What is the base?',
        'type': 'multiple_choice',
        'options': ['21 in', '16 in', '13 in', '8 in'],
        'correctAnswer': '8 in',
      },
      {
        'question':
            'Joy drove 300 km. If she traveled 10 kph faster, trip time would be 1 hour less. What was her speed?',
        'type': 'multiple_choice',
        'options': ['40 kph', '50 kph', '60 kph', '70 kph'],
        'correctAnswer': '50 kph',
      },
    ];

    final trueFalse = [
      {
        'question':
            'Quadratic equations are often used to model age and number problems.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'A negative answer can be considered valid for age problems.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'Rational equations can be transformed into quadratic equations.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Some quadratic problems have two valid answers.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'Motion and work problems usually involve rational equations.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question':
            'A solution that does not satisfy the original equation is _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Extraneous solution',
      },
      {
        'question':
            'The equation used to represent two unknown numbers is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Mathematical model',
      },
      {
        'question':
            'The step in solving problems where you write mathematical expressions is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Formulating the equation',
      },
      {
        'question': 'A formula relating speed, distance, and time is _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'rate = distance/time',
      },
      {
        'question':
            'Reasoning step where you check if your answer fits is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Verification or Checking',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz5Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz5.md
    final multipleChoice = [
      {
        'question':
            'The number or expression under the radical sign is called:',
        'type': 'multiple_choice',
        'options': ['Index', 'Radical', 'Radicand', 'Exponent'],
        'correctAnswer': 'Radicand',
      },
      {
        'question':
            'The small number outside the radical symbol that tells which root to take is the:',
        'type': 'multiple_choice',
        'options': ['Base', 'Power', 'Radicand', 'Index'],
        'correctAnswer': 'Index',
      },
      {
        'question': '√(a·b) = √a · √b illustrates which law of radicals?',
        'type': 'multiple_choice',
        'options': [
          'Quotient Rule',
          'Power Rule',
          'Product Rule',
          'Index Rule',
        ],
        'correctAnswer': 'Product Rule',
      },
      {
        'question': '√(a/b) = √a / √b illustrates which radical rule?',
        'type': 'multiple_choice',
        'options': [
          'Product Rule',
          'Quotient Rule',
          'Power Rule',
          'Index Rule',
        ],
        'correctAnswer': 'Quotient Rule',
      },
      {
        'question': '√(x^n) where the exponent and index are both even equals:',
        'type': 'multiple_choice',
        'options': ['x', '|x|', 'x^2', 'x^n'],
        'correctAnswer': '|x|',
      },
      {
        'question':
            'Which term refers to making the denominator free of radicals?',
        'type': 'multiple_choice',
        'options': [
          'Simplification',
          'Equation balancing',
          'Rationalization',
          'Conjugation',
        ],
        'correctAnswer': 'Rationalization',
      },
      {
        'question': '√64 simplifies to:',
        'type': 'multiple_choice',
        'options': ['4', '±8', '8', '16'],
        'correctAnswer': '8',
      },
      {
        'question': '√(49x^8 y^15 z^9) simplifies to:',
        'type': 'multiple_choice',
        'options': [
          '7x^4 y^7 z^4 √(yz)',
          '49x^8 y^15 z^9',
          '7x^8 yz',
          '7xy^4 z^2 √(yz)',
        ],
        'correctAnswer': '7x^4 y^7 z^4 √(yz)',
      },
      {
        'question': '√√256 simplifies to:',
        'type': 'multiple_choice',
        'options': ['2', '4', '8', '16'],
        'correctAnswer': '4',
      },
      {
        'question':
            '√((-10)^5) where exponent and index are odd simplifies to:',
        'type': 'multiple_choice',
        'options': ['10', '|-10|', '-10', '1/10'],
        'correctAnswer': '-10',
      },
    ];

    final trueFalse = [
      {
        'question': '√125 = 5√5',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '√(a·b) = √a + √b',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'If √x is in the denominator, we rationalize by multiplying √x/√x.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '√((-3)^4) = 3 because exponent and index are even.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '√√64 = √(64^2)',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
    ];

    final identification = [
      {
        'question': '√a · √b = √ab refers to the _____ rule.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Product Rule',
      },
      {
        'question': 'The value under the radical is the _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Radicand',
      },
      {
        'question': 'Making the denominator free of radicals is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Rationalization',
      },
      {
        'question':
            'The number placed above the base in exponential form is the _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Exponent',
      },
      {
        'question': '√√a = √(a^mn) demonstrates the _____ rule.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Different Indices Rule',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz6Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz6.md
    final multipleChoice = [
      {
        'question':
            'Similar radicals can be added or subtracted only when they have the same:',
        'type': 'multiple_choice',
        'options': [
          'Coefficient',
          'Index and radicand',
          'Base',
          'Simplified form',
        ],
        'correctAnswer': 'Index and radicand',
      },
      {
        'question': 'What is the sum of 6√3 + √3?',
        'type': 'multiple_choice',
        'options': ['6√6', '7√3', '√9', '6√3'],
        'correctAnswer': '7√3',
      },
      {
        'question':
            'Which of the following is the difference of 5√2 - 2√18 after simplification?',
        'type': 'multiple_choice',
        'options': ['-√2', '√2', '3√2', '-11√2'],
        'correctAnswer': '3√2',
      },
      {
        'question':
            'The expression 8√(y^3) - 6√(y^3) + 2√(y^3) simplifies into:',
        'type': 'multiple_choice',
        'options': ['-4√(y^3)', '16√(y^3)', '2√y', '4√(y^3)'],
        'correctAnswer': '4√(y^3)',
      },
      {
        'question': 'Which of the following radical expressions are similar?',
        'type': 'multiple_choice',
        'options': [
          '√(21^4), √(21^3), √21',
          '√x, √y, √z',
          'a√3, 3a√3, 2a√3',
          '4√5, 5√6, 6√7',
        ],
        'correctAnswer': 'a√3, 3a√3, 2a√3',
      },
      {
        'question': 'What is the simplified form of 10√28 + 5√63 - 7√7?',
        'type': 'multiple_choice',
        'options': ['16√21', '28√7', '-16√21', '-28√7'],
        'correctAnswer': '28√7',
      },
      {
        'question': 'Which shows the difference of 8√(5^3) - 12√(5^3)?',
        'type': 'multiple_choice',
        'options': ['-4√(5^3)', '10√5', '6√5', '4√(5^3)'],
        'correctAnswer': '-4√(5^3)',
      },
      {
        'question': 'What is 20√(5^3) - 15√(5^3)?',
        'type': 'multiple_choice',
        'options': ['5√(5^3)', '-5√5', '35√(5^3)', '5√(10^3)'],
        'correctAnswer': '5√(5^3)',
      },
      {
        'question': 'Combine -2√(a^4) + 10√(16a^4) - 5√(a^4):',
        'type': 'multiple_choice',
        'options': ['-12√(18a^4)', '7√(a^4)', '17√(4a^4)', '13√(a^4)'],
        'correctAnswer': '13√(a^4)',
      },
      {
        'question': 'Which of the following is the sum of 5√(8a^2) + 3a√18?',
        'type': 'multiple_choice',
        'options': ['8a√26', '5√(8a^2) + 3a√18', '19a√2', '15√(2a)'],
        'correctAnswer': '19a√2',
      },
    ];

    final trueFalse = [
      {
        'question':
            'Only similar radicals can be combined through addition or subtraction.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '√5 + √7 can be combined into 2√12.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'Sometimes radicals become similar after simplification.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'Radicals with different radicands can be added directly without simplifying.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': '6√2 + 9√2 - 4√2 simplifies to 11√2.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question':
            'Radicals that have the same index and radicand are called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Similar radicals',
      },
      {
        'question':
            'The process of combining radicals with the same radicand is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer':
            'Combining like radicals / Addition or subtraction of radicals',
      },
      {
        'question':
            'In 7√27 + 3√75, rewriting radicals into simpler forms before combining is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Simplifying radicals',
      },
      {
        'question':
            'In the expression 5√8 - 3√50 + 8√72, 4, 25, and 36 are used as perfect factors. This process is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Factoring under the radical',
      },
      {
        'question':
            'The step where we add or subtract coefficients and keep the radical symbol is _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Annexing the common radical factor',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz7Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz7.md
    final multipleChoice = [
      {
        'question': 'What is the quotient of 5√9 ÷ √3?',
        'type': 'multiple_choice',
        'options': ['6√6', '7√3', '7√9', '5√3'],
        'correctAnswer': '5√3',
      },
      {
        'question': 'What is the product of (4√2)(5√10)?',
        'type': 'multiple_choice',
        'options': ['40√5', '20√20', '20√5', '8√20'],
        'correctAnswer': '40√5',
      },
      {
        'question': 'What is the quotient of √63 ÷ √7?',
        'type': 'multiple_choice',
        'options': ['√7', '7√3', '3', '√7'],
        'correctAnswer': '3',
      },
      {
        'question': 'What is the product of (√5 + √3)(√5 - √3)?',
        'type': 'multiple_choice',
        'options': ['9', '2', '25', '16'],
        'correctAnswer': '2',
      },
      {
        'question':
            'What is √(48x^4 y^5) multiplied by (5x√(3y^5) - y√(243x^4 y^4))?',
        'type': 'multiple_choice',
        'options': ['4x^2 y^2 √(3y)', '3x√(4xy^4)', '4xy√(3y^4)', '3y√(4xy^4)'],
        'correctAnswer': '4x^2 y^2 √(3y)',
      },
    ];

    final trueFalse = [
      {
        'question': '√5 · √10 = 5√2',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'When multiplying radicals, the indices must always match.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'Multiplying conjugates always results in a rational number.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '(√3 + √7)(√3 - √7) = 3 - 7',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': '√8 ÷ √2 = √4',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'The rule that states √a · √b = √ab.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Product Rule for Radicals',
      },
      {
        'question': 'The expression used to remove radicals in denominators.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Rationalizing the denominator',
      },
      {
        'question': 'The binomial with opposite sign used in rationalization.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Conjugate',
      },
      {
        'question':
            'Method used to multiply two binomials such as (a + b)(c + d).',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'FOIL Method',
      },
      {
        'question': 'Process where radicals in a denominator are eliminated.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Rationalization',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz8Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz8.md
    final multipleChoice = [
      {
        'question':
            'What do you call equations that contain a variable under a radical?',
        'type': 'multiple_choice',
        'options': [
          'Polynomial equations',
          'Quadratic equations',
          'Radical equations',
          'System of equations',
        ],
        'correctAnswer': 'Radical equations',
      },
      {
        'question':
            'A value found during solving but does NOT satisfy the original equation is called:',
        'type': 'multiple_choice',
        'options': [
          'Discriminant',
          'Equation',
          'Extraneous root',
          'Leading term',
        ],
        'correctAnswer': 'Extraneous root',
      },
      {
        'question':
            'What determines the power applied when removing a radical?',
        'type': 'multiple_choice',
        'options': ['Coefficient', 'Index', 'Leading term', 'Radicand'],
        'correctAnswer': 'Index',
      },
      {
        'question': 'What is the FIRST step in solving radical equations?',
        'type': 'multiple_choice',
        'options': [
          'Check answers',
          'Identify index',
          'Isolate the radical(s)',
          'Isolate the variable',
        ],
        'correctAnswer': 'Isolate the radical(s)',
      },
      {
        'question': 'Which of the following is NOT a radical equation?',
        'type': 'multiple_choice',
        'options': [
          '5a = -√?',
          '√(6x + 2)',
          '√(10x + 3) = ?',
          '4√(5m - 20) = 16',
        ],
        'correctAnswer': '5a = -√?',
      },
      {
        'question': 'What are the binomial factors of x^2 - 15x + 50?',
        'type': 'multiple_choice',
        'options': [
          '(x + 10)(x + 5)',
          '(x + 10)(x - 5)',
          '(x - 10)(x + 5)',
          '(x - 10)(x - 5)',
        ],
        'correctAnswer': '(x - 10)(x - 5)',
      },
      {
        'question': 'What is the value of x in √x - 2 = 10?',
        'type': 'multiple_choice',
        'options': ['-5', '-10', '5', '10'],
        'correctAnswer': '5',
      },
      {
        'question': 'Which equation has NO solution?',
        'type': 'multiple_choice',
        'options': ['√(5x) = -?', '√(5x) = 5', '√(2x) = -5', '∛(15x) = -3'],
        'correctAnswer': '√(2x) = -5',
      },
      {
        'question': 'What is the expanded form of (x + 3)^2?',
        'type': 'multiple_choice',
        'options': [
          'x^2 + 4x + 2',
          'x^2 - 4x + 6',
          'x^2 + 6x + 9',
          'x^2 + 3x + 6',
        ],
        'correctAnswer': 'x^2 + 6x + 9',
      },
      {
        'question': 'What is the value of m in √(3m + 5) = 11?',
        'type': 'multiple_choice',
        'options': ['-4', '-10', '4', 'No solution'],
        'correctAnswer': 'No solution',
      },
    ];

    final trueFalse = [
      {
        'question':
            'Radical equations are solved by isolating the radical first.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'All values obtained from solving radical equations are always valid solutions.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'An extraneous root does not satisfy the original equation.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'Radical equations may require checking answers due to possible false roots.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'The index tells you which value the radicand is raised to.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question': 'The expression under the radical sign is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Radicand',
      },
      {
        'question':
            'The number that determines how many times to raise both sides is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Index',
      },
      {
        'question':
            'A value obtained from solving but fails verification is called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Extraneous root',
      },
      {
        'question':
            'The process of making sure answers satisfy the original equation is _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Checking/Verification',
      },
      {
        'question':
            'Equations where variables appear under radicals are called _____.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Radical equations',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
  }

  List<Map<String, dynamic>> _getQuarter2Quiz9Questions() {
    // Quiz items sourced from assets/quiz/quarter2/quiz9.md
    final multipleChoice = [
      {
        'question':
            'The cube root of four less than a number is three. What is the number?',
        'type': 'multiple_choice',
        'options': ['49', '35', '31', '27'],
        'correctAnswer': '31',
      },
      {
        'question':
            'Twice the fourth root of two more than a number is four. What is the number?',
        'type': 'multiple_choice',
        'options': ['4', '12', '14', '17'],
        'correctAnswer': '4',
      },
      {
        'question':
            'The square root of one less than a number is equal to seven less than the same number. Find the number.',
        'type': 'multiple_choice',
        'options': ['10', '5', '-1', '-7'],
        'correctAnswer': '5',
      },
      {
        'question':
            'The square root of one more than three times a number is four. Find the number.',
        'type': 'multiple_choice',
        'options': ['5', '6', '7', '8'],
        'correctAnswer': '5',
      },
      {
        'question':
            'A boy walks 30 meters west then 40 meters south. How far is he from the starting point?',
        'type': 'multiple_choice',
        'options': ['50 m', '60 m', '80 m', '90 m'],
        'correctAnswer': '50 m',
      },
      {
        'question':
            'The side length of a square is given by s = √a. If the area is 8 cm², find the side length.',
        'type': 'multiple_choice',
        'options': ['3√2 cm', '2√2 cm', '8√2 cm', '2√8 cm'],
        'correctAnswer': '2√2 cm',
      },
      {
        'question':
            'A triangle has a hypotenuse 17 cm and one leg 15 cm. Find the other leg.',
        'type': 'multiple_choice',
        'options': ['5 cm', '8 cm', '10 cm', '12 cm'],
        'correctAnswer': '8 cm',
      },
      {
        'question':
            'A square has an area of 588 cm². What is the side length in simplified radical form?',
        'type': 'multiple_choice',
        'options': ['12√2', '13√2', '12√3', '14√3'],
        'correctAnswer': '14√3',
      },
      {
        'question':
            'A tidal wave travels 135 km/hr. If speed is given by S = 356√d, find the water depth.',
        'type': 'multiple_choice',
        'options': ['0.14 km', '0.23 km', '0.28 km', '0.55 km'],
        'correctAnswer': '0.14 km',
      },
      {
        'question':
            'A kite has a 110-ft string tied to the ground, directly above a flagpole 30 ft away. Find its altitude.',
        'type': 'multiple_choice',
        'options': ['106 ft', '95 ft', '73 ft', '56 ft'],
        'correctAnswer': '106 ft',
      },
    ];

    final trueFalse = [
      {
        'question': '√(x + 7) = x + 5 always has two valid solutions.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question':
            'The Pythagorean theorem can be used to solve diagonal problems involving radicals.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question':
            'Solving radical equations usually involves isolating the radical and squaring both sides.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
      {
        'question': 'Every radical equation has at least one extraneous root.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'False',
      },
      {
        'question': 'A rectangle\'s diagonal forms two right triangles.',
        'type': 'true_false',
        'options': null,
        'correctAnswer': 'True',
      },
    ];

    final identification = [
      {
        'question':
            'Process of checking whether a solution satisfies the original equation.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Verification',
      },
      {
        'question':
            'A solution that appears but does not satisfy the original equation.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Extraneous solution',
      },
      {
        'question':
            'The equation used to compute distance in right-triangle problems.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Pythagorean theorem',
      },
      {
        'question': 'Symbol that represents the square root operation.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Radical sign',
      },
      {
        'question': 'Mathematical sentence showing equal quantities.',
        'type': 'identification',
        'options': null,
        'correctAnswer': 'Equation',
      },
    ];

    return [...multipleChoice, ...trueFalse, ...identification];
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
                decoration: BoxDecoration(
                  gradient: ThemeHelper.getHeaderGradient(context),
                  boxShadow: ThemeHelper.getElevation(context, 2),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: ThemeHelper.getTextColor(context),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        _showReview ? 'Review Answers' : widget.quizTitle,
                        style: TextStyle(
                          color: ThemeHelper.getTextColor(context),
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
                              ? ThemeHelper.getErrorColor(context)
                              : ThemeHelper.getSuccessColor(context),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: ThemeHelper.isDarkMode(context)
                              ? ThemeHelper.getGlow(
                                  context,
                                  color: _timeRemaining <= 60
                                      ? ThemeHelper.getErrorColor(context)
                                      : ThemeHelper.getSuccessColor(context),
                                  blur: 6,
                                )
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: ThemeHelper.getInvertedTextColor(context),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime(_timeRemaining),
                              style: TextStyle(
                                color: ThemeHelper.getInvertedTextColor(
                                  context,
                                ),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeHelper.getButtonGreen(context),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentQuestionIndex + 1}/${_questions.length}',
                        style: TextStyle(
                          color: ThemeHelper.getInvertedTextColor(context),
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
                          backgroundColor: ThemeHelper.getButtonGreen(context),
                          foregroundColor: ThemeHelper.getInvertedTextColor(
                            context,
                          ),
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
                          backgroundColor: ThemeHelper.getButtonGreen(context),
                          foregroundColor: ThemeHelper.getInvertedTextColor(
                            context,
                          ),
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
    final isIdentification = question['type'] == 'identification';
    final cardColor = ThemeHelper.getCardColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final textColor = ThemeHelper.getTextColor(context);
    final isDark = ThemeHelper.isDarkMode(context);
    final selectionColor = ThemeHelper.getPrimaryGreen(
      context,
    ).withOpacity(isDark ? 0.3 : 0.15);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: isDark ? Border.all(color: borderColor, width: 1) : null,
            boxShadow: ThemeHelper.getElevation(context, 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question['question'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (isTrueFalse || isIdentification) ...[
                const SizedBox(height: 12),
                _buildQuestionTypePill(
                  label: isTrueFalse ? 'TRUE or FALSE' : 'IDENTIFICATION',
                  color: isTrueFalse
                      ? ThemeHelper.getButtonGreen(context)
                      : ThemeHelper.getSecondaryAccent(context),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Options or True/False Buttons
        Expanded(
          child: () {
            if (isTrueFalse) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTrueFalseButton('True', 'True', selectedAnswer),
                  const SizedBox(height: 16),
                  _buildTrueFalseButton('False', 'False', selectedAnswer),
                ],
              );
            }

            if (isIdentification) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIdentificationInput(
                    questionIndex: _currentQuestionIndex,
                    selectedAnswer: selectedAnswer,
                  ),
                  const Spacer(),
                ],
              );
            }

            final options = List<String>.from(
              question['options'] as List<dynamic>,
            );
            return ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
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
                      color: isSelected ? selectionColor : cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? ThemeHelper.getButtonGreen(context)
                            : borderColor,
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
                                ? ThemeHelper.getButtonGreen(context)
                                : borderColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                color: isSelected
                                    ? ThemeHelper.getInvertedTextColor(context)
                                    : textColor,
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
                              color: textColor,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: ThemeHelper.getPrimaryGreen(context),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }(),
        ),
      ],
    );
  }

  Widget _buildQuestionTypePill({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: ThemeHelper.getInvertedTextColor(context),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildIdentificationInput({
    required int questionIndex,
    required String? selectedAnswer,
  }) {
    final controller = _identificationControllers.putIfAbsent(
      questionIndex,
      () => TextEditingController(text: selectedAnswer ?? ''),
    );

    final latestValue = selectedAnswer ?? '';
    if (controller.text != latestValue) {
      controller.value = TextEditingValue(
        text: latestValue,
        selection: TextSelection.collapsed(offset: latestValue.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type your answer below:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          onChanged: (value) {
            _selectedAnswers[questionIndex] = value;
          },
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Enter your answer',
            filled: true,
            fillColor: ThemeHelper.getElevatedColor(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ThemeHelper.getBorderColor(context),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ThemeHelper.getPrimaryGreen(context),
                width: 2,
              ),
            ),
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
    final cardColor = ThemeHelper.getCardColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final selectionColor = ThemeHelper.getPrimaryGreen(
      context,
    ).withOpacity(ThemeHelper.isDarkMode(context) ? 0.3 : 0.15);
    final textColor = ThemeHelper.getTextColor(context);

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
          color: isSelected ? selectionColor : cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? ThemeHelper.getButtonGreen(context)
                : borderColor,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? ThemeHelper.getButtonGreen(context)
                  : textColor,
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
      if (_isAnswerCorrect(i)) {
        correctAnswers++;
        correctIndices.add(i); // Track the index of correct answers
      }
    }
    final score = (correctAnswers / _questions.length * 100).round();

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

  bool _isAnswerCorrect(int questionIndex) {
    final question = _questions[questionIndex];
    final userAnswer = _selectedAnswers[questionIndex];
    final correctAnswer = question['correctAnswer'];

    if (question['type'] == 'identification') {
      final normalizedUser = (userAnswer ?? '').trim().toLowerCase();
      final normalizedCorrect = (correctAnswer?.toString() ?? '')
          .trim()
          .toLowerCase();
      return normalizedUser.isNotEmpty && normalizedUser == normalizedCorrect;
    }

    return userAnswer == correctAnswer;
  }

  Widget _buildResultsView() {
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_isAnswerCorrect(i)) {
        correctAnswers++;
      }
    }
    final score = (correctAnswers / _questions.length * 100).round();
    final cardColor = ThemeHelper.getCardColor(context);
    final textColor = ThemeHelper.getTextColor(context);
    final successColor = ThemeHelper.getButtonGreen(context);
    final errorColor = ThemeHelper.getErrorColor(context);
    final accentColor = ThemeHelper.getSecondaryAccent(context);
    final passCircleColor = successColor.withOpacity(
      ThemeHelper.isDarkMode(context) ? 0.35 : 0.15,
    );
    final failCircleColor = errorColor.withOpacity(
      ThemeHelper.isDarkMode(context) ? 0.35 : 0.2,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: cardColor,
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: score >= 70 ? passCircleColor : failCircleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        score >= 70 ? 'PASSED' : 'FAILED',
                        style: TextStyle(
                          fontSize: score >= 70 ? 20 : 22,
                          fontWeight: FontWeight.bold,
                          color: score >= 70 ? successColor : errorColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You got $correctAnswers out of ${_questions.length} correct!',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  const SizedBox(height: 16),
                  // Time Spent Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(
                        ThemeHelper.isDarkMode(context) ? 0.25 : 0.2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accentColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, color: accentColor),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${_formatTimeSpent(_timeSpent)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
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
                        color: successColor.withOpacity(
                          ThemeHelper.isDarkMode(context) ? 0.25 : 0.2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: successColor.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars, color: successColor),
                          const SizedBox(width: 8),
                          Text(
                            '+$_xpEarned XP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: successColor,
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
                      backgroundColor: accentColor,
                      foregroundColor: ThemeHelper.getInvertedTextColor(
                        context,
                      ),
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
                      backgroundColor: ThemeHelper.getButtonGreen(context),
                      foregroundColor: ThemeHelper.getInvertedTextColor(
                        context,
                      ),
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
    final cardColor = ThemeHelper.getCardColor(context);
    final elevatedColor = ThemeHelper.getElevatedColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final textColor = ThemeHelper.getTextColor(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...(() {
                    final type = _questions[_currentQuestionIndex]['type'];
                    if (type == 'multiple_choice') {
                      return _questions[_currentQuestionIndex]['options']
                          .asMap()
                          .entries
                          .map(
                            (entry) => _buildReviewOption(
                              entry.value,
                              entry.key,
                              _currentQuestionIndex,
                            ),
                          )
                          .toList();
                    }
                    if (type == 'true_false') {
                      return _buildReviewTrueFalse(_currentQuestionIndex);
                    }
                    return [
                      _buildReviewIdentificationCard(_currentQuestionIndex),
                    ];
                  }()),
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
                      backgroundColor: elevatedColor,
                      foregroundColor: textColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: borderColor),
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
                      backgroundColor: elevatedColor,
                      foregroundColor: textColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: borderColor),
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
                backgroundColor: ThemeHelper.getButtonGreen(context),
                foregroundColor: ThemeHelper.getInvertedTextColor(context),
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
    final successColor = ThemeHelper.getButtonGreen(context);
    final errorColor = ThemeHelper.getErrorColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final textColor = ThemeHelper.getTextColor(context);
    final successBg = successColor.withOpacity(
      ThemeHelper.isDarkMode(context) ? 0.35 : 0.15,
    );
    final errorBg = errorColor.withOpacity(
      ThemeHelper.isDarkMode(context) ? 0.35 : 0.2,
    );

    Color bgColor = ThemeHelper.getCardColor(context);
    if (isCorrect || (isUnanswered && isCorrect)) {
      bgColor = successBg; // Green for correct
    } else if (isWrongAnswer) {
      bgColor = errorBg; // Red for wrong
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? successColor
              : isWrongAnswer
              ? errorColor
              : borderColor,
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
                  ? successColor
                  : isWrongAnswer
                  ? errorColor
                  : borderColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCorrect
                  ? Icon(
                      Icons.check,
                      color: ThemeHelper.getInvertedTextColor(context),
                      size: 20,
                    )
                  : isWrongAnswer
                  ? Icon(
                      Icons.close,
                      color: ThemeHelper.getInvertedTextColor(context),
                      size: 20,
                    )
                  : Text(
                      String.fromCharCode(65 + index),
                      style: TextStyle(
                        color: textColor,
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
                color: textColor,
              ),
            ),
          ),
          if (isUserAnswer && !isCorrect)
            Icon(Icons.error, color: errorColor, size: 24),
          if (isCorrect && isUserAnswer)
            Icon(Icons.check_circle, color: successColor, size: 24),
          if (isCorrect && !isUserAnswer && !isWrongAnswer)
            Icon(Icons.check_circle, color: successColor, size: 24),
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

  Widget _buildReviewIdentificationCard(int questionIndex) {
    final question = _questions[questionIndex];
    final correctAnswer = question['correctAnswer'].toString();
    final userAnswer = (_selectedAnswers[questionIndex] ?? '').trim();
    final isCorrect = _isAnswerCorrect(questionIndex);
    final isUnanswered = userAnswer.isEmpty;
    final cardColor = ThemeHelper.getCardColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final secondaryText = ThemeHelper.getSecondaryTextColor(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? ThemeHelper.getButtonGreen(context) : borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Answer',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          _buildIdentificationAnswerChip(
            text: isUnanswered ? 'No answer provided' : userAnswer,
            state: isUnanswered
                ? IdentificationAnswerState.unanswered
                : (isCorrect
                      ? IdentificationAnswerState.correct
                      : IdentificationAnswerState.incorrect),
          ),
          const SizedBox(height: 16),
          Text(
            'Correct Answer',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          _buildIdentificationAnswerChip(
            text: correctAnswer,
            state: IdentificationAnswerState.correct,
          ),
        ],
      ),
    );
  }

  Widget _buildIdentificationAnswerChip({
    required String text,
    required IdentificationAnswerState state,
  }) {
    final successColor = ThemeHelper.getButtonGreen(context);
    final errorColor = ThemeHelper.getErrorColor(context);
    final borderColorDefault = ThemeHelper.getBorderColor(context);
    final textColorDefault = ThemeHelper.getTextColor(context);
    final secondaryText = ThemeHelper.getSecondaryTextColor(context);

    Color bgColor;
    Color borderColor;
    Color textColor = textColorDefault;
    IconData? icon;

    switch (state) {
      case IdentificationAnswerState.correct:
        bgColor = successColor.withOpacity(
          ThemeHelper.isDarkMode(context) ? 0.35 : 0.2,
        );
        borderColor = successColor.withOpacity(0.6);
        textColor = successColor;
        icon = Icons.check_circle;
        break;
      case IdentificationAnswerState.incorrect:
        bgColor = errorColor.withOpacity(
          ThemeHelper.isDarkMode(context) ? 0.35 : 0.2,
        );
        borderColor = errorColor.withOpacity(0.7);
        textColor = errorColor;
        icon = Icons.error;
        break;
      case IdentificationAnswerState.unanswered:
        bgColor = ThemeHelper.getCardColor(context);
        borderColor = borderColorDefault;
        textColor = secondaryText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
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
    final successColor = ThemeHelper.getButtonGreen(context);
    final errorColor = ThemeHelper.getErrorColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final textColor = ThemeHelper.getTextColor(context);
    final successBg = successColor.withOpacity(
      ThemeHelper.isDarkMode(context) ? 0.35 : 0.15,
    );
    final errorBg = errorColor.withOpacity(
      ThemeHelper.isDarkMode(context) ? 0.35 : 0.2,
    );

    Color bgColor = ThemeHelper.getCardColor(context);
    if (isCorrect) {
      bgColor = successBg;
    } else if (isWrongAnswer) {
      bgColor = errorBg;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect
              ? successColor
              : isWrongAnswer
              ? errorColor
              : borderColor,
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
                  ? successColor
                  : isWrongAnswer
                  ? errorColor
                  : textColor,
            ),
          ),
          if (isCorrect) const SizedBox(width: 8),
          if (isCorrect) Icon(Icons.check_circle, color: successColor),
          if (isWrongAnswer) const SizedBox(width: 8),
          if (isWrongAnswer) Icon(Icons.error, color: errorColor),
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

enum IdentificationAnswerState { correct, incorrect, unanswered }
