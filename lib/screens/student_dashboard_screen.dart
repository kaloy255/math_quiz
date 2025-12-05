import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'badge_list_screen.dart';
import 'view_previous_quiz_screen.dart';
import 'student_settings_screen.dart';
import 'classroom_screen.dart';
import 'edit_profile_screen.dart';
import 'student_stats_screen.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/mathie_speech_bubble.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    setState(() {
      _currentUser = DatabaseService.getCurrentUser();
    });
  }

  final List<Map<String, dynamic>> _badgeLevels = [
    {'name': 'Rookie', 'minXp': 50, 'maxXp': 100},
    {'name': 'Learner', 'minXp': 101, 'maxXp': 250},
    {'name': 'Explorer', 'minXp': 251, 'maxXp': 400},
    {'name': 'Challenger', 'minXp': 401, 'maxXp': 550},
    {'name': 'Solver', 'minXp': 551, 'maxXp': 700},
    {'name': 'Master', 'minXp': 701, 'maxXp': 850},
    {'name': 'Legend', 'minXp': 851, 'maxXp': 1000},
    {'name': 'Math Wizard', 'minXp': 1001, 'maxXp': 1300},
  ];

  String _getCurrentBadge(int totalXp) {
    for (var badge in _badgeLevels) {
      if (totalXp >= badge['minXp'] && totalXp <= badge['maxXp']) {
        return badge['name'];
      }
    }
    // If XP is less than 50, return Rookie
    if (totalXp < 50) return 'Rookie';
    // If XP exceeds max, return highest badge
    return _badgeLevels.last['name'];
  }

  String _getBadgeImagePath(String badgeName) {
    final filename = badgeName.replaceAll(' ', '_');
    return 'assets/images/badges/$filename.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      appBar: CustomAppBar(
        showProfileButton: true,
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          ).then((_) {
            _loadCurrentUser();
          });
        },
      ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Section
                          Text(
                            'WELCOME',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 36),
                              fontWeight: FontWeight.bold,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 4),
                          ),
                          Text(
                            _currentUser?.name.toUpperCase() ?? 'STUDENT',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 24),
                              fontWeight: FontWeight.bold,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 24),
                          ),

                          // Stats Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'XP',
                                  _currentUser?.xp.toString() ?? '0',
                                  Icons.emoji_events_outlined,
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.spacing(context, 12),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    // Navigate to badge list
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BadgeListScreen(),
                                      ),
                                    );
                                    // Reload user data when returning
                                    _loadCurrentUser();
                                  },
                                  child: _buildStatCard(
                                    'Badge',
                                    _getCurrentBadge(_currentUser?.xp ?? 0),
                                    Icons.stars,
                                    imagePath: _getBadgeImagePath(
                                      _getCurrentBadge(_currentUser?.xp ?? 0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 24),
                          ),

                          // Algebra Quiz Card
                          CustomCard(
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                '/quiz-selection',
                              );
                              _loadCurrentUser();
                            },
                            withGlow: true,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ALGEBRA QUIZ',
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
                                      ),
                                      SizedBox(
                                        height: ResponsiveHelper.spacing(
                                          context,
                                          8,
                                        ),
                                      ),
                                      Text(
                                        'Timed quizzes with instant Scoring',
                                        style: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(
                                            context,
                                            14,
                                          ),
                                          color:
                                              ThemeHelper.getSecondaryTextColor(
                                                context,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: ResponsiveHelper.padding(
                                    context,
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeHelper.isDarkMode(context)
                                        ? ThemeHelper.getElevatedColor(context)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(
                                        context,
                                        20,
                                      ),
                                    ),
                                    border: Border.all(
                                      color: ThemeHelper.getPrimaryGreen(
                                        context,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'START',
                                        style: TextStyle(
                                          fontSize: ResponsiveHelper.fontSize(
                                            context,
                                            14,
                                          ),
                                          fontWeight: FontWeight.bold,
                                          color: ThemeHelper.getPrimaryGreen(
                                            context,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: ResponsiveHelper.spacing(
                                          context,
                                          4,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: ResponsiveHelper.iconSize(
                                          context,
                                          16,
                                        ),
                                        color: ThemeHelper.getPrimaryGreen(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 24),
                          ),

                          // Action Buttons Grid
                          Row(
                            children: [
                              Expanded(
                                child: ActionButton(
                                  icon: Icons.book_outlined,
                                  label: 'LESSONS',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/lesson-page',
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.spacing(context, 12),
                              ),
                              Expanded(
                                child: ActionButton(
                                  icon: Icons.bar_chart,
                                  label: 'STATS',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentStatsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 12),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ActionButton(
                                  icon: Icons.visibility_outlined,
                                  label: 'VIEW',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewPreviousQuizScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.spacing(context, 12),
                              ),
                              Expanded(
                                child: ActionButton(
                                  icon: Icons.settings_outlined,
                                  label: 'SETTINGS',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentSettingsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 20),
                          ), // Reduced from 80 to 20
                          // Speech Bubble with Mathie Character
                          Padding(
                            padding: ResponsiveHelper.padding(
                              context,
                              horizontal: ResponsiveHelper.contentPadding(
                                context,
                              ),
                            ),
                            child: Builder(
                              builder: (context) {
                                final isDark = ThemeHelper.isDarkMode(context);
                                final bubbleContainerWidth =
                                    ResponsiveHelper.width(
                                      context,
                                      isDark ? 320 : 220,
                                    );

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Chat Bubble with Mathie (Left side)
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: SizedBox(
                                          width: bubbleContainerWidth,
                                          child: MathieSpeechBubble(
                                            text: 'Learning is Fun!!',
                                            rotation: -0.30,
                                            offset: const Offset(45, -10),
                                            tailDirection:
                                                TailDirection.bottomRight,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ResponsiveHelper.spacing(
                                        context,
                                        4,
                                      ),
                                    ),
                                    // Mathie Character (Right side)
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/mathie/dashboard_mathie.png',
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width:
                                                      ResponsiveHelper.iconSize(
                                                        context,
                                                        80,
                                                      ),
                                                  height:
                                                      ResponsiveHelper.iconSize(
                                                        context,
                                                        80,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF6BBF59,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          ResponsiveHelper.borderRadius(
                                                            context,
                                                            40,
                                                          ),
                                                        ),
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
                  boxShadow: ThemeHelper.getElevation(context, 4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.home, 'Home', true, () {}),
                    _buildNavItem(Icons.people, 'Users', false, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClassroomScreen(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon, {
    String? imagePath,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      padding: ResponsiveHelper.cardPadding(context),
      decoration: BoxDecoration(
        color: isDark
            ? ThemeHelper.getCardColor(context)
            : const Color(0xFFD4EDD0),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 12),
        ),
        border: isDark
            ? Border.all(color: ThemeHelper.getBorderColor(context), width: 1)
            : null,
        boxShadow: ThemeHelper.getElevation(context, 2),
      ),
      child: Row(
        children: [
          // Icon on the left
          if (imagePath != null)
            Container(
              width: ResponsiveHelper.iconSize(context, 48),
              height: ResponsiveHelper.iconSize(context, 48),
              decoration: BoxDecoration(
                color: isDark
                    ? ThemeHelper.getElevatedColor(context)
                    : Colors.black87,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 8),
                ),
                boxShadow: isDark
                    ? ThemeHelper.getGlow(
                        context,
                        color: ThemeHelper.getPrimaryGreen(context),
                      )
                    : null,
              ),
              child: Image.asset(
                imagePath,
                width: ResponsiveHelper.iconSize(context, 32),
                height: ResponsiveHelper.iconSize(context, 32),
              ),
            )
          else
            Container(
              width: ResponsiveHelper.iconSize(context, 48),
              height: ResponsiveHelper.iconSize(context, 48),
              decoration: BoxDecoration(
                color: ThemeHelper.getButtonGreen(context),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 8),
                ),
                boxShadow: isDark
                    ? ThemeHelper.getGlow(
                        context,
                        color: ThemeHelper.getPrimaryGreen(context),
                      )
                    : null,
              ),
              child: Icon(
                icon,
                size: ResponsiveHelper.iconSize(context, 24),
                color: Colors.white,
              ),
            ),
          SizedBox(width: ResponsiveHelper.spacing(context, 12)),
          // Text on the right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getSecondaryTextColor(context),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 20),
                    fontWeight: FontWeight.bold,
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: ResponsiveHelper.iconSize(context, 32),
          ),
          SizedBox(height: ResponsiveHelper.spacing(context, 4)),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: ResponsiveHelper.fontSize(context, 12),
            ),
          ),
        ],
      ),
    );
  }
}
