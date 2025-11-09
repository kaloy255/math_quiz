import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
    _usersListenable = DatabaseService.getUsersBox().listenable();
    _usersListenable!.addListener(_loadData);
  }

  @override
  void dispose() {
    _usersListenable?.removeListener(_loadData);
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

    final usersBox = DatabaseService.getUsersBox();
    final allUsers = usersBox.values.toList();
    final students = allUsers
        .where(
          (u) => u.role == 'student' && u.classroomCode == user.classroomCode,
        )
        .toList();
    students.sort((a, b) => b.xp.compareTo(a.xp));

    setState(() {
      _students = students;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Color(0xFF6BBF59),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'MathQuest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title Card
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4EDD0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'TOP STUDENTS',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _loading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _buildRankTable(),
                    ],
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
    final classroomLabel = _currentUser?.classroomName?.isNotEmpty == true
        ? _currentUser!.classroomName!
        : (_currentUser?.classroomCode ?? 'N/A');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (Grade & Section + subtitle)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.class_, size: 18, color: Color(0xFF3C6E37)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grade & Section: $classroomLabel',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Column labels
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: const [
                SizedBox(
                  width: 60,
                  child: Text(
                    'RANK',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'NAME',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    'XP',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
    final Color bg = isEvenRow ? const Color(0xFFF8FBF7) : Colors.white;
    final Widget medal = _rankMedal(rank);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: const Border(
          top: BorderSide(color: Color(0x11000000), width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Row(
              children: [
                Text('$rank', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                medal,
              ],
            ),
          ),
          Expanded(
            child: Text(
              student.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          _xpPill(student.xp),
        ],
      ),
    );
  }

  Widget _rankMedal(int rank) {
    if (rank == 1) {
      return const Icon(Icons.emoji_events, size: 16, color: Color(0xFFFFC107));
    }
    if (rank == 2) {
      return const Icon(Icons.emoji_events, size: 16, color: Color(0xFFB0BEC5));
    }
    if (rank == 3) {
      return const Icon(Icons.emoji_events, size: 16, color: Color(0xFFCD7F32));
    }
    return const SizedBox(width: 16);
  }

  Widget _xpPill(int xp) {
    return Container(
      width: 72,
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF7EC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$xp XP',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3C6E37),
          ),
        ),
      ),
    );
  }
}
