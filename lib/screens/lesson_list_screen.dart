import 'package:flutter/material.dart';
import 'lesson_content_screen.dart';
import 'pdf_viewer_screen.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';
import '../widgets/app_logo.dart';

class LessonListScreen extends StatefulWidget {
  final int quarterNumber;

  const LessonListScreen({super.key, required this.quarterNumber});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  List<Map<String, String>> get _lessons =>
      _getLessonsForQuarter(widget.quarterNumber);

  List<Map<String, String>> _getLessonsForQuarter(int quarter) {
    switch (quarter) {
      case 1:
        return [
          {
            'id': '1',
            'title': 'Quadratic Equations',
            'pdf': 'assets/lessons/Quarter_1/M1_Q1 MATH.pdf',
          },
          {
            'id': '2',
            'title':
                'The Nature of the Roots of a QuadraticEquation \n\n The Sum and Product of the Roots of Quadratic Equations',
            'pdf': 'assets/lessons/Quarter_1/M2_Q1 MATH.pdf',
          },
          {
            'id': '3',
            'title': 'Solve Equations Transformable to Quadratic Equation',
            'pdf': 'assets/lessons/Quarter_1/M3_Q1 MATH.pdf',
          },
          {
            'id': '4',
            'title': 'Word Problems Involving Quadratic and Rational Equations',
            'pdf': 'assets/lessons/Quarter_1/M4_Q1 MATH.pdf',
          },
          {
            'id': '5',
            'title': 'Quadratic Inequalities',
            'pdf': 'assets/lessons/Quarter_1/M5_Q1 MATH.pdf',
          },
          {
            'id': '6',
            'title':
                'Models Real-Life Situations Using Quadratic Functions & \n\nRepresent A Quadratic Function using: \na. Table of Values, \nb. Graph, and \nc. Equation.',
            'pdf': 'assets/lessons/Quarter_1/M6_Q1 MATH.PDF',
          },
          {
            'id': '7',
            'title': 'Vertex Form of the Quadratic Function',
            'pdf': 'assets/lessons/Quarter_1/M7_Q1 MATH.pdf',
          },
          {
            'id': '8',
            'title': 'Graph of Quadratic Function',
            'pdf': 'assets/lessons/Quarter_1/M8_Q1 MATH.pdf',
          },
          {
            'id': '9',
            'title': 'Finding Equation of a Quadratic Function',
            'pdf': 'assets/lessons/Quarter_1/M9_Q1 MATH.pdf',
          },
        ];
      case 2:
        return [
          {
            'id': '1',
            'title': 'Direct and Inverse Variations',
            'pdf': 'assets/lessons/Quarter_2/M1_Q1 MATH.pdf',
          },
          {
            'id': '2',
            'title': 'Joint and Combined Variations',
            'pdf': 'assets/lessons/Quarter_2/M2_Q1 MATH.pdf',
          },
          {
            'id': '3',
            'title': 'Simplifying Expressions Involving Integral Exponents',
            'pdf': 'assets/lessons/Quarter_2/M3_Q1 MATH.pdf',
          },
          {
            'id': '4',
            'title': ' Simplifying Expressions Involving Rational Exponents',
            'pdf': 'assets/lessons/Quarter_2/M4_Q1 MATH.pdf',
          },
          {
            'id': '5',
            'title': 'Radical Expressions',
            'pdf': 'assets/lessons/Quarter_2/M5_Q1 MATH.pdf',
          },
          {
            'id': '6',
            'title': 'Operations on Radical Expressions',
            'pdf': 'assets/lessons/Quarter_2/M6_Q1 MATH.PDF',
          },
          {
            'id': '7',
            'title': 'Operations on Radical Expressions',
            'pdf': 'assets/lessons/Quarter_2/M7_Q1 MATH.pdf',
          },
          {
            'id': '8',
            'title': 'Solving Radical Equations',
            'pdf': 'assets/lessons/Quarter_2/M8_Q1 MATH.pdf',
          },
          {
            'id': '9',
            'title': 'Problem Solving Involving Radical Expressions',
            'pdf': 'assets/lessons/Quarter_2/M9_Q1 MATH.pdf',
          },
        ]; // Empty - no lessons added yet
      case 3:
        return []; // Empty - no lessons added yet
      case 4:
        return []; // Empty - no lessons added yet
      default:
        return [];
    }
  }

