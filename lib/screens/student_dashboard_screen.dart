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
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        ).then((_) {
                          // Reload user data when returning
                          _loadCurrentUser();
                        });
                      },
                      child: Container(
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
                          GestureDetector(
                            onTap: () async {
                              // Navigate to quiz selection
                              await Navigator.pushNamed(
                                context,
                                '/quiz-selection',
                              );
                              // Reload user data when returning
                              _loadCurrentUser();
                            },
                            child: Container(
                              padding: ResponsiveHelper.cardPadding(context),
                              decoration: BoxDecoration(
                                color: ThemeHelper.getCardColor(context),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(context, 16),
                                ),
                              ),
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
                                            color: ThemeHelper.getTextColor(
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
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveHelper.borderRadius(
                                          context,
                                          20,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: Colors.black87,
                                        width: 1,
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
                                            color: ThemeHelper.getTextColor(
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
                                          color: Colors.black87,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(context, 24),
                          ),

                          // Action Buttons Grid
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  Icons.book_outlined,
                                  'LESSONS',
                                  () {
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
                                child: _buildActionButton(
                                  Icons.bar_chart,
                                  'STATS',
                                  () {
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
                                child: _buildActionButton(
                                  Icons.visibility_outlined,
                                  'VIEW',
                                  () {
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
                                child: _buildActionButton(
                                  Icons.settings_outlined,
                                  'SETTINGS',
                                  () {
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Chat Bubble Image with Text (Left side)
                                Expanded(
                                  flex: 2,
                                  child: Transform.translate(
                                    offset: const Offset(
                                      45,
                                      -10,
                                    ), // Reduced from -90 to -50
                                    child: Transform.rotate(
                                      angle:
                                          -0.30, // Slight rotation in radians (~-4.5 degrees)
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/mathie/bubble_chat.png',
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 14,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(4),
                                                      ),
                                                  border: Border.all(
                                                    color:
                                                        ThemeHelper.getBorderColor(
                                                          context,
                                                        ),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Learning is Fun!!',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        ThemeHelper.getTextColor(
                                                          context,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: ResponsiveHelper.spacing(
                                                context,
                                                8,
                                              ),
                                            ),
                                            child: Text(
                                              'Learning is Fun!!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    ResponsiveHelper.fontSize(
                                                      context,
                                                      14,
                                                    ),
                                                fontWeight: FontWeight.w600,
                                                color: ThemeHelper.getTextColor(
                                                  context,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.spacing(context, 4),
                                ),
                                // Mathie Character (Right side)
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/images/mathie/dashboard_mathie.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: ResponsiveHelper.iconSize(
                                            context,
                                            80,
                                          ),
                                          height: ResponsiveHelper.iconSize(
                                            context,
                                            80,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6BBF59),
                                            borderRadius: BorderRadius.circular(
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
    return Container(
      padding: ResponsiveHelper.cardPadding(context),
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDD0),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 12),
        ),
      ),
      child: Row(
        children: [
          // Icon on the left
          if (imagePath != null)
            Container(
              width: ResponsiveHelper.iconSize(context, 48),
              height: ResponsiveHelper.iconSize(context, 48),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 8),
                ),
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
                color: const Color(0xFF6BBF59),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 8),
                ),
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
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: ResponsiveHelper.cardPadding(context),
        decoration: BoxDecoration(
          color: const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.iconSize(context, 32),
              color: Colors.black87,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 14),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
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

  void _showLogoutOption() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _handleLogout();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await DatabaseService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }
}
