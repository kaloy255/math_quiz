import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../widgets/app_bar_widget.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class TeacherSignupScreen extends StatefulWidget {
  const TeacherSignupScreen({super.key});

  @override
  State<TeacherSignupScreen> createState() => _TeacherSignupScreenState();
}

class _TeacherSignupScreenState extends State<TeacherSignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _uuid = const Uuid();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MathQuestAppBar(showBackButton: true),
      backgroundColor: ThemeHelper.getContainerColor(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
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
                child: Container(
                  padding: ResponsiveHelper.cardPadding(context),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getCardColor(context),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(context, 20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          'WELCOME',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 28),
                            fontWeight: FontWeight.bold,
                            color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 10)),
                      Container(
                        padding: ResponsiveHelper.padding(
                          context,
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6BBF59),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 20),
                          ),
                        ),
                        child: Text(
                          "I'M A TEACHER",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                            fontWeight: FontWeight.w600,
                            color: ThemeHelper.getTextColor(context),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 24)),
                      _buildTextField(
                        'Full Name:',
                        _nameController,
                        'Full Name',
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      _buildTextField(
                        'Email:',
                        _emailController,
                        'example.deped.gov.ph',
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                      _buildTextField(
                        'Password:',
                        _passwordController,
                        'password',
                        isPassword: true,
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 24)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: ResponsiveHelper.isSmallMobile(context)
                              ? ResponsiveHelper.width(context, 120)
                              : ResponsiveHelper.width(context, 140),
                          height: ResponsiveHelper.height(context, 50),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6BBF59),
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.borderRadius(context, 25),
                                ),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: ResponsiveHelper.iconSize(
                                      context,
                                      20,
                                    ),
                                    height: ResponsiveHelper.iconSize(
                                      context,
                                      20,
                                    ),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.black87,
                                          ),
                                    ),
                                  )
                                : Text(
                                    'CONTINUE',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        13,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
    String hint, {
    bool isPassword = false,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 14),
            fontWeight: FontWeight.w600,
              color: ThemeHelper.getTextColor(context),
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(context, 6)),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(
            color: isDark ? ThemeHelper.getTextColor(context) : Colors.black87,
            fontSize: ResponsiveHelper.fontSize(context, 16),
          ),
          decoration: InputDecoration(
            hintText: hint,
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
                ResponsiveHelper.borderRadius(context, 10),
              ),
              borderSide: BorderSide(
                color: isDark
                    ? ThemeHelper.getBorderColor(context)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 10),
              ),
              borderSide: BorderSide(
                color: isDark
                    ? ThemeHelper.getBorderColor(context)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 10),
              ),
              borderSide: BorderSide(
                color: ThemeHelper.getPrimaryGreen(context),
                width: 2,
              ),
            ),
            contentPadding: ResponsiveHelper.padding(
              context,
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignup() async {
    // Validate all fields
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    // Basic email validation
    if (!_emailController.text.contains('@')) {
      _showErrorDialog('Please enter a valid email address');
      return;
    }

    // Password length validation
    if (_passwordController.text.length < 6) {
      _showErrorDialog('Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create teacher user
      final teacher = UserModel.teacher(
        id: _uuid.v4(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Register the user
      final success = await DatabaseService.registerUser(teacher);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Show success message and navigate to login page
        if (mounted) {
          _showSuccessDialog('Account created successfully!', () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/teacher-login',
              (route) => false,
            );
          });
        }
      } else {
        _showErrorDialog('Email already exists. Please use a different email.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error creating account: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [TextButton(onPressed: onPressed, child: const Text('OK'))],
      ),
    );
  }
}
