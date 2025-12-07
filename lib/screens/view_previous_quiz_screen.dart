import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';
import '../widgets/app_logo.dart';

class ViewPreviousQuizScreen extends StatefulWidget {
  const ViewPreviousQuizScreen({super.key});

  @override
  State<ViewPreviousQuizScreen> createState() => _ViewPreviousQuizScreenState();
}

class _ViewPreviousQuizScreenState extends State<ViewPreviousQuizScreen> {
  List<Map<String, dynamic>> _allQuizAttempts = [];
  List<Map<String, dynamic>> _quizAttempts = [];
  bool _isLoading = true;
  int? _selectedQuarter; // null means "All"

  @override
  void initState() {
    super.initState();
    _loadQuizAttempts();
  }

  void _loadQuizAttempts() {
    setState(() {
      _allQuizAttempts = DatabaseService.getUserQuizAttempts();
      _applyFilter();
      _isLoading = false;
    });
  }

  void _applyFilter() {
    if (_selectedQuarter == null) {
      // Show all attempts
      _quizAttempts = _allQuizAttempts;
    } else {
      // Filter by quarter
      _quizAttempts = _allQuizAttempts.where((attempt) {
        final quizId = attempt['quizId'] as String? ?? '';
        if (quizId.isNotEmpty) {
          // Extract quarter from quizId format: "quizId-Qquarter"
          final parts = quizId.split('-Q');
          if (parts.length >= 2) {
            try {
              final quarter = int.parse(parts[1]);
              return quarter == _selectedQuarter;
            } catch (e) {
              // Also check the quarter field directly if available
              final quarter = attempt['quarter'] as String?;
              if (quarter != null) {
                try {
                  return int.parse(quarter) == _selectedQuarter;
                } catch (e) {
                  return false;
                }
              }
              return false;
            }
          }
        }
        // Fallback: check quarter field directly
        final quarter = attempt['quarter'] as String?;
        if (quarter != null) {
          try {
            return int.parse(quarter) == _selectedQuarter;
          } catch (e) {
            return false;
          }
        }
        return false;
      }).toList();
    }

    // Sort by completedAt date (earliest first)
    _quizAttempts.sort((a, b) {
      final dateA = a['completedAt'];
      final dateB = b['completedAt'];
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      if (dateA is DateTime && dateB is DateTime) {
        return dateA.compareTo(dateB);
      }
      return 0;
    });
  }

