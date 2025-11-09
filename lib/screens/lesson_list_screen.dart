import 'package:flutter/material.dart';
import 'lesson_content_screen.dart';
import 'pdf_viewer_screen.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

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
            'title': 'Introduction to Algebra',
            'pdf': 'assets/lessons/Quarter_1/M1_Q1 MATH.pdf',
          },
          {
            'id': '2',
            'title': 'Variables and Expressions',
            'pdf': 'assets/lessons/Quarter_1/M2_Q1 MATH.pdf',
          },
          {
            'id': '3',
            'title': 'Order of Operations',
            'pdf': 'assets/lessons/Quarter_1/M3_Q1 MATH.pdf',
          },
          {
            'id': '4',
            'title': 'Properties of Real Numbers',
            'pdf': 'assets/lessons/Quarter_1/M4_Q1 MATH.pdf',
          },
          {
            'id': '5',
            'title': 'Solving One-Step Equations',
            'pdf': 'assets/lessons/Quarter_1/M5_Q1 MATH.pdf',
          },
          {
            'id': '6',
            'title': 'Solving Multi-Step Equations',
            'pdf': 'assets/lessons/Quarter_1/M6_Q1 MATH.PDF',
          },
          {
            'id': '7',
            'title': 'Working with Fractions in Equations',
            'pdf': 'assets/lessons/Quarter_1/M7_Q1 MATH.pdf',
          },
          {
            'id': '8',
            'title': 'Word Problems with Equations',
            'pdf': 'assets/lessons/Quarter_1/M8_Q1 MATH.pdf',
          },
          {
            'id': '9',
            'title': 'Review and Practice Problems',
            'pdf': 'assets/lessons/Quarter_1/M9_Q1 MATH.pdf',
          },
        ];
      case 2:
        return []; // Empty - no lessons added yet
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
      case 3:
        return '3RD QUARTER';
      case 4:
        return '4TH QUARTER';
      default:
        return '';
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
              // Top Header
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
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: ResponsiveHelper.iconSize(context, 24),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
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
                              color: ThemeHelper.getCardColor(context),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  color: ThemeHelper.getTextColor(context),
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
                                    color: ThemeHelper.getTextColor(context),
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
                              color: ThemeHelper.getCardColor(context),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 16),
                              ),
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
                                  color: ThemeHelper.getTextColor(context),
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
                                        color: ThemeHelper.getTextColor(
                                          context,
                                        ),
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
                                        color:
                                            ThemeHelper.getSecondaryTextColor(
                                              context,
                                            ),
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
                      onTap: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
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

  Widget _buildLessonItem({
    required int lessonNumber,
    required String lessonTitle,
    required String lessonId,
  }) {
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
          color: ThemeHelper.isDarkMode(context)
              ? const Color(0xFF161B22)
              : const Color(0xFFF0F8E6), // Light yellow-green
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 12),
          ),
          border: Border.all(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
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
                  color: ThemeHelper.getTextColor(context),
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
                color: const Color(0xFF6BBF59),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'START →',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 13),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
