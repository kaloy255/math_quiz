import 'package:hive/hive.dart';

part 'quiz_attempt_model.g.dart';

@HiveType(typeId: 2)
class QuizAttemptModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String quizId;

  @HiveField(3)
  String quizTitle;

  @HiveField(4)
  int score; // Score as percentage (0-100)

  @HiveField(5)
  int totalQuestions;

  @HiveField(6)
  int correctAnswers;

  @HiveField(7)
  DateTime completedAt;

  @HiveField(8)
  String quarter;

  @HiveField(9)
  int xpEarned;

  @HiveField(10)
  String badgeEarned;

  QuizAttemptModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
    required this.quarter,
    this.xpEarned = 0,
    this.badgeEarned = '',
  });
}