  String _getQuarterTitle(int quarter) {
    switch (quarter) {
      case 1:
        return '1ST QUARTER';
      case 2:
        return '2ND QUARTER';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.getTextColor(context);
    final secondaryTextColor = ThemeHelper.getSecondaryTextColor(context);
    final cardColor = ThemeHelper.getCardColor(context);
    final elevatedColor = ThemeHelper.getElevatedColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);

    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: textColor,
                        size: ResponsiveHelper.iconSize(context, 24),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        AppLogo(
                          backgroundColor: elevatedColor,
                          withGlow: isDark,
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                        Text(
                          'MathQuest',
                          style: TextStyle(
                            color: textColor,
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
                        color: elevatedColor.withOpacity(isDark ? 0.6 : 0.2),
                        shape: BoxShape.circle,
                        boxShadow: ThemeHelper.getElevation(context, 4),
                      ),
                      child: Icon(
                        Icons.person,
                        color: textColor,
                        size: ResponsiveHelper.iconSize(context, 24),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
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
                        children: [
                          // LESSONS Card
                          Container(
                            padding: ResponsiveHelper.padding(
                              context,
                              vertical: 20,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 16),
                              ),
                              border: Border.all(color: borderColor),
                              boxShadow: ThemeHelper.getElevation(context, 4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  color: textColor,
                                  size: ResponsiveHelper.iconSize(context, 32),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.spacing(context, 12),
                                ),
                                Text(
                                  'LESSONS',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      24,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 20),
                          ),

                          // Quarter Title Card
                          Container(
                            padding: ResponsiveHelper.padding(
                              context,
                              vertical: 15,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: elevatedColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 16),
                              ),
                              border: Border.all(color: borderColor),
                              boxShadow: ThemeHelper.getElevation(context, 3),
                            ),
                            child: Center(
                              child: Text(
                                _getQuarterTitle(widget.quarterNumber),
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    20,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 24),
                          ),

                          // Lesson List
                          if (_lessons.isEmpty)
                            Padding(
                              padding: ResponsiveHelper.padding(
                                context,
                                all: 32,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book_outlined,
                                      size: ResponsiveHelper.iconSize(
                                        context,
                                        64,
                                      ),
                                      color: ThemeHelper.getSecondaryTextColor(
                                        context,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.spacing(
                                        context,
                                        24,
                                      ),
                                    ),
                                    Text(
                                      'No lessons available',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.fontSize(
                                          context,
                                          20,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.spacing(
                                        context,
                                        12,
                                      ),
                                    ),
                                    Text(
                                      'Lessons for this quarter will be added soon.',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.fontSize(
                                          context,
                                          16,
                                        ),
                                        color: secondaryTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Column(
                              children: List.generate(
                                _lessons.length,
                                (index) => _buildLessonItem(
                                  lessonNumber: index + 1,
                                  lessonTitle: _lessons[index]['title']!,
                                  lessonId: _lessons[index]['id']!,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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
                  boxShadow: ThemeHelper.getElevation(context, 6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home,
                            color: secondaryTextColor,
                            size: ResponsiveHelper.iconSize(context, 32),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 4),
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: secondaryTextColor,
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
                          color: textColor,
                          size: ResponsiveHelper.iconSize(context, 32),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                        Text(
                          'Users',
                          style: TextStyle(
                            color: textColor,
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

  Widget _buildLessonItem({
    required int lessonNumber,
    required String lessonTitle,
    required String lessonId,
  }) {
    final textColor = ThemeHelper.getTextColor(context);
    final cardColor = ThemeHelper.getCardColor(context);
    final borderColor = ThemeHelper.getBorderColor(context);
    final accentColor = ThemeHelper.getPrimaryGreen(context);
    final isDark = ThemeHelper.isDarkMode(context);

    // Check if this lesson has a PDF
    final lessonData = _lessons.firstWhere(
      (lesson) => lesson['id'] == lessonId,
      orElse: () => {},
    );
    final hasPdf = lessonData.containsKey('pdf') && lessonData['pdf'] != null;

    return GestureDetector(
      onTap: () {
        if (hasPdf) {
          // Navigate to PDF viewer
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                pdfPath: lessonData['pdf']!,
                lessonTitle: lessonTitle,
              ),
            ),
          );
        } else {
          // Navigate to text content screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonContentScreen(
                lessonTitle: lessonTitle,
                lessonId: lessonId,
              ),
            ),
          );
        }
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'LESSON $lessonNumber: $lessonTitle',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 16),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Container(
              padding: ResponsiveHelper.padding(
                context,
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 8),
                ),
                boxShadow: ThemeHelper.getElevation(context, 3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'START →',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 13),
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
