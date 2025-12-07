import 'package:flutter/material.dart';
import 'lesson_list_screen.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/mathie_speech_bubble.dart';

class LessonPageScreen extends StatefulWidget {
  const LessonPageScreen({super.key});

  @override
  State<LessonPageScreen> createState() => _LessonPageScreenState();
}

class _LessonPageScreenState extends State<LessonPageScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final headingTextColor = ThemeHelper.getTextColor(context);
    final headingIconColor = isDark
        ? ThemeHelper.getPrimaryGreen(context)
        : Colors.black87;

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
                                  color: isDark
                                      ? ThemeHelper.getElevatedColor(context)
                                      : const Color(0xFFD4EDD0),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(context, 16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book_outlined,
                                      color: headingIconColor,
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
                                        color: headingTextColor,
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
                                      color: ThemeHelper.getButtonGreen(
                                        context,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Theme-aware speech bubble asset (uses bubble_green in dark mode).
                            // Bubble tuning guide:
                            // - Adjust `rotation` and `offset` below for overall position.
                            // - Use `BubbleTuningOverrides` to tweak width/height/padding/font.
                            MathieSpeechBubble(
                              text: 'Here are the\nresources you\nmight need.',
                              rotation: -0.08,
                              offset: Offset(
                                ResponsiveHelper.spacing(context, -90),
                                ResponsiveHelper.spacing(context, -65),
                              ),
                              tailDirection: TailDirection.bottomLeft,
                              mirrorDarkBubble: false,
                              mirrorLightBubble: true,
                              darkOverrides: const BubbleTuningOverrides(
                                width: 240,
                                height: 150,
                                paddingX: 18,
                                paddingY: 18,
                                fontSize: 14,
                                textRotationAdjust: -0.10,
                                textOffsetX: -10,
                                textOffsetY: -22,
                              ),
                              lightOverrides: const BubbleTuningOverrides(
                                textRotationAdjust: -0.10,
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
    final isDark = ThemeHelper.isDarkMode(context);
    final buttonTextColor = ThemeHelper.getTextColor(context);

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
          color: isDark
              ? ThemeHelper.getElevatedColor(context)
              : const Color(0xFFD4EDD0),
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
                color: buttonTextColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 18),
                fontWeight: FontWeight.w600,
                color: buttonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
