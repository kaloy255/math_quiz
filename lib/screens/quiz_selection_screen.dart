import 'package:flutter/material.dart';
import 'quiz_taking_screen.dart';
import '../services/database_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';

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
        return [];
      case 4:
        return [];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Title Card
              Padding(
                padding: ResponsiveHelper.padding(
                  context,
                  all: ResponsiveHelper.contentPadding(context),
                ),
                child: CustomCard(
                  withGlow: true,
                  child: Column(
                    children: [
                      Text(
                        'ALGEBRA QUIZ',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 28),
                          fontWeight: FontWeight.bold,
                          color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                      Text(
                        'Timed quizzes with instant Scoring',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                          color: ThemeHelper.getSecondaryTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Mathie Character (Behind quiz list, Right side, scrolls with content)
                      // Only visible when there are quizzes available
                      if (_quizzes.isNotEmpty)
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
                                  color: ThemeHelper.getTextColor(context),
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
                                  color: ThemeHelper.getTextColor(context),
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
                                            color:
                                                ThemeHelper.getSecondaryTextColor(
                                                  context,
                                                ),
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
                decoration: BoxDecoration(
                  gradient: ThemeHelper.getHeaderGradient(context),
                  boxShadow: ThemeHelper.getElevation(context, 4),
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
                            color: ThemeHelper.getSecondaryTextColor(context),
                            size: ResponsiveHelper.iconSize(context, 32),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 4),
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: ThemeHelper.getSecondaryTextColor(context),
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
                          color: ThemeHelper.getTextColor(context),
                          size: ResponsiveHelper.iconSize(context, 32),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                        Text(
                          'Users',
                          style: TextStyle(
                            color: ThemeHelper.getTextColor(context),
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
    final isDark = ThemeHelper.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedQuarter = quarter;
        });
      },
      child: Container(
        padding: ResponsiveHelper.padding(context, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeHelper.getButtonGreen(context)
              : (isDark
                    ? ThemeHelper.getCardColor(context)
                    : const Color(0xFFD4EDD0)),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 8),
          ),
          border: isDark
              ? Border.all(
                  color: isSelected
                      ? ThemeHelper.getPrimaryGreen(context)
                      : ThemeHelper.getBorderColor(context),
                  width: isSelected ? 2 : 1,
                )
              : null,
          boxShadow: isDark && isSelected
              ? ThemeHelper.getGlow(
                  context,
                  color: ThemeHelper.getPrimaryGreen(context),
                )
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 14),
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : ThemeHelper.getTextColor(context),
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
    if (_selectedQuarter == 1 && quizId == '1') {
      return 20;
    }
    return 7; // Default for other quizzes
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
    final isDark = ThemeHelper.isDarkMode(context);
    final cardColor = ThemeHelper.getCardColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final textColor = ThemeHelper.getTextColor(context);
    final successColor = ThemeHelper.getSuccessColor(context);
    final warningColor = ThemeHelper.getWarningColor(context);
    final xpColor = remainingXP > 0 ? warningColor : successColor;
    final xpTextColor = ThemeHelper.getInvertedTextColor(context);
    final timerBg = isDark
        ? ThemeHelper.getElevatedColor(context)
        : Colors.orange[200]!;
    final timerTextColor = isDark
        ? warningColor
        : ThemeHelper.getInvertedTextColor(context);
    final startBg = ThemeHelper.getElevatedColor(context);

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
          color: cardColor,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 12),
          ),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: ThemeHelper.getElevation(context, 2),
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
                          color: textColor,
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
                              color: xpColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 8),
                              ),
                              boxShadow: ThemeHelper.isDarkMode(context)
                                  ? ThemeHelper.getGlow(
                                      context,
                                      color: xpColor,
                                      blur: 4,
                                    )
                                  : null,
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
                                    color: xpTextColor,
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
                              color: timerBg,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 8),
                              ),
                              border: ThemeHelper.isDarkMode(context)
                                  ? Border.all(
                                      color: warningColor.withOpacity(0.4),
                                      width: 1.2,
                                    )
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: timerTextColor,
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
                                    color: timerTextColor,
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
                    color: startBg,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 20),
                    ),
                    border: Border.all(
                      color: ThemeHelper.getPrimaryGreen(context),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'START',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                          fontWeight: FontWeight.bold,
                          color: ThemeHelper.getPrimaryGreen(context),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(context, 4)),
                      Icon(
                        Icons.arrow_forward,
                        size: ResponsiveHelper.iconSize(context, 16),
                        color: ThemeHelper.getPrimaryGreen(context),
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
