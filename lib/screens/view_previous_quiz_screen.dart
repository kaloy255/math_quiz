import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6BBF59),
              const Color(0xFF5AA849).withValues(alpha: 0.5),
            ],
          ),
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
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: ResponsiveHelper.iconSize(context, 24),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: ResponsiveHelper.iconSize(context, 40),
                            height: ResponsiveHelper.iconSize(context, 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  ResponsiveHelper.borderRadius(context, 8),
                                ),
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
                          SizedBox(
                            width: ResponsiveHelper.spacing(context, 12),
                          ),
                          Text(
                            'MathQuest',
                            style: TextStyle(
                              color: Colors.white,
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
                      color: const Color(0xFFD4EDD0),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(context, 12),
                      ),
                      border: Border.all(color: Colors.black87, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: ResponsiveHelper.iconSize(context, 32),
                          height: ResponsiveHelper.iconSize(context, 32),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: ResponsiveHelper.iconSize(context, 20),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                        Text(
                          'VIEW',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
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
                            color: Colors.white,
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
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 8),
                            ),
                            Expanded(child: _buildQuarterFilterTab('3rd', 3)),
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 8),
                            ),
                            Expanded(child: _buildQuarterFilterTab('4th', 4)),
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
                      ? const Center(child: CircularProgressIndicator())
                      : _quizAttempts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: ResponsiveHelper.iconSize(context, 64),
                                color: Colors.grey[400],
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
                                  color: Colors.grey[600],
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
                                  color: Colors.black87,
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(context, 12),
                                  ),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    // Header Row
                                    _buildTableHeader(),
                                    Divider(height: 1, color: Colors.grey[300]),
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
                                              color: Colors.grey[300],
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
    return Container(
      padding: ResponsiveHelper.padding(
        context,
        horizontal: ResponsiveHelper.contentPadding(context),
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
                color: Colors.black87,
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
                color: Colors.black87,
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
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuarterFilterTab(String label, int? quarter) {
    final isSelected = _selectedQuarter == quarter;
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
              ? Colors.white
              : Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 8),
          ),
          border: Border.all(color: Colors.white, width: isSelected ? 2 : 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 12),
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF6BBF59) : Colors.white,
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
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              quizTitle,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
                color: Colors.black87,
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
                    color: (correctAnswers / totalQuestions * 100) >= 70
                        ? Colors.green[100]
                        : (correctAnswers / totalQuestions * 100) >= 50
                        ? Colors.orange[100]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 8),
                    ),
                  ),
                  child: Text(
                    '$correctAnswers/$totalQuestions',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: (correctAnswers / totalQuestions * 100) >= 70
                          ? Colors.green[900]
                          : (correctAnswers / totalQuestions * 100) >= 50
                          ? Colors.orange[900]
                          : Colors.red[900],
                    ),
                  ),
                ),
                if (_isFirstAttempt(attempt)) ...[
                  SizedBox(width: ResponsiveHelper.spacing(context, 6)),
                  Container(
                    width: ResponsiveHelper.iconSize(context, 24),
                    height: ResponsiveHelper.iconSize(context, 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6BBF59),
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
