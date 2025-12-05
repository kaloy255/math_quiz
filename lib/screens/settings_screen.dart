import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../providers/theme_provider.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userRole; // 'student' or 'teacher'

  const SettingsScreen({super.key, required this.userRole});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = false;
  bool _vibration = false;
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

  String getRoleLabel() {
    return widget.userRole.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

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
              // Settings Button Header
              Padding(
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: ResponsiveHelper.contentPadding(context),
                  vertical: ResponsiveHelper.spacing(context, 12),
                ),
                child: CustomCard(
                  withGlow: isDark,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: ResponsiveHelper.iconSize(context, 32),
                        height: ResponsiveHelper.iconSize(context, 32),
                        decoration: BoxDecoration(
                          color: isDark
                              ? ThemeHelper.getElevatedColor(context)
                              : ThemeHelper.getButtonGreen(context),
                          shape: BoxShape.circle,
                          boxShadow: isDark
                              ? ThemeHelper.getGlow(
                                  context,
                                  color: ThemeHelper.getPrimaryGreen(context),
                                  blur: 6,
                                )
                              : null,
                        ),
                        child: Icon(
                          Icons.settings,
                          color: isDark
                              ? ThemeHelper.getPrimaryGreen(context)
                              : Colors.white,
                          size: ResponsiveHelper.iconSize(context, 20),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(context, 12)),
                      Text(
                        'SETTINGS',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: ResponsiveHelper.padding(
                    context,
                    horizontal: ResponsiveHelper.contentPadding(context),
                    vertical: ResponsiveHelper.spacing(context, 8),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveHelper.maxContentWidth(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Section Card
                        CustomCard(
                          withGlow: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: ResponsiveHelper.iconSize(
                                      context,
                                      60,
                                    ),
                                    height: ResponsiveHelper.iconSize(
                                      context,
                                      60,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? ThemeHelper.getElevatedColor(
                                              context,
                                            )
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? ThemeHelper.getBorderColor(
                                                context,
                                              )
                                            : Colors.grey[400]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: ResponsiveHelper.iconSize(
                                        context,
                                        40,
                                      ),
                                      color: isDark
                                          ? ThemeHelper.getSecondaryTextColor(
                                              context,
                                            )
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(
                                    width: ResponsiveHelper.spacing(
                                      context,
                                      16,
                                    ),
                                  ),
                                  // Name and Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _currentUser?.name.toUpperCase() ??
                                              'NAME HERE',
                                          style: TextStyle(
                                            fontSize: ResponsiveHelper.fontSize(
                                              context,
                                              18,
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
                                            4,
                                          ),
                                        ),
                                        Text(
                                          getRoleLabel(),
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
                                  // Edit Icon Button
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditProfileScreen(),
                                        ),
                                      ).then((_) {
                                        _loadCurrentUser();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        ResponsiveHelper.spacing(context, 8),
                                      ),
                                      decoration: BoxDecoration(
                                        color: ThemeHelper.getButtonGreen(
                                          context,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.borderRadius(
                                            context,
                                            8,
                                          ),
                                        ),
                                        boxShadow: isDark
                                            ? ThemeHelper.getGlow(
                                                context,
                                                color:
                                                    ThemeHelper.getPrimaryGreen(
                                                      context,
                                                    ),
                                                blur: 4,
                                              )
                                            : null,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: ResponsiveHelper.iconSize(
                                          context,
                                          20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                        // Dark Mode
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, _) {
                            return _buildSettingItem(
                              icon: Icons.dark_mode,
                              label: 'Dark Mode',
                              child: Switch(
                                value: themeProvider.isDarkMode,
                                onChanged: (value) {
                                  themeProvider.setDarkMode(value);
                                },
                                activeColor: ThemeHelper.getButtonGreen(
                                  context,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 12)),

                        // Change Theme Color
                        _buildSettingItem(
                          icon: Icons.palette,
                          label: 'Change Theme Color',
                          child: Container(
                            padding: ResponsiveHelper.padding(
                              context,
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getButtonGreen(context),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 8),
                              ),
                              boxShadow: isDark
                                  ? ThemeHelper.getGlow(
                                      context,
                                      color: ThemeHelper.getPrimaryGreen(
                                        context,
                                      ),
                                      blur: 4,
                                    )
                                  : null,
                            ),
                            child: Text(
                              'Open Palette',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  12,
                                ),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 12)),

                        // Notification
                        _buildSettingItem(
                          icon: Icons.notifications,
                          label: 'Notification',
                          child: Switch(
                            value: _notification,
                            onChanged: (value) {
                              setState(() {
                                _notification = value;
                              });
                            },
                            activeColor: ThemeHelper.getButtonGreen(context),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 12)),

                        // Vibration
                        _buildSettingItem(
                          icon: Icons.vibration,
                          label: 'Vibration',
                          child: Switch(
                            value: _vibration,
                            onChanged: (value) {
                              setState(() {
                                _vibration = value;
                              });
                            },
                            activeColor: ThemeHelper.getButtonGreen(context),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 12)),

                        // System Update
                        _buildSettingItem(
                          icon: Icons.system_update,
                          label: 'System Update',
                          child: Container(
                            padding: ResponsiveHelper.padding(
                              context,
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getButtonGreen(context),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(context, 8),
                              ),
                              boxShadow: isDark
                                  ? ThemeHelper.getGlow(
                                      context,
                                      color: ThemeHelper.getPrimaryGreen(
                                        context,
                                      ),
                                      blur: 4,
                                    )
                                  : null,
                            ),
                            child: Text(
                              'Updated',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  12,
                                ),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 24)),

                        // Log Out Button
                        CustomCard(
                          onTap: () => _handleLogout(),
                          backgroundColor: isDark
                              ? ThemeHelper.getErrorColor(
                                  context,
                                ).withOpacity(0.2)
                              : Colors.red[50],
                          child: Center(
                            child: Text(
                              'LOG OUT',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  16,
                                ),
                                fontWeight: FontWeight.bold,
                                color: ThemeHelper.getErrorColor(context),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);

    return CustomCard(
      withGlow: isDark,
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.iconSize(context, 40),
            height: ResponsiveHelper.iconSize(context, 40),
            decoration: BoxDecoration(
              color: isDark
                  ? ThemeHelper.getElevatedColor(context)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 10),
              ),
            ),
            child: Icon(
              icon,
              color: isDark
                  ? ThemeHelper.getPrimaryGreen(context)
                  : ThemeHelper.getButtonGreen(context),
              size: ResponsiveHelper.iconSize(context, 24),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(context, 16)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 14),
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextColor(context),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeHelper.getCardColor(context),
        title: Text(
          'Logout',
          style: TextStyle(color: ThemeHelper.getTextColor(context)),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: ThemeHelper.getSecondaryTextColor(context),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(
                color: ThemeHelper.getErrorColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await DatabaseService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/welcome',
          (route) => false,
        );
      }
    }
  }
}
