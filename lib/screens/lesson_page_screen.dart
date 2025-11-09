import 'package:flutter/material.dart';
import 'lesson_list_screen.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class LessonPageScreen extends StatefulWidget {
  const LessonPageScreen({super.key});

  @override
  State<LessonPageScreen> createState() => _LessonPageScreenState();
}

class _LessonPageScreenState extends State<LessonPageScreen> {
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
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // LESSONS Card
                              Container(
                                padding: ResponsiveHelper.padding(
                                  context,
                                  vertical: 20,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4EDD0),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(context, 16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book_outlined,
                                      color: Colors.black87,
                                      size: ResponsiveHelper.iconSize(
                                        context,
                                        32,
                                      ),
                                    ),
                                    SizedBox(
                                      width: ResponsiveHelper.spacing(
                                        context,
                                        12,
                                      ),
                                    ),
                                    Text(
                                      'LESSONS',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.fontSize(
                                          context,
                                          24,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveHelper.spacing(context, 32),
                              ),

                              // Quarter Buttons in 2x2 Grid
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuarterButton(
                                      context,
                                      '1ST',
                                      'QUARTER',
                                      1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: ResponsiveHelper.spacing(
                                      context,
                                      16,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildQuarterButton(
                                      context,
                                      '2ND',
                                      'QUARTER',
                                      2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ResponsiveHelper.spacing(context, 16),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuarterButton(
                                      context,
                                      '3RD',
                                      'QUARTER',
                                      3,
                                    ),
                                  ),
                                  SizedBox(
                                    width: ResponsiveHelper.spacing(
                                      context,
                                      16,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildQuarterButton(
                                      context,
                                      '4TH',
                                      'QUARTER',
                                      4,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ResponsiveHelper.height(context, 180),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Mathie Character with Speech Bubble
                      Positioned(
                        bottom: ResponsiveHelper.height(context, -50),
                        left: ResponsiveHelper.width(context, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Mathie Character (Facing right, slightly rotated)
                            Transform.rotate(
                              angle: -0.2,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.diagonal3Values(-1, 1, 1),
                                child: Image.asset(
                                  'assets/images/mathie/quiz_list_mathie.png',
                                  width: ResponsiveHelper.width(context, 180),
                                  height: ResponsiveHelper.height(context, 180),
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.pets,
                                      size: ResponsiveHelper.iconSize(
                                        context,
                                        80,
                                      ),
                                      color: const Color(0xFF6BBF59),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Speech Bubble (Positioned to align with Mathie's mouth/head area)
                            Transform.translate(
                              offset: Offset(
                                ResponsiveHelper.spacing(context, -85),
                                ResponsiveHelper.spacing(context, -70),
                              ),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.diagonal3Values(-1, 1, 1),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: ResponsiveHelper.width(
                                      context,
                                      460,
                                    ),
                                  ),
                                  padding: ResponsiveHelper.padding(
                                    context,
                                    horizontal: 50,
                                    vertical: 80,
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/mathie/bubble_chat.png',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.diagonal3Values(
                                      -1,
                                      1,
                                      1,
                                    ),
                                    child: Text(
                                      'Here are the\nresources you\nmight need..',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.fontSize(
                                          context,
                                          13,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        height: 1.25,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildQuarterButton(
    BuildContext context,
    String quarterNumber,
    String label,
    int quarter,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonListScreen(quarterNumber: quarter),
          ),
        );
      },
      child: Container(
        padding: ResponsiveHelper.padding(
          context,
          vertical: 20,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 16),
          ),
        ),
        child: Column(
          children: [
            Text(
              quarterNumber,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 18),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
