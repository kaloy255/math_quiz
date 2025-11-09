import 'package:flutter/material.dart';
import 'quiz_taking_screen.dart';
import '../services/database_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class QuizSelectionScreen extends StatefulWidget {
  const QuizSelectionScreen({super.key});

  @override
  State<QuizSelectionScreen> createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {
  int _selectedQuarter = 1;

  // Get quizzes for selected quarter
  List<Map<String, String>> get _quizzes =>
      _getQuizzesForQuarter(_selectedQuarter);

  // Static quiz data for each quarter
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
              // Top Header with green gradient
              Container(
                width: double.infinity,
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: ResponsiveHelper.contentPadding(context),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // M Logo
                        Container(
                          width: ResponsiveHelper.iconSize(context, 40),
                          height: ResponsiveHelper.iconSize(context, 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(context, 8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'M',
                              style: TextStyle(
                                color: const Color(0xFF6BBF59),
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  24,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                        Text(
                          'MathQuest',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(context, 24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: ResponsiveHelper.iconSize(context, 40),
                      height: ResponsiveHelper.iconSize(context, 40),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: ResponsiveHelper.iconSize(context, 24),
                      ),
                    ),
                  ],
                ),
              ),

              // Title Card
              Container(
                margin: ResponsiveHelper.margin(
                  context,
                  all: ResponsiveHelper.contentPadding(context),
                ),
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4EDD0),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(context, 12),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'ALGEBRA QUIZ',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 28),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                    Text(
                      'Timed quizzes with instant Scoring',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Mathie Character (Behind quiz list, Right side, scrolls with content)
                      Positioned(
                        top: ResponsiveHelper.height(context, 55),
                        right: 0,
                        child: Image.asset(
                          'assets/images/mathie/quiz_list_mathie.png',
                          width: ResponsiveHelper.width(context, 160),
                          height: ResponsiveHelper.height(context, 160),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: ResponsiveHelper.width(context, 160),
                              height: ResponsiveHelper.height(context, 160),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6BBF59),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(context, 80),
                                ),
                              ),
                              child: Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.white,
                                size: ResponsiveHelper.iconSize(context, 80),
                              ),
                            );
                          },
                        ),
                      ),
                      // Content Column (On top of Mathie)
                      Padding(
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
                              // Quarter Selection
                              Text(
                                'QUARTER/PERIOD:',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    14,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveHelper.spacing(context, 8),
                              ),
                              Row(
                                children: [
                                  Expanded(child: _buildQuarterTab('1ST', 1)),
                                  SizedBox(
                                    width: ResponsiveHelper.spacing(context, 8),
                                  ),
                                  Expanded(child: _buildQuarterTab('2nd', 2)),
                                  SizedBox(
                                    width: ResponsiveHelper.spacing(context, 8),
                                  ),
                                  Expanded(child: _buildQuarterTab('3rd', 3)),
                                  SizedBox(
                                    width: ResponsiveHelper.spacing(context, 8),
                                  ),
                                  Expanded(child: _buildQuarterTab('4th', 4)),
                                ],
                              ),
                              SizedBox(
                                height: ResponsiveHelper.spacing(context, 24),
                              ),

                              // Quizzes List
                              Text(
                                'QUIZZES:',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    14,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveHelper.spacing(context, 12),
                              ),

                              // Quiz items
                              _quizzes.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: ResponsiveHelper.padding(
                                          context,
                                          all: 40,
                                        ),
                                        child: Text(
                                          'No quizzes available for this quarter.',
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.fontSize(
                                              context,
                                              16,
                                            ),
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: List.generate(
                                        _quizzes.length,
                                        (index) => _buildQuizItem(
                                          quizNumber: index + 1,
                                          quizTitle: _quizzes[index]['title']!,
                                          quizId: _quizzes[index]['id']!,
                                        ),
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

              // Bottom Navigation Bar
              Container(
                width: double.infinity,
                padding: ResponsiveHelper.padding(
                  context,
                  all: ResponsiveHelper.contentPadding(context),
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6BBF59), Color(0xFF5AA849)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.white70,
                            size: ResponsiveHelper.iconSize(context, 32),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 4),
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.white,
                          size: ResponsiveHelper.iconSize(context, 32),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                        Text(
                          'Users',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ],
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

  Widget _buildQuarterTab(String label, int quarter) {
    final isSelected = _selectedQuarter == quarter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedQuarter = quarter;
        });
      },
      child: Container(
        padding: ResponsiveHelper.padding(context, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6BBF59) : const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 8),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 14),
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  int _getTimeLimitForQuiz(String quizId) {
    switch (quizId) {
      case '1':
        return 480; // 8 minutes - Introduction
      case '2':
        return 600; // 10 minutes - Basic concepts
      case '3':
        return 540; // 9 minutes - Operations
      case '4':
        return 660; // 11 minutes - Simplifying
      case '5':
        return 600; // 10 minutes - Evaluation
      case '6':
        return 720; // 12 minutes - Advanced
      case '7':
        return 780; // 13 minutes - Review/Complex
      default:
        return 600;
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    return '${minutes}min';
  }

  int _getTotalQuestionsForQuiz(String quizId) {
    return 7; // All quizzes have 7 questions for now
  }

  Widget _buildQuizItem({
    required int quizNumber,
    required String quizTitle,
    required String quizId,
  }) {
    final timeLimit = _getTimeLimitForQuiz(quizId);
    final totalQuestions = _getTotalQuestionsForQuiz(quizId);
    // Create unique quiz ID by combining quizId with quarter
    final uniqueQuizId = '$quizId-Q$_selectedQuarter';
    final remainingXP = DatabaseService.getRemainingXPForQuiz(
      uniqueQuizId,
      totalQuestions,
    );
    final xpEarned = DatabaseService.getXPEarnedFromFirstAttempt(
      uniqueQuizId,
      _selectedQuarter.toString(),
    );

    return GestureDetector(
      onTap: () async {
        // Navigate to quiz taking
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizTakingScreen(
              quizTitle: quizTitle,
              quarter: _selectedQuarter.toString(),
              quizId: quizId,
            ),
          ),
        );
        // Reload the state to show updated scores
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(context, 12)),
        padding: ResponsiveHelper.cardPadding(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 12),
          ),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QUIZ $quizNumber: $quizTitle',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                      // XP, Time, and Score indicators
                      Wrap(
                        spacing: ResponsiveHelper.spacing(context, 8),
                        runSpacing: ResponsiveHelper.spacing(context, 8),
                        children: [
                          Container(
                            padding: ResponsiveHelper.padding(
                              context,
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: remainingXP > 0
                                  ? Colors.orange[300]
                                  : const Color(0xFF6BBF59),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.stars,
                                  color: Colors.white,
                                  size: ResponsiveHelper.iconSize(context, 14),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.spacing(context, 4),
                                ),
                                Text(
                                  remainingXP > 0
                                      ? '$remainingXP XP Left'
                                      : xpEarned > 0
                                      ? '$xpEarned XP Earned'
                                      : '0 XP',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      12,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: ResponsiveHelper.padding(
                              context,
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[200],
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                  size: ResponsiveHelper.iconSize(context, 14),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.spacing(context, 4),
                                ),
                                Text(
                                  _formatTime(timeLimit),
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      12,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: ResponsiveHelper.padding(
                    context,
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 20),
                    ),
                    border: Border.all(color: Colors.black87, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'START',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(context, 4)),
                      Icon(
                        Icons.arrow_forward,
                        size: ResponsiveHelper.iconSize(context, 16),
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
