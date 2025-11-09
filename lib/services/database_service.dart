import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;
import '../models/user_model.dart';
import '../models/classroom_model.dart';

class DatabaseService {
  static const String _userBoxName = 'users';
  static const String _currentUserBoxName = 'currentUser';
  static const String _quizAttemptBoxName = 'quizAttempts';
  static const String _quizStatsBoxName = 'quizStats';
  static const String _classroomBoxName = 'classrooms';
  static const _uuid = Uuid();

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ClassroomModelAdapter());
    }

    // Open boxes with error handling for corrupted data
    try {
      await Hive.openBox<UserModel>(_userBoxName);
    } catch (e) {
      // If box is corrupted, delete and recreate
      if (Hive.isBoxOpen(_userBoxName)) {
        await Hive.box(_userBoxName).close();
      }
      await Hive.deleteBoxFromDisk(_userBoxName);
      await Hive.openBox<UserModel>(_userBoxName);
    }

    try {
      await Hive.openBox(_currentUserBoxName);
    } catch (e) {
      if (Hive.isBoxOpen(_currentUserBoxName)) {
        await Hive.box(_currentUserBoxName).close();
      }
      await Hive.deleteBoxFromDisk(_currentUserBoxName);
      await Hive.openBox(_currentUserBoxName);
    }

    try {
      await Hive.openBox(_quizAttemptBoxName);
    } catch (e) {
      if (Hive.isBoxOpen(_quizAttemptBoxName)) {
        await Hive.box(_quizAttemptBoxName).close();
      }
      await Hive.deleteBoxFromDisk(_quizAttemptBoxName);
      await Hive.openBox(_quizAttemptBoxName);
    }

    try {
      await Hive.openBox(_quizStatsBoxName);
    } catch (e) {
      if (Hive.isBoxOpen(_quizStatsBoxName)) {
        await Hive.box(_quizStatsBoxName).close();
      }
      await Hive.deleteBoxFromDisk(_quizStatsBoxName);
      await Hive.openBox(_quizStatsBoxName);
    }

    try {
      await Hive.openBox<ClassroomModel>(_classroomBoxName);
    } catch (e) {
      if (Hive.isBoxOpen(_classroomBoxName)) {
        await Hive.box(_classroomBoxName).close();
      }
      await Hive.deleteBoxFromDisk(_classroomBoxName);
      await Hive.openBox<ClassroomModel>(_classroomBoxName);
    }

    // Open user preferences box for dark mode and other settings
    try {
      await Hive.openBox('userPreferences');
    } catch (e) {
      if (Hive.isBoxOpen('userPreferences')) {
        await Hive.box('userPreferences').close();
      }
      await Hive.deleteBoxFromDisk('userPreferences');
      await Hive.openBox('userPreferences');
    }
  }

  // Static method to ensure box is open
  static Future<Box> _ensureBoxOpen(String name) async {
    if (!Hive.isBoxOpen(name)) {
      return await Hive.openBox(name);
    }
    return Hive.box(name);
  }

  // Make _ensureBoxOpen accessible to ThemeProvider
  static Future<Box> ensurePreferencesBoxOpen() async {
    return await _ensureBoxOpen('userPreferences');
  }

  // Get users box
  static Box<UserModel> getUsersBox() {
    return Hive.box<UserModel>(_userBoxName);
  }

  // Get current user box
  static Box getCurrentUserBox() {
    return Hive.box(_currentUserBoxName);
  }

  // Get classrooms box
  static Box<ClassroomModel> getClassroomsBox() {
    return Hive.box<ClassroomModel>(_classroomBoxName);
  }

  // Register a new user
  static Future<bool> registerUser(UserModel user) async {
    try {
      final usersBox = getUsersBox();

      // Check if email already exists
      final existingUser = usersBox.values.firstWhere(
        (u) => u.email == user.email,
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          password: '',
          role: '',
          createdAt: DateTime.now(),
        ),
      );

      if (existingUser.id.isNotEmpty) {
        return false; // User already exists
      }

      await usersBox.put(user.id, user);
      return true;
    } catch (e) {
      developer.log('Error registering user: $e', name: 'DatabaseService');
      return false;
    }
  }

  // Update user information
  static Future<bool> updateUser(UserModel user) async {
    try {
      final usersBox = getUsersBox();

      // Check if email already exists (for other users)
      if (user.email.isNotEmpty) {
        final existingUser = usersBox.values.firstWhere(
          (u) => u.email == user.email && u.id != user.id,
          orElse: () => UserModel(
            id: '',
            name: '',
            email: '',
            password: '',
            role: '',
            createdAt: DateTime.now(),
          ),
        );

        if (existingUser.id.isNotEmpty) {
          return false; // Email already exists
        }
      }

      await usersBox.put(user.id, user);
      return true;
    } catch (e) {
      developer.log('Error updating user: $e', name: 'DatabaseService');
      return false;
    }
  }

  // Check if classroom code exists
  static bool classroomCodeExists(String classroomCode) {
    try {
      final classroomsBox = getClassroomsBox();
      return classroomsBox.values.any((c) => c.classroomCode == classroomCode);
    } catch (e) {
      developer.log(
        'Error checking classroom code: $e',
        name: 'DatabaseService',
      );
      return false;
    }
  }

  // Create a new classroom
  static Future<bool> createClassroom({
    required String teacherId,
    required String classroomName,
    required String classroomCode,
    String? gradeAndSection,
  }) async {
    try {
      final classroomsBox = getClassroomsBox();

      // Check if classroom code already exists
      if (classroomCodeExists(classroomCode)) {
        return false;
      }

      final classroom = ClassroomModel(
        id: _uuid.v4(),
        teacherId: teacherId,
        classroomName: classroomName,
        classroomCode: classroomCode,
        gradeAndSection: gradeAndSection,
        createdAt: DateTime.now(),
      );

      await classroomsBox.put(classroom.id, classroom);
      return true;
    } catch (e) {
      developer.log('Error creating classroom: $e', name: 'DatabaseService');
      return false;
    }
  }

  // Get classrooms by teacher ID
  static List<ClassroomModel> getClassroomsByTeacher(String teacherId) {
    try {
      final classroomsBox = getClassroomsBox();
      return classroomsBox.values
          .where((c) => c.teacherId == teacherId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
    } catch (e) {
      developer.log('Error getting classrooms: $e', name: 'DatabaseService');
      return [];
    }
  }

  // Get classroom by code
  static ClassroomModel? getClassroomByCode(String classroomCode) {
    try {
      final classroomsBox = getClassroomsBox();
      final classroom = classroomsBox.values.firstWhere(
        (c) => c.classroomCode == classroomCode,
        orElse: () => ClassroomModel(
          id: '',
          teacherId: '',
          classroomName: '',
          classroomCode: '',
          createdAt: DateTime.now(),
        ),
      );
      // Return null if classroom not found (empty id indicates not found)
      return classroom.id.isEmpty ? null : classroom;
    } catch (e) {
      developer.log('Error getting classroom: $e', name: 'DatabaseService');
      return null;
    }
  }

  // Delete a classroom
  static Future<bool> deleteClassroom(String classroomId) async {
    try {
      final classroomsBox = getClassroomsBox();
      await classroomsBox.delete(classroomId);
      return true;
    } catch (e) {
      developer.log('Error deleting classroom: $e', name: 'DatabaseService');
      return false;
    }
  }

  // Login user
  static Future<UserModel?> loginUser(String email, String password) async {
    try {
      final usersBox = getUsersBox();

      final user = usersBox.values.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          password: '',
          role: '',
          createdAt: DateTime.now(),
        ),
      );

      if (user.id.isEmpty) {
        return null; // User not found or wrong password
      }

      // Save current user
      final currentUserBox = getCurrentUserBox();
      await currentUserBox.put('userId', user.id);

      return user;
    } catch (e) {
      developer.log('Error logging in: $e', name: 'DatabaseService');
      return null;
    }
  }

  // Get current logged-in user
  static UserModel? getCurrentUser() {
    try {
      final currentUserBox = getCurrentUserBox();
      final userId = currentUserBox.get('userId');

      if (userId == null) return null;

      final usersBox = getUsersBox();
      return usersBox.get(userId);
    } catch (e) {
      developer.log('Error getting current user: $e', name: 'DatabaseService');
      return null;
    }
  }

  // Logout user
  static Future<void> logout() async {
    final currentUserBox = getCurrentUserBox();
    await currentUserBox.delete('userId');
  }

  // Update user XP
  static Future<void> updateUserXP(String userId, int newXP) async {
    final usersBox = getUsersBox();
    final user = usersBox.get(userId);

    if (user != null) {
      user.xp = newXP;
      await user.save();
    }
  }

  // Update user badge
  static Future<void> updateUserBadge(String userId, String newBadge) async {
    final usersBox = getUsersBox();
    final user = usersBox.get(userId);

    if (user != null) {
      user.badge = newBadge;
      await user.save();
    }
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    final currentUserBox = getCurrentUserBox();
    return currentUserBox.get('userId') != null;
  }

  // Save quiz attempt
  // Returns the XP earned for this attempt (only for NEW correct answers)
  static Future<int> saveQuizAttempt({
    required String quizId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required String quarter,
    List<int>? correctQuestionIndices,
  }) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) return 0;

      final attemptsBox = Hive.box(_quizAttemptBoxName);

      // Get user's existing attempts for this quiz
      final allAttempts = attemptsBox.values.toList();
      final userAttempts = allAttempts
          .where(
            (attempt) =>
                attempt['userId'] == currentUser.id &&
                attempt['quizId'] == quizId,
          )
          .toList();

      // Get previously correct questions
      Set<int> allCorrectQuestions = {};
      for (var attempt in userAttempts) {
        if (attempt['correctQuestionIndices'] != null) {
          allCorrectQuestions.addAll(
            (attempt['correctQuestionIndices'] as List).map((e) => e as int),
          );
        }
      }

      // Calculate XP based on whether this is the first attempt
      int xpEarned = 0;

      // If this is NOT the first attempt (userAttempts is not empty), give 0 XP
      if (userAttempts.isNotEmpty) {
        // Second attempt or later - no XP earned
        xpEarned = 0;
      } else {
        // First attempt - give XP for correct answers
        final correctCount = correctQuestionIndices?.length ?? 0;
        xpEarned = correctCount * 10;
      }

      // Add new correct questions to the set (for best score tracking)
      allCorrectQuestions.addAll(correctQuestionIndices ?? []);
      final badgeEarned = _getBadgeForScore(score);

      // Save the attempt
      final attemptId = _uuid.v4();
      await attemptsBox.put(attemptId, {
        'id': attemptId,
        'userId': currentUser.id,
        'quizId': quizId,
        'quizTitle': quizTitle,
        'score': score,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'completedAt': DateTime.now().toIso8601String(),
        'quarter': quarter,
        'xpEarned': xpEarned,
        'badgeEarned': badgeEarned,
        'correctQuestionIndices': correctQuestionIndices ?? [],
      });

      // Always update user's total XP when completing a quiz
      final newTotalXP = currentUser.xp + xpEarned;
      await updateUserXP(currentUser.id, newTotalXP);

      // Update aggregate quiz stats (count correct/wrong on FIRST attempt only)
      await _updateQuizStatsOnAttempt(
        userId: currentUser.id,
        quizId: quizId,
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
      );

      // Update badge based on best score if this is the best attempt
      bool isBestScore = true;
      if (userAttempts.isNotEmpty) {
        final bestScore = userAttempts
            .map((a) => a['score'] as int)
            .reduce((a, b) => a > b ? a : b);
        isBestScore = score > bestScore;
      }

      // Update badge if earned (only for best score)
      if (isBestScore && badgeEarned.isNotEmpty) {
        await updateUserBadge(currentUser.id, badgeEarned);
      }

      // Return the XP earned for this attempt
      return xpEarned;
    } catch (e) {
      developer.log('Error saving quiz attempt: $e', name: 'DatabaseService');
      return 0;
    }
  }

  // Get quiz attempts for current user
  static List<Map<String, dynamic>> getUserQuizAttempts() {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) return [];

      final attemptsBox = Hive.box(_quizAttemptBoxName);
      final allAttempts = attemptsBox.values.toList();

      return allAttempts
          .where((attempt) => attempt['userId'] == currentUser.id)
          .map((attempt) => Map<String, dynamic>.from(attempt))
          .toList();
    } catch (e) {
      developer.log('Error getting quiz attempts: $e', name: 'DatabaseService');
      return [];
    }
  }

  // Get best score for a specific quiz
  static int? getBestScoreForQuiz(String quizId) {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) return null;

      final attemptsBox = Hive.box(_quizAttemptBoxName);
      final allAttempts = attemptsBox.values.toList();

      final userAttempts = allAttempts
          .where(
            (attempt) =>
                attempt['userId'] == currentUser.id &&
                attempt['quizId'] == quizId,
          )
          .toList();

      if (userAttempts.isEmpty) return null;

      return userAttempts
          .map((a) => a['score'] as int)
          .reduce((a, b) => a > b ? a : b);
    } catch (e) {
      developer.log('Error getting best score: $e', name: 'DatabaseService');
      return null;
    }
  }

  // Get remaining XP for a specific quiz
  static int getRemainingXPForQuiz(
    String quizId,
    int totalQuestions, [
    String? quarter,
  ]) {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) return totalQuestions * 10;

      final attemptsBox = Hive.box(_quizAttemptBoxName);
      final allAttempts = attemptsBox.values.toList();

      final userAttempts = allAttempts
          .where(
            (attempt) =>
                attempt['userId'] == currentUser.id &&
                attempt['quizId'] == quizId &&
                (quarter == null || attempt['quarter'] == quarter),
          )
          .toList();

      // If user has already attempted this quiz, remaining XP is 0
      // (XP can only be earned on first attempt)
      if (userAttempts.isNotEmpty) {
        return 0;
      }

      // If no attempts yet, return full XP potential
      return totalQuestions * 10;
    } catch (e) {
      developer.log('Error getting remaining XP: $e', name: 'DatabaseService');
      return totalQuestions * 10;
    }
  }

  // Get XP earned from first attempt of a quiz
  static int getXPEarnedFromFirstAttempt(String quizId, String? quarter) {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) return 0;

      final attemptsBox = Hive.box(_quizAttemptBoxName);
      final allAttempts = attemptsBox.values.toList();

      final userAttempts = allAttempts
          .where(
            (attempt) =>
                attempt['userId'] == currentUser.id &&
                attempt['quizId'] == quizId &&
                (quarter == null || attempt['quarter'] == quarter),
          )
          .toList();

      // If no attempts, return 0
      if (userAttempts.isEmpty) return 0;

      // Get the first attempt (earliest completedAt)
      final firstAttempt = userAttempts.reduce(
        (a, b) =>
            DateTime.parse(
              a['completedAt'] as String,
            ).isBefore(DateTime.parse(b['completedAt'] as String))
            ? a
            : b,
      );

      // Return XP earned from first attempt
      return firstAttempt['xpEarned'] as int? ?? 0;
    } catch (e) {
      developer.log(
        'Error getting XP from first attempt: $e',
        name: 'DatabaseService',
      );
      return 0;
    }
  }

  // Calculate XP based on score
  static int _calculateXP(int score, int totalQuestions) {
    if (score == 100) return 150; // Perfect score
    if (score >= 80) return 100; // Great score
    if (score >= 60) return 75; // Good score
    if (score >= 40) return 50; // Average score
    return 25; // Needs improvement
  }

  // Get badge based on score
  static String _getBadgeForScore(int score) {
    if (score == 100) return 'Perfect Master';
    if (score >= 90) return 'Math Genius';
    if (score >= 80) return 'Excellent Student';
    if (score >= 70) return 'Good Learner';
    return '';
  }

  // =====================
  // Aggregate Quiz Stats
  // =====================
  // Structure stored per userId in box 'quizStats':
  // {
  //   'userId': <id>,
  //   'totalCorrect': int,
  //   'totalWrong': int,
  //   'firstAttemptedQuizIds': <List<String>> // tracks quizIds already counted
  // }

  static Future<void> _updateQuizStatsOnAttempt({
    required String userId,
    required String quizId,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    final statsBox = await _ensureBoxOpen(_quizStatsBoxName);
    final existing = Map<String, dynamic>.from(
      (statsBox.get(userId) as Map?) ?? {},
    );

    final List<dynamic> attempted = List<dynamic>.from(
      (existing['firstAttemptedQuizIds'] as List?) ?? <String>[],
    );

    // Only count stats on first attempt for a quiz
    if (!attempted.contains(quizId)) {
      final int prevCorrect = (existing['totalCorrect'] as int?) ?? 0;
      final int prevWrong = (existing['totalWrong'] as int?) ?? 0;
      final int wrong = (totalQuestions - correctAnswers).clamp(
        0,
        totalQuestions,
      );

      attempted.add(quizId);

      await statsBox.put(userId, {
        'userId': userId,
        'totalCorrect': prevCorrect + correctAnswers,
        'totalWrong': prevWrong + wrong,
        'firstAttemptedQuizIds': attempted,
      });
    }
  }

  static Future<Map<String, dynamic>>
  getAggregateQuizStatsForCurrentUser() async {
    final currentUser = getCurrentUser();
    if (currentUser == null) {
      return {
        'totalCorrect': 0,
        'totalWrong': 0,
        'firstAttemptedQuizIds': <String>[],
      };
    }
    final statsBox = await _ensureBoxOpen(_quizStatsBoxName);
    final data = Map<String, dynamic>.from(
      (statsBox.get(currentUser.id) as Map?) ?? {},
    );
    return {
      'totalCorrect': (data['totalCorrect'] as int?) ?? 0,
      'totalWrong': (data['totalWrong'] as int?) ?? 0,
      'firstAttemptedQuizIds': List<String>.from(
        (data['firstAttemptedQuizIds'] as List?) ?? <String>[],
      ),
    };
  }
}
