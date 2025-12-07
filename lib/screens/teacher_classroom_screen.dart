import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/classroom_model.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';

class TeacherClassroomScreen extends StatefulWidget {
  const TeacherClassroomScreen({super.key});

  @override
  State<TeacherClassroomScreen> createState() => _TeacherClassroomScreenState();
}

class _TeacherClassroomScreenState extends State<TeacherClassroomScreen> {
  UserModel? _currentUser;
  List<UserModel> _students = [];
  List<ClassroomModel> _classrooms = [];
  Map<String, int> _classroomStudentCounts = {};
  ClassroomModel? _selectedClassroom;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClassroomData();
  }

  void _loadClassroomData() {
    setState(() {
      _currentUser = DatabaseService.getCurrentUser();

      // Get classrooms created by this teacher
      if (_currentUser != null && _currentUser!.id.isNotEmpty) {
        _classrooms = DatabaseService.getClassroomsByTeacher(_currentUser!.id);
      } else {
        _classrooms = [];
      }

      // Pre-calculate student counts for all classrooms
      _classroomStudentCounts = {};
      for (final classroom in _classrooms) {
        _classroomStudentCounts[classroom.classroomCode] =
            _getStudentsInClassroom(classroom.classroomCode).length;
      }

      // Set default selected classroom to first available
      if (_classrooms.isNotEmpty) {
        _selectedClassroom = _classrooms.first;
        _students = _getStudentsInClassroom(_selectedClassroom!.classroomCode);
      } else {
        _selectedClassroom = null;
        _students = [];
      }
      _isLoading = false;
    });
  }

  List<UserModel> _getStudentsInClassroom(String classroomCode) {
    try {
      final usersBox = DatabaseService.getUsersBox();
      return usersBox.values
          .where((u) => u.role == 'student' && u.classroomCode == classroomCode)
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      appBar: const CustomAppBar(
        showBackButton: true,
        title: 'Classroom Management',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Classroom List Title
              Padding(
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: ResponsiveHelper.contentPadding(context),
                  vertical: ResponsiveHelper.spacing(context, 12),
                ),
                child: CustomCard(
                  withGlow: isDark,
                  child: Padding(
                    padding: ResponsiveHelper.padding(
                      context,
                      horizontal: ResponsiveHelper.spacing(context, 24),
                      vertical: ResponsiveHelper.spacing(context, 12),
                    ),
                    child: Text(
                      'Classroom List',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 18),
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.getTextColor(context),
                      ),
                    ),
                  ),
                ),
              ),

              // Create Button (below header, right aligned)
              Padding(
                padding: ResponsiveHelper.padding(
                  context,
                  horizontal: ResponsiveHelper.contentPadding(context),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: PrimaryButton(
                    text: 'CLASSROOM',
                    icon: Icons.add_circle_outline,
                    onPressed: () => _showCreateClassroomDialog(),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 8)),

              // Filter Dropdown
              if (!_isLoading && _classrooms.isNotEmpty)
                Padding(
                  padding: ResponsiveHelper.padding(
                    context,
                    horizontal: ResponsiveHelper.contentPadding(context),
                  ),
                  child: CustomCard(
                    withGlow: isDark,
                    child: Padding(
                      padding: ResponsiveHelper.padding(
                        context,
                        horizontal: ResponsiveHelper.spacing(context, 16),
                        vertical: ResponsiveHelper.spacing(context, 8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: ThemeHelper.getPrimaryGreen(context),
                            size: ResponsiveHelper.iconSize(context, 20),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.spacing(context, 12),
                          ),
                          Text(
                            'Filter Classroom:',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 14),
                              fontWeight: FontWeight.w600,
                              color: ThemeHelper.getTextColor(context),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.spacing(context, 12),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<ClassroomModel>(
                                value: _selectedClassroom,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: ThemeHelper.getPrimaryGreen(context),
                                ),
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    14,
                                  ),
                                  color: ThemeHelper.getTextColor(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                dropdownColor: isDark
                                    ? ThemeHelper.getCardColor(context)
                                    : Colors.white,
                                items: _classrooms.map((classroom) {
                                  // Get student count from pre-calculated map
                                  final studentCount =
                                      _classroomStudentCounts[classroom
                                          .classroomCode] ??
                                      0;
                                  final displayName =
                                      '${classroom.classroomCode} ($studentCount ${studentCount == 1 ? 'student' : 'students'})';

                                  return DropdownMenuItem<ClassroomModel>(
                                    value: classroom,
                                    child: Text(displayName),
                                  );
                                }).toList(),
                                onChanged: (ClassroomModel? newValue) {
                                  if (!mounted) return;

                                  setState(() {
                                    _selectedClassroom = newValue;
                                    if (_selectedClassroom != null) {
                                      _students = _getStudentsInClassroom(
                                        _selectedClassroom!.classroomCode,
                                      );
                                    } else {
                                      _students = [];
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!_isLoading && _classrooms.isNotEmpty)
                SizedBox(height: ResponsiveHelper.spacing(context, 12)),

              // Main Content Area
              Expanded(
                child: Padding(
                  padding: ResponsiveHelper.padding(
                    context,
                    horizontal: ResponsiveHelper.contentPadding(context),
                  ),
                  child: CustomCard(
                    withGlow: isDark,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ThemeHelper.getPrimaryGreen(context),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: ResponsiveHelper.padding(
                              context,
                              all: ResponsiveHelper.spacing(context, 20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Grade & Section
                                Text(
                                  'Grade & Section:',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    color: ThemeHelper.getTextColor(context),
                                  ),
                                ),
                                SizedBox(
                                  height: ResponsiveHelper.spacing(context, 4),
                                ),
                                Text(
                                  _selectedClassroom?.gradeAndSection ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      14,
                                    ),
                                    color: ThemeHelper.getSecondaryTextColor(
                                      context,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: ResponsiveHelper.spacing(context, 16),
                                ),

                                // Table Header
                                Container(
                                  padding: ResponsiveHelper.padding(
                                    context,
                                    horizontal: ResponsiveHelper.spacing(
                                      context,
                                      16,
                                    ),
                                    vertical: ResponsiveHelper.spacing(
                                      context,
                                      12,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? ThemeHelper.getElevatedColor(context)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(context, 8),
                                    ),
                                    border: Border.all(
                                      color: isDark
                                          ? ThemeHelper.getBorderColor(context)
                                          : Colors.grey[300]!,
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex:
                                            ResponsiveHelper.isSmallMobile(
                                              context,
                                            )
                                            ? 1
                                            : 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'NUMBER OF',
                                              style: TextStyle(
                                                fontSize:
                                                    ResponsiveHelper.fontSize(
                                                      context,
                                                      11,
                                                    ),
                                                fontWeight: FontWeight.bold,
                                                color: ThemeHelper.getTextColor(
                                                  context,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'STUDENTS',
                                              style: TextStyle(
                                                fontSize:
                                                    ResponsiveHelper.fontSize(
                                                      context,
                                                      11,
                                                    ),
                                                fontWeight: FontWeight.bold,
                                                color: ThemeHelper.getTextColor(
                                                  context,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex:
                                            ResponsiveHelper.isSmallMobile(
                                              context,
                                            )
                                            ? 2
                                            : 3,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: ResponsiveHelper.spacing(
                                              context,
                                              ResponsiveHelper.isSmallMobile(
                                                    context,
                                                  )
                                                  ? 8
                                                  : 16,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: isDark
                                                    ? ThemeHelper.getBorderColor(
                                                        context,
                                                      )
                                                    : Colors.grey[400]!,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'NAME',
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
                                                    context,
                                                    14,
                                                  ),
                                              fontWeight: FontWeight.bold,
                                              color: ThemeHelper.getTextColor(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: ResponsiveHelper.spacing(context, 8),
                                ),

                                // Student List
                                if (_students.isEmpty)
                                  Padding(
                                    padding: ResponsiveHelper.padding(
                                      context,
                                      all: ResponsiveHelper.spacing(
                                        context,
                                        32,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'No students in this classroom yet',
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
                                    ),
                                  )
                                else
                                  ...List.generate(
                                    _students.length,
                                    (index) => _buildStudentRow(
                                      studentNumber: index + 1,
                                      student: _students[index],
                                    ),
                                  ),

                                SizedBox(
                                  height: ResponsiveHelper.spacing(context, 20),
                                ),
                              ],
                            ),
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

  Widget _buildStudentRow({
    required int studentNumber,
    required UserModel student,
  }) {
    final isDark = ThemeHelper.isDarkMode(context);
    final isEven = studentNumber % 2 == 0;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(context, 8)),
      padding: ResponsiveHelper.padding(
        context,
        horizontal: ResponsiveHelper.spacing(context, 16),
        vertical: ResponsiveHelper.spacing(context, 12),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? (isEven
                  ? ThemeHelper.getElevatedColor(context)
                  : ThemeHelper.getCardColor(context))
            : Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(context, 8),
        ),
        border: Border.all(
          color: isDark
              ? ThemeHelper.getBorderColor(context)
              : Colors.grey[300]!,
        ),
        boxShadow: isDark && isEven
            ? ThemeHelper.getGlow(
                context,
                color: ThemeHelper.getPrimaryGreen(context),
                blur: 2,
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: ResponsiveHelper.isSmallMobile(context) ? 1 : 2,
            child: Text(
              '$studentNumber',
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 14),
                color: ThemeHelper.getTextColor(context),
              ),
            ),
          ),
          Expanded(
            flex: ResponsiveHelper.isSmallMobile(context) ? 2 : 3,
            child: Container(
              padding: EdgeInsets.only(
                left: ResponsiveHelper.spacing(
                  context,
                  ResponsiveHelper.isSmallMobile(context) ? 8 : 16,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: isDark
                        ? ThemeHelper.getBorderColor(context)
                        : Colors.grey[400]!,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                student.name,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 14),
                  color: ThemeHelper.getTextColor(context),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateClassroomDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CreateClassroomPage(
          onClassroomCreated: () {
            if (mounted) {
              _loadClassroomData();
            }
          },
          currentUser: _currentUser,
        ),
      ),
    );
  }
}

class _CreateClassroomPage extends StatefulWidget {
  final VoidCallback onClassroomCreated;
  final UserModel? currentUser;

  const _CreateClassroomPage({
    required this.onClassroomCreated,
    required this.currentUser,
  });

  @override
  State<_CreateClassroomPage> createState() => _CreateClassroomPageState();
}

class _CreateClassroomPageState extends State<_CreateClassroomPage> {
  final _classroomNameController = TextEditingController();
  final _classroomCodeController = TextEditingController();
  final _gradeAndSectionController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _classroomNameController.dispose();
    _classroomCodeController.dispose();
    _gradeAndSectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      backgroundColor: ThemeHelper.getContainerColor(context),
      appBar: CustomAppBar(showBackButton: true, title: 'Create New Classroom'),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeHelper.getBackgroundGradient(context),
        ),
        child: Padding(
          padding: ResponsiveHelper.padding(
            context,
            all: ResponsiveHelper.contentPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        context,
                        'Classroom Name:',
                        _classroomNameController,
                        'Enter classroom name',
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 24)),
                      _buildTextField(
                        context,
                        'Grade and Section:',
                        _gradeAndSectionController,
                        'e.g., Grade 9 - Section A',
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(context, 24)),
                      _buildTextField(
                        context,
                        'Classroom Code:',
                        _classroomCodeController,
                        'Enter classroom code',
                        isNumeric: true,
                      ),
                      if (_errorMessage != null) ...[
                        SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                        CustomCard(
                          child: Padding(
                            padding: ResponsiveHelper.padding(
                              context,
                              all: ResponsiveHelper.spacing(context, 12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[700],
                                  size: ResponsiveHelper.iconSize(context, 20),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.spacing(context, 8),
                                ),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        14,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(context, 20)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveHelper.height(context, 16),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? ThemeHelper.getBorderColor(context)
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: isDark
                              ? ThemeHelper.getSecondaryTextColor(context)
                              : Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(context, 16)),
                  Expanded(
                    child: PrimaryButton(
                      text: 'CREATE',
                      onPressed: _isLoading ? null : _handleCreateClassroom,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateClassroom() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate fields
    if (_classroomNameController.text.trim().isEmpty ||
        _gradeAndSectionController.text.trim().isEmpty ||
        _classroomCodeController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (widget.currentUser == null) {
      setState(() {
        _errorMessage = 'User not found';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await DatabaseService.createClassroom(
        teacherId: widget.currentUser!.id,
        classroomName: _classroomNameController.text.trim(),
        classroomCode: _classroomCodeController.text.trim(),
        gradeAndSection: _gradeAndSectionController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Only close and show success if classroom was created successfully
          Navigator.pop(context);
          widget.onClassroomCreated();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Classroom created successfully!'),
              backgroundColor: ThemeHelper.getPrimaryGreen(context),
            ),
          );
        } else {
          // If code already exists, show error but stay on form
          setState(() {
            _errorMessage =
                'Classroom code already exists. Please use a different code.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: $e';
        });
      }
    }
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
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
        SizedBox(height: ResponsiveHelper.spacing(context, 6)),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          style: TextStyle(
            color: isDark ? ThemeHelper.getTextColor(context) : Colors.black87,
            fontSize: ResponsiveHelper.fontSize(context, 16),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? ThemeHelper.getSecondaryTextColor(context)
                  : Colors.grey[400],
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
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 10),
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
                ResponsiveHelper.borderRadius(context, 10),
              ),
              borderSide: BorderSide(
                color: ThemeHelper.getPrimaryGreen(context),
                width: 2,
              ),
            ),
            contentPadding: ResponsiveHelper.padding(
              context,
              horizontal: ResponsiveHelper.spacing(context, 16),
              vertical: ResponsiveHelper.spacing(context, 12),
            ),
          ),
        ),
      ],
    );
  }
}
