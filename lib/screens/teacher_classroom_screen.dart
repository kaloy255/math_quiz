import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/classroom_model.dart';

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100]!, Colors.grey[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
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
                  children: [
                    // Back Button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Logo and Title
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'M',
                                style: TextStyle(
                                  color: Color(0xFF6BBF59),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'MathQuest',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile Icon (decorative)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Classroom List Title
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4EDD0),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black87, width: 1),
                  ),
                  child: const Text(
                    'Classroom List',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Create Button (below header, right aligned)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 3,
                    shadowColor: const Color(0xFF6BBF59).withOpacity(0.3),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF6BBF59), Color(0xFF5AA849)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6BBF59).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _showCreateClassroomDialog(),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 22,
                        ),
                        label: const Text(
                          'CLASSROOM',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Filter Dropdown
              if (!_isLoading && _classrooms.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6BBF59),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6BBF59).withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_list,
                          color: Color(0xFF6BBF59),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Filter Classroom:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ClassroomModel>(
                              value: _selectedClassroom,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF6BBF59),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
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
              if (!_isLoading && _classrooms.isNotEmpty)
                const SizedBox(height: 12),

              // Main Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5DC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Grade & Section
                              const Text(
                                'Grade & Section:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                _selectedClassroom?.gradeAndSection ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'NUMBER OF',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'STUDENTS',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.grey[400]!,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'NAME',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Student List
                              if (_students.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Text(
                                      'No students in this classroom yet',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
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

                              const SizedBox(height: 20),
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

  Widget _buildStudentRow({
    required int studentNumber,
    required UserModel student,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$studentNumber',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey[400]!, width: 1),
                ),
              ),
              child: Text(
                student.name,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Classroom',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      'Classroom Name:',
                      _classroomNameController,
                      'Enter classroom name',
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      'Grade and Section:',
                      _gradeAndSectionController,
                      'e.g., Grade 7 - Section A',
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      'Classroom Code:',
                      _classroomCodeController,
                      'Enter classroom code',
                      isNumeric: true,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[300]!, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCreateClassroom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6BBF59),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black87,
                              ),
                            ),
                          )
                        : const Text(
                            'CREATE CLASSROOM',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
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
            const SnackBar(
              content: Text('Classroom created successfully!'),
              backgroundColor: Color(0xFF6BBF59),
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
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF6BBF59), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
