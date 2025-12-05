import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _lrnController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    setState(() {
      _currentUser = DatabaseService.getCurrentUser();
      if (_currentUser != null) {
        _nameController.text = _currentUser!.name;
        _emailController.text = _currentUser!.email;
        _lrnController.text = _currentUser!.lrn?.toString() ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _lrnController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                  // Profile Avatar Section
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: ResponsiveHelper.width(context, 100),
                          height: ResponsiveHelper.height(context, 100),
                          decoration: BoxDecoration(
                            color: isDark
                                ? ThemeHelper.getElevatedColor(context)
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? ThemeHelper.getBorderColor(context)
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: ResponsiveHelper.iconSize(context, 60),
                            color: isDark
                                ? ThemeHelper.getSecondaryTextColor(context)
                                : Colors.grey[600],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: ResponsiveHelper.iconSize(context, 36),
                            height: ResponsiveHelper.iconSize(context, 36),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getButtonGreen(context),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ThemeHelper.getCardColor(context),
                                width: 3,
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
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: ResponsiveHelper.iconSize(context, 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                  Center(
                    child: Text(
                      _currentUser?.name ?? 'Name',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 20),
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 32)),

                  // Name Field
                  _buildTextField(
                    'Name',
                    _nameController,
                    Icons.person_outline,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                  // Email Field
                  _buildTextField(
                    'Email',
                    _emailController,
                    Icons.email_outlined,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                  // LRN Field (only for students)
                  if (_currentUser?.role == 'student') ...[
                    _buildTextField(
                      'LRN',
                      _lrnController,
                      Icons.numbers,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                  ],

                  // Change Password Section
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                  // Current Password Field
                  _buildPasswordField(
                    'Current Password',
                    _currentPasswordController,
                    _showCurrentPassword,
                    () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                  // New Password Field
                  _buildPasswordField(
                    'New Password',
                    _newPasswordController,
                    _showNewPassword,
                    () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 16)),

                  // Confirm New Password Field
                  _buildPasswordField(
                    'Confirm New Password',
                    _confirmPasswordController,
                    _showConfirmPassword,
                    () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(context, 32)),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: ResponsiveHelper.height(context, 50),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeHelper.getButtonGreen(context),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 12),
                          ),
                        ),
                        elevation: 2,
                        shadowColor: isDark
                            ? ThemeHelper.getPrimaryGreen(
                                context,
                              ).withOpacity(0.3)
                            : null,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: ResponsiveHelper.iconSize(context, 20),
                              height: ResponsiveHelper.iconSize(context, 20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'SAVE CHANGES',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  16,
                                ),
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextColor(context),
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(context, 8)),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? ThemeHelper.getTextColor(context) : Colors.black87,
            fontSize: ResponsiveHelper.fontSize(context, 16),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: isDark
                  ? ThemeHelper.getSecondaryTextColor(context)
                  : Colors.grey[600],
            ),
            hintStyle: TextStyle(
              color: isDark
                  ? ThemeHelper.getSecondaryTextColor(context)
                  : Colors.grey[500],
              fontSize: ResponsiveHelper.fontSize(context, 14),
            ),
            filled: true,
            fillColor: isDark
                ? ThemeHelper.getElevatedColor(context)
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              borderSide: BorderSide(
                color: isDark
                    ? ThemeHelper.getBorderColor(context)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              borderSide: BorderSide(
                color: isDark
                    ? ThemeHelper.getBorderColor(context)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              borderSide: BorderSide(
                color: ThemeHelper.getPrimaryGreen(context),
                width: 2,
              ),
            ),
            contentPadding: ResponsiveHelper.padding(
              context,
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool showPassword,
    VoidCallback onToggle,
  ) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextColor(context),
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(context, 8)),
        TextField(
          controller: controller,
          obscureText: !showPassword,
          style: TextStyle(
            color: isDark ? ThemeHelper.getTextColor(context) : Colors.black87,
            fontSize: ResponsiveHelper.fontSize(context, 16),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: isDark
                  ? ThemeHelper.getSecondaryTextColor(context)
                  : Colors.grey[600],
            ),
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: isDark
                    ? ThemeHelper.getSecondaryTextColor(context)
                    : Colors.grey[600],
              ),
              onPressed: onToggle,
            ),
            hintStyle: TextStyle(
              color: isDark
                  ? ThemeHelper.getSecondaryTextColor(context)
                  : Colors.grey[500],
              fontSize: ResponsiveHelper.fontSize(context, 14),
            ),
            filled: true,
            fillColor: isDark
                ? ThemeHelper.getElevatedColor(context)
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              borderSide: BorderSide(
                color: isDark
                    ? ThemeHelper.getBorderColor(context)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              borderSide: BorderSide(
                color: isDark
                    ? ThemeHelper.getBorderColor(context)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              borderSide: BorderSide(
                color: ThemeHelper.getPrimaryGreen(context),
                width: 2,
              ),
            ),
            contentPadding: ResponsiveHelper.padding(
              context,
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    // Validate name and email
    if (_nameController.text.trim().isEmpty) {
      _showErrorDialog('Please enter your name');
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      _showErrorDialog('Please enter a valid email address');
      return;
    }

    // Validate LRN field (must be numeric if not empty)
    if (_lrnController.text.trim().isNotEmpty) {
      final lrnValue = int.tryParse(_lrnController.text.trim());
      if (lrnValue == null) {
        _showErrorDialog('LRN must be a valid number');
        return;
      }
    }

    // Check if password fields are filled
    bool changingPassword =
        _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;

    // If changing password, validate all password fields
    if (changingPassword) {
      if (_currentPasswordController.text.isEmpty) {
        _showErrorDialog('Please enter your current password');
        return;
      }

      if (_newPasswordController.text.length < 6) {
        _showErrorDialog('New password must be at least 6 characters');
        return;
      }

      if (_newPasswordController.text != _confirmPasswordController.text) {
        _showErrorDialog('New passwords do not match');
        return;
      }

      // Verify current password
      if (_currentPasswordController.text != _currentUser?.password) {
        _showErrorDialog('Current password is incorrect');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update user data
      final updatedUser = UserModel(
        id: _currentUser!.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: changingPassword
            ? _newPasswordController.text.trim()
            : _currentUser!.password,
        role: _currentUser!.role,
        classroomCode: _currentUser!.classroomCode,
        classroomName: _currentUser!.classroomName,
        xp: _currentUser!.xp,
        badge: _currentUser!.badge,
        createdAt: _currentUser!.createdAt,
        lrn: _lrnController.text.trim().isNotEmpty
            ? int.tryParse(_lrnController.text.trim())
            : null,
      );

      // Update in database
      final success = await DatabaseService.updateUser(updatedUser);

      if (success) {
        // Update current session
        await DatabaseService.loginUser(
          updatedUser.email,
          changingPassword
              ? _newPasswordController.text.trim()
              : _currentUser!.password,
        );

        // Update local state to reflect changes immediately
        setState(() {
          _isLoading = false;
          _currentUser = updatedUser;
        });

        if (mounted) {
          // Show success message and pop immediately to trigger parent reload
          _showSuccessDialog('Profile updated successfully!', () {
            Navigator.pop(context, true); // Return true to indicate update
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(
          'Failed to update profile. Email may already be in use.',
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error updating profile: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeHelper.getCardColor(context),
        title: Text(
          'Error',
          style: TextStyle(color: ThemeHelper.getTextColor(context)),
        ),
        content: Text(
          message,
          style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: ThemeHelper.getPrimaryGreen(context)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeHelper.getCardColor(context),
        title: Text(
          'Success',
          style: TextStyle(color: ThemeHelper.getTextColor(context)),
        ),
        content: Text(
          message,
          style: TextStyle(color: ThemeHelper.getSecondaryTextColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text(
              'OK',
              style: TextStyle(color: ThemeHelper.getPrimaryGreen(context)),
            ),
          ),
        ],
      ),
    );
  }
}
