import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'teacher_settings_screen.dart';
import 'edit_profile_screen.dart';
import 'top_students_screen.dart';
import 'teacher_classroom_screen.dart';
import 'student_performance_screen.dart';
import 'check_scores_screen.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
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
                        SizedBox(height: ResponsiveHelper.spacing(context, 4)),
                        Text(
                          _currentUser?.name.toUpperCase() ?? 'TEACHER',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 24),
                            fontWeight: FontWeight.bold,
                            color: ThemeHelper.getTextColor(context),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 32)),

                        // TOP STUDENTS Card
                        _buildCard(
                          icon: Icons.emoji_events,
                          title: 'TOP STUDENTS',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TopStudentsScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                        // STUDENT'S PERFORMANCE Card
                        _buildPerformanceCard(
                          icon: Icons.assignment,
                          title: "STUDENT'S PERFORMANCE",
                          onSeeTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const StudentPerformanceScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 24)),

                        // Bottom Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.search,
                                title: 'CHECK\nSCORES',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CheckScoresScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.spacing(context, 16),
                            ),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.settings,
                                title: 'SETTINGS',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TeacherSettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 40)),
                      ],
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
                    GestureDetector(
                      onTap: () {
                        // Stay on home
                      },
                      child: _buildNavItem(Icons.home, 'Home'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TeacherClassroomScreen(),
                          ),
                        );
                      },
                      child: _buildNavItem(Icons.people, 'Users'),
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

  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);

    return CustomCard(
      onTap: onTap,
      withGlow: true,
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.iconSize(context, 48),
              height: ResponsiveHelper.iconSize(context, 48),
              decoration: BoxDecoration(
              color: isDark
                  ? ThemeHelper.getElevatedColor(context)
                  : Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 12),
                ),
              boxShadow: isDark
                  ? ThemeHelper.getGlow(
                      context,
                      color: ThemeHelper.getPrimaryGreen(context),
                      blur: 6,
                    )
                  : null,
              ),
              child: Icon(
                icon,
                size: ResponsiveHelper.iconSize(context, 28),
              color: isDark
                  ? ThemeHelper.getPrimaryGreen(context)
                  : Colors.black87,
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(context, 16)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 16),
                  fontWeight: FontWeight.bold,
                color: ThemeHelper.getTextColor(context),
                ),
              ),
            ),
          ],
      ),
    );
  }

  Widget _buildPerformanceCard({
    required IconData icon,
    required String title,
    required VoidCallback onSeeTap,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);

    return CustomCard(
      withGlow: true,
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.iconSize(context, 48),
            height: ResponsiveHelper.iconSize(context, 48),
            decoration: BoxDecoration(
              color: isDark
                  ? ThemeHelper.getElevatedColor(context)
                  : Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              boxShadow: isDark
                  ? ThemeHelper.getGlow(
                      context,
                      color: ThemeHelper.getPrimaryGreen(context),
                      blur: 6,
                    )
                  : null,
            ),
            child: Icon(
              icon,
              size: ResponsiveHelper.iconSize(context, 28),
              color: isDark
                  ? ThemeHelper.getPrimaryGreen(context)
                  : Colors.black87,
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(context, 16)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 16),
                fontWeight: FontWeight.bold,
                color: ThemeHelper.getTextColor(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onSeeTap,
            child: Container(
              padding: ResponsiveHelper.padding(
                context,
                horizontal: ResponsiveHelper.isSmallMobile(context) ? 8 : 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? ThemeHelper.getElevatedColor(context)
                    : Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(context, 8),
                ),
                border: isDark
                    ? Border.all(
                        color: ThemeHelper.getPrimaryGreen(context),
                        width: 2,
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? ThemeHelper.getPrimaryGreen(context)
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(context, 4)),
                  Icon(
                    Icons.arrow_forward,
                    size: ResponsiveHelper.iconSize(context, 16),
                    color: isDark
                        ? ThemeHelper.getPrimaryGreen(context)
                        : Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ResponsiveHelper.isSmallMobile(context)
            ? ResponsiveHelper.height(context, 100)
            : ResponsiveHelper.height(context, 120),
        padding: ResponsiveHelper.cardPadding(context),
        decoration: BoxDecoration(
          color: isDark
              ? ThemeHelper.getCardColor(context)
              : const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 16),
          ),
          border: isDark
              ? Border.all(color: ThemeHelper.getBorderColor(context), width: 1)
              : null,
          boxShadow: ThemeHelper.getElevation(context, 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.iconSize(context, 40),
              color: isDark
                  ? ThemeHelper.getPrimaryGreen(context)
                  : Colors.black87,
            ),
            SizedBox(height: ResponsiveHelper.spacing(context, 8)),
            Flexible(
              child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 14),
                fontWeight: FontWeight.bold,
                  color: ThemeHelper.getTextColor(context),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: ResponsiveHelper.iconSize(context, 32),
        ),
        SizedBox(height: ResponsiveHelper.spacing(context, 4)),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.fontSize(context, 12),
          ),
        ),
      ],
    );
  }
}
