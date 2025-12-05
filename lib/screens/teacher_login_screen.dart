import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../services/database_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      appBar: const MathQuestAppBar(showBackButton: true),
      backgroundColor: ThemeHelper.getContainerColor(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.maxContentWidth(context),
              ),
              child: Container(
                margin: ResponsiveHelper.margin(
                  context,
                  horizontal: ResponsiveHelper.contentPadding(context),
                ),
                padding: ResponsiveHelper.cardPadding(context),
                decoration: BoxDecoration(
                  color: ThemeHelper.getCardColor(context),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(context, 20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        'WELCOME',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 32),
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
                    SizedBox(height: ResponsiveHelper.spacing(context, 30)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(
                        color: isDark
                            ? ThemeHelper.getTextColor(context)
                            : Colors.black87,
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                      ),
                      decoration: InputDecoration(
                        hintText: 'example.deped.gov.ph',
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
                          vertical: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 20)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                      'Password:',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: isDark
                            ? ThemeHelper.getTextColor(context)
                            : Colors.black87,
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                      ),
                      decoration: InputDecoration(
                        hintText: 'password',
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
                          vertical: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 30)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: ResponsiveHelper.isSmallMobile(context)
                            ? ResponsiveHelper.width(context, 120)
                            : ResponsiveHelper.width(context, 150),
                        height: ResponsiveHelper.height(context, 50),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
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
                                  width: ResponsiveHelper.iconSize(context, 20),
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
                                      14,
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
    );
  }

  Future<void> _handleLogin() async {
    // Validate fields
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await DatabaseService.loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (user == null) {
        _showErrorDialog('Invalid email or password');
      } else if (user.role != 'teacher') {
        _showErrorDialog(
          'This account is not a teacher. Please use Student Login.',
        );
      } else if (mounted) {
        Navigator.pushReplacementNamed(context, '/teacher-dashboard');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error: $e');
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
}
