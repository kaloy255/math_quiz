import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String role; // 'teacher' or 'student'

  @HiveField(5)
  String? classroomCode;

  @HiveField(6)
  String? classroomName;

  @HiveField(7)
  int xp;

  @HiveField(8)
  String badge;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  int? lrn; // Learner Reference Number

  @HiveField(11)
  String? gradeAndSection; // Grade and Section for classroom

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.classroomCode,
    this.classroomName,
    this.xp = 0,
    this.badge = 'Beginner',
    required this.createdAt,
    this.lrn,
    this.gradeAndSection,
  });

  // Helper method to create a student
  factory UserModel.student({
    required String id,
    required String name,
    required String email,
    required String password,
    required String classroomCode,
    int? lrn,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      role: 'student',
      classroomCode: classroomCode,
      createdAt: DateTime.now(),
      lrn: lrn,
    );
  }

  // Helper method to create a teacher
  factory UserModel.teacher({
    required String id,
    required String name,
    required String email,
    required String password,
    String? classroomName,
    String? classroomCode,
    int? lrn,
    String? gradeAndSection,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      role: 'teacher',
      classroomName: classroomName,
      classroomCode: classroomCode,
      createdAt: DateTime.now(),
      lrn: lrn,
      gradeAndSection: gradeAndSection,
    );
  }
}
