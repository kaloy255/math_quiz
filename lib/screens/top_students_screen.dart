import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/classroom_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../utils/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_card.dart';

class TopStudentsScreen extends StatefulWidget {
  const TopStudentsScreen({super.key});

  @override
  State<TopStudentsScreen> createState() => _TopStudentsScreenState();
}

class _TopStudentsScreenState extends State<TopStudentsScreen> {
  UserModel? _currentUser;
  List<UserModel> _students = [];
  bool _loading = true;
  ValueListenable? _usersListenable;
  ValueListenable? _classroomsListenable;
  List<ClassroomModel> _classrooms = [];
  String? _selectedClassroomCode;

  @override
  void initState() {
    super.initState();
    _loadData();
    _usersListenable = DatabaseService.getUsersBox().listenable();
    _usersListenable!.addListener(_loadData);
    _classroomsListenable = DatabaseService.getClassroomsBox().listenable();
    _classroomsListenable!.addListener(_loadData);
  }

  @override
  void dispose() {
    _usersListenable?.removeListener(_loadData);
    _classroomsListenable?.removeListener(_loadData);
    super.dispose();
  }

  void _loadData() {
    final user = DatabaseService.getCurrentUser();
    _currentUser = user;

    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final teacherClassrooms = user.role == 'teacher'
        ? DatabaseService.getClassroomsByTeacher(user.id)
        : <ClassroomModel>[];
    final classroomCodes =
        teacherClassrooms.map((c) => c.classroomCode).toSet();

    String? activeClassroom = _selectedClassroomCode;
    if (classroomCodes.isNotEmpty) {
      if (activeClassroom == null || !classroomCodes.contains(activeClassroom)) {
        activeClassroom = teacherClassrooms.first.classroomCode;
      }
    } else if (activeClassroom == null &&
        user.classroomCode != null &&
        user.classroomCode!.isNotEmpty) {
      activeClassroom = user.classroomCode;
    }

    final usersBox = DatabaseService.getUsersBox();
    final allUsers = usersBox.values.toList();
    final students = allUsers.where((u) {
      if (u.role != 'student') return false;
      if (activeClassroom != null && activeClassroom.isNotEmpty) {
        return u.classroomCode == activeClassroom;
      }

      if (classroomCodes.isNotEmpty) {
        return classroomCodes.contains(u.classroomCode);
      }

      return user.classroomCode != null &&
          u.classroomCode == user.classroomCode;
    }).toList();
    students.sort((a, b) => b.xp.compareTo(a.xp));

    setState(() {
      _students = students;
      _classrooms = teacherClassrooms;
      _selectedClassroomCode = activeClassroom;
      _loading = false;
    });
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title Card
                        CustomCard(
                          withGlow: isDark,
                          child: Center(
                            child: Text(
                              'TOP STUDENTS',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  22,
                                ),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                color: ThemeHelper.getTextColor(context),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(context, 16)),
                        if (_classrooms.isNotEmpty)
                          _buildClassroomFilter(context),
                        if (_classrooms.isNotEmpty)
                          SizedBox(height: ResponsiveHelper.spacing(context, 12)),

                        _loading
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: ResponsiveHelper.spacing(context, 40),
                                  ),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ThemeHelper.getPrimaryGreen(context),
                                    ),
                                  ),
                                ),
                              )
                            : _buildRankTable(),
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

  Widget _buildRankTable() {
    final isDark = ThemeHelper.isDarkMode(context);
    final classroomLabel = _activeClassroomLabel;

    return CustomCard(
      withGlow: isDark,
      child: Column(
        children: [
          // Header (Grade & Section)
          Container(
            width: double.infinity,
            padding: ResponsiveHelper.padding(
              context,
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? ThemeHelper.getElevatedColor(context)
                  : const Color(0xFFEAF6E7),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(context, 12),
              ),
              border: isDark
                  ? Border.all(
                      color: ThemeHelper.getBorderColor(context),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.class_,
                  size: ResponsiveHelper.iconSize(context, 18),
                  color: isDark
                      ? ThemeHelper.getPrimaryGreen(context)
                      : const Color(0xFF3C6E37),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 8)),
                Expanded(
                  child: Text(
                    'Grade & Section: $classroomLabel',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                      fontWeight: FontWeight.w700,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Column labels
          Container(
            padding: ResponsiveHelper.padding(
              context,
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? ThemeHelper.getDividerColor(context)
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: ResponsiveHelper.isSmallMobile(context)
                      ? ResponsiveHelper.width(context, 40)
                      : ResponsiveHelper.width(context, 60),
                  child: Text(
                    'RANK',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'NAME',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                ),
                SizedBox(
                  width: ResponsiveHelper.isSmallMobile(context)
                      ? ResponsiveHelper.width(context, 50)
                      : ResponsiveHelper.width(context, 72),
                  child: Text(
                    'XP',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTextColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Render rows
          for (int i = 0; i < _students.length; i++)
            _buildRankRow(i + 1, _students[i], i.isEven),
        ],
      ),
    );
  }

  Widget _buildRankRow(int rank, UserModel student, bool isEvenRow) {
    final isDark = ThemeHelper.isDarkMode(context);
    final Color bg = isEvenRow
        ? (isDark
              ? ThemeHelper.getElevatedColor(context).withOpacity(0.3)
              : const Color(0xFFF8FBF7))
        : (isDark ? ThemeHelper.getCardColor(context) : Colors.white);
    final Widget medal = _rankMedal(rank);

    return Container(
      padding: ResponsiveHelper.padding(context, horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(
            color: isDark
                ? ThemeHelper.getDividerColor(context)
                : const Color(0x11000000),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.isSmallMobile(context)
                ? ResponsiveHelper.width(context, 40)
                : ResponsiveHelper.width(context, 60),
            child: Row(
              children: [
                Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(context, 6)),
                medal,
              ],
            ),
          ),
          Expanded(
            child: Text(
              student.name,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 13),
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextColor(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _xpPill(student.xp),
        ],
      ),
    );
  }

  Widget _rankMedal(int rank) {
    if (rank == 1) {
      return Icon(
        Icons.emoji_events,
        size: ResponsiveHelper.iconSize(context, 16),
        color: const Color(0xFFFFC107), // Gold
      );
    }
    if (rank == 2) {
      return Icon(
        Icons.emoji_events,
        size: ResponsiveHelper.iconSize(context, 16),
        color: const Color(0xFFB0BEC5), // Silver
      );
    }
    if (rank == 3) {
      return Icon(
        Icons.emoji_events,
        size: ResponsiveHelper.iconSize(context, 16),
        color: const Color(0xFFCD7F32), // Bronze
      );
    }
    return SizedBox(width: ResponsiveHelper.width(context, 16));
  }

  Widget _xpPill(int xp) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      width: ResponsiveHelper.isSmallMobile(context)
          ? ResponsiveHelper.width(context, 50)
          : ResponsiveHelper.width(context, 72),
      alignment: Alignment.centerRight,
      child: Container(
        padding: ResponsiveHelper.padding(context, horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark
              ? ThemeHelper.getButtonGreen(context).withOpacity(0.2)
              : const Color(0xFFEEF7EC),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(context, 20),
          ),
          border: isDark
              ? Border.all(
                  color: ThemeHelper.getButtonGreen(context).withOpacity(0.5),
                  width: 1,
                )
              : null,
          boxShadow: isDark
              ? ThemeHelper.getGlow(
                  context,
                  color: ThemeHelper.getButtonGreen(context),
                  blur: 4,
                )
              : null,
        ),
        child: Text(
          '$xp XP',
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 11),
            fontWeight: FontWeight.w700,
            color: isDark
                ? ThemeHelper.getButtonGreen(context)
                : const Color(0xFF3C6E37),
          ),
        ),
      ),
    );
  }

  Widget _buildClassroomFilter(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.getTextColor(context);

    return CustomCard(
      withGlow: isDark,
      child: Padding(
        padding: ResponsiveHelper.padding(
          context,
          horizontal: ResponsiveHelper.spacing(context, 16),
          vertical: ResponsiveHelper.spacing(context, 12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: ThemeHelper.getPrimaryGreen(context),
              size: ResponsiveHelper.iconSize(context, 20),
            ),
            SizedBox(width: ResponsiveHelper.spacing(context, 12)),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedClassroomCode,
                  isExpanded: true,
                  dropdownColor: ThemeHelper.getCardColor(context),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: ThemeHelper.getPrimaryGreen(context),
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                  hint: Text(
                    'Filter classroom',
                    style: TextStyle(
                      color: ThemeHelper.getSecondaryTextColor(context),
                      fontSize: ResponsiveHelper.fontSize(context, 14),
                    ),
                  ),
                  items: _classrooms.map((classroom) {
                    final label = _formatClassroomOption(classroom);
                    return DropdownMenuItem<String>(
                      value: classroom.classroomCode,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClassroomCode = value;
                      _loading = true;
                    });
                    _loadData();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatClassroomOption(ClassroomModel classroom) {
    final section = classroom.gradeAndSection?.trim();
    final displayName = (section?.isNotEmpty == true
            ? section
            : classroom.classroomName.isNotEmpty
                ? classroom.classroomName
                : null) ??
        classroom.classroomCode;
    return '$displayName (${classroom.classroomCode})';
  }

  String get _activeClassroomLabel {
    final match = _getSelectedClassroom();
    if (match != null) {
      if (match.gradeAndSection != null &&
          match.gradeAndSection!.trim().isNotEmpty) {
        return match.gradeAndSection!;
      }
      if (match.classroomName.isNotEmpty) {
        return match.classroomName;
      }
      return match.classroomCode;
    }

    if (_currentUser?.classroomName?.isNotEmpty == true) {
      return _currentUser!.classroomName!;
    }
    return _currentUser?.classroomCode ?? 'N/A';
  }

  ClassroomModel? _getSelectedClassroom() {
    if (_selectedClassroomCode == null) return null;
    for (final classroom in _classrooms) {
      if (classroom.classroomCode == _selectedClassroomCode) {
        return classroom;
      }
    }
    return null;
  }
}
