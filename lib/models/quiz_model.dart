import 'package:hive/hive.dart';

part 'quiz_model.g.dart';

@HiveType(typeId: 1)
class QuizModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String quarter;

  @HiveField(3)
  int xp; // XP earned for completing this quiz

  @HiveField(4)
  String badge; // Badge received for completing this quiz

  @HiveField(5)
  int? highestScore; // Highest score achieved (0-100)

  @HiveField(6)
  int attempts; // Number of attempts

  @HiveField(7)
  DateTime? lastAttempt;

  QuizModel({
    required this.id,
    required this.title,
    required this.quarter,
    this.xp = 100,
    this.badge = '',
    this.highestScore,
    this.attempts = 0,
    this.lastAttempt,
  });
}
