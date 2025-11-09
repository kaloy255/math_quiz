import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../services/database_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/theme_helper.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'WELCOME',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 32),
                          fontWeight: FontWeight.bold,
                          color: ThemeHelper.getTextColor(context),
                        ),
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
                        "I'M A STUDENT",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                          fontWeight: FontWeight.w600,
                          color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 30)),
                    Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'example@email.com',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 10),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: ResponsiveHelper.padding(
                          context,
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 20)),
                    Text(
                      'Password:',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(context, 10),
                          ),
                          borderSide: BorderSide.none,
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
                        width: ResponsiveHelper.width(context, 150),
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
      } else if (user.role != 'student') {
        _showErrorDialog(
          'This account is not a student. Please use Teacher Login.',
        );
      } else if (mounted) {
        Navigator.pushReplacementNamed(context, '/student-dashboard');
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