  bool _isFirstAttempt(Map<String, dynamic> attempt) {
    final quizId = attempt['quizId'] as String? ?? '';
    if (quizId.isEmpty) return false;

    // Find all attempts for this quiz
    final quizAttempts = _quizAttempts
        .where((a) => a['quizId'] == quizId)
        .toList();

    if (quizAttempts.isEmpty) return false;

    // Sort by completedAt to find the earliest
    quizAttempts.sort((a, b) {
      final dateA = a['completedAt'];
      final dateB = b['completedAt'];
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      if (dateA is DateTime && dateB is DateTime) {
        return dateA.compareTo(dateB);
      }
      return 0;
    });

    // Check if this attempt is the first one (earliest date)
    final attemptDate = attempt['completedAt'];
    if (attemptDate == null) return false;

    final firstAttemptDate = quizAttempts.first['completedAt'];
    if (firstAttemptDate == null) return false;

    // Compare dates - if this attempt's date matches the earliest, it's the first
    if (attemptDate is DateTime && firstAttemptDate is DateTime) {
      return attemptDate.compareTo(firstAttemptDate) == 0;
    }

    return quizAttempts.first == attempt;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.getTextColor(context);
    final secondaryText = ThemeHelper.getSecondaryTextColor(context);
    final primaryGreen = ThemeHelper.getPrimaryGreen(context);
    final cardColor = ThemeHelper.getCardColor(context);
    final elevatedColor = ThemeHelper.getElevatedColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final containerColor = ThemeHelper.getContainerColor(context);
    final dividerColor = ThemeHelper.getDividerColor(context);

    return Scaffold(
      backgroundColor: containerColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: ResponsiveHelper.contentPadding(context),
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: ThemeHelper.getHeaderGradient(context),
                  boxShadow: ThemeHelper.getElevation(context, 6),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: textColor,
                        size: ResponsiveHelper.iconSize(context, 24),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          AppLogo(
                            backgroundColor: elevatedColor,
                            withGlow: ThemeHelper.isDarkMode(context),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.spacing(context, 12),
                          ),
                          Text(
                            'MathQuest',
                            style: TextStyle(
                              color: textColor,
                              fontSize: ResponsiveHelper.fontSize(context, 20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // View Button and Quarter Filter
              Column(
                children: [
                  Container(
                    margin: ResponsiveHelper.margin(
                      context,
                      horizontal: ResponsiveHelper.contentPadding(context),
                      vertical: 12,
                    ),
                    padding: ResponsiveHelper.padding(
                      context,
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(context, 12),
                      ),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: ResponsiveHelper.iconSize(context, 32),
                          height: ResponsiveHelper.iconSize(context, 32),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.visibility,
                            color: ThemeHelper.getInvertedTextColor(context),
                            size: ResponsiveHelper.iconSize(context, 20),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                        Text(
                          'VIEW',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 16),
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quarter Filter
                  Padding(
                    padding: ResponsiveHelper.padding(
                      context,
                      horizontal: ResponsiveHelper.contentPadding(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FILTER BY QUARTER:',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuarterFilterTab('ALL', null),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 8),
                            ),
                            Expanded(child: _buildQuarterFilterTab('1ST', 1)),
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 8),
                            ),
                            Expanded(child: _buildQuarterFilterTab('2nd', 2)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Main Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeHelper.getContainerColor(context),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        ResponsiveHelper.borderRadius(context, 20),
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryGreen,
                            ),
                          ),
                        )
                      : _quizAttempts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: ResponsiveHelper.iconSize(context, 64),
                                color: secondaryText.withOpacity(0.4),
                              ),
                              SizedBox(
                                height: ResponsiveHelper.spacing(context, 16),
                              ),
                              Text(
                                'No quiz attempts yet',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    18,
                                  ),
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            // Title
                            Container(
                              width: double.infinity,
                              padding: ResponsiveHelper.padding(
                                context,
                                all: ResponsiveHelper.contentPadding(context),
                              ),
                              child: Text(
                                'VIEW PREVIOUS QUIZ TAKEN',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    18,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),

                            // Table
                            Expanded(
                              child: Container(
                                margin: ResponsiveHelper.margin(
                                  context,
                                  horizontal: ResponsiveHelper.contentPadding(
                                    context,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(context, 12),
                                  ),
                                  border: Border.all(color: borderColor),
                                ),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    // Header Row
                                    _buildTableHeader(),
                                    Divider(height: 1, color: dividerColor),
                                    // Data Rows
                                    ...List.generate(
                                      _quizAttempts.length,
                                      (index) => Column(
                                        children: [
                                          _buildTableRow(
                                            _quizAttempts[index],
                                            index,
                                          ),
                                          if (index < _quizAttempts.length - 1)
                                            Divider(
                                              height: 1,
                                              color: dividerColor,
                                            ),
                                        ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    final textColor = ThemeHelper.getTextColor(context);
    final headerBg = ThemeHelper.getElevatedColor(context);

    return Container(
      padding: ResponsiveHelper.padding(
        context,
        horizontal: ResponsiveHelper.contentPadding(context),
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: headerBg,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.borderRadius(context, 12)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Quiz No.',
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Quiz Name',
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Score',
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuarterFilterTab(String label, int? quarter) {
    final isSelected = _selectedQuarter == quarter;
    final isDark = ThemeHelper.isDarkMode(context);
    final baseColor = ThemeHelper.getElevatedColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final selectedTextColor = ThemeHelper.getPrimaryGreen(context);
    final unselectedTextColor = isDark
        ? ThemeHelper.getTextColor(context).withOpacity(0.9)
        : ThemeHelper.getSecondaryTextColor(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedQuarter = quarter;
          _applyFilter();
        });
      },
      child: Container(
        padding: ResponsiveHelper.padding(context, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? baseColor
              : baseColor.withOpacity(isDark ? 0.3 : 0.6),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 8),
          ),
          border: Border.all(
            color: isSelected ? selectedTextColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 12),
              fontWeight: FontWeight.bold,
              color: isSelected ? selectedTextColor : unselectedTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> attempt, int index) {
    // Extract quiz number from quiz ID (format: "quizId-Qquarter")
    String quizNumber = '?';

    final quizId = attempt['quizId'] as String? ?? '';
    if (quizId.isNotEmpty) {
      final parts = quizId.split('-Q');
      if (parts.isNotEmpty) {
        quizNumber = parts[0];
      }
    }

    final quizTitle = attempt['quizTitle'] as String? ?? 'Unknown Quiz';
    final correctAnswers = attempt['correctAnswers'] as int? ?? 0;
    final totalQuestions = attempt['totalQuestions'] as int? ?? 0;
    final textColor = ThemeHelper.getTextColor(context);

    final scorePercent =
        totalQuestions == 0 ? 0.0 : (correctAnswers / totalQuestions) * 100;
    String status;
    if (scorePercent >= 70) {
      status = 'success';
    } else if (scorePercent >= 50) {
      status = 'warning';
    } else {
      status = 'error';
    }

    final statusBg = ThemeHelper.getStatusBackground(context, status);
    final statusTextColor = status == 'success'
        ? ThemeHelper.getSuccessColor(context)
        : status == 'warning'
            ? ThemeHelper.getWarningColor(context)
            : ThemeHelper.getErrorColor(context);

    return Container(
      padding: ResponsiveHelper.padding(
        context,
        horizontal: ResponsiveHelper.contentPadding(context),
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              quizNumber,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              quizTitle,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: ResponsiveHelper.padding(
                    context,
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 8),
                    ),
                  ),
                  child: Text(
                    '$correctAnswers/$totalQuestions',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: statusTextColor,
                    ),
                  ),
                ),
                if (_isFirstAttempt(attempt)) ...[
                  SizedBox(width: ResponsiveHelper.spacing(context, 6)),
                  Container(
                    width: ResponsiveHelper.iconSize(context, 24),
                    height: ResponsiveHelper.iconSize(context, 24),
                    decoration: BoxDecoration(
                      color: ThemeHelper.getPrimaryGreen(context),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(context, 4),
                      ),
                    ),
                    child: Icon(
                      Icons.star,
                      size: ResponsiveHelper.iconSize(context, 14),
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
