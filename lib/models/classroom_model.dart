import 'package:hive/hive.dart';

part 'classroom_model.g.dart';

@HiveType(typeId: 1)
class ClassroomModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String teacherId; // ID of the teacher who created this classroom

  @HiveField(2)
  String classroomName;

  @HiveField(3)
  String classroomCode;

  @HiveField(4)
  String? gradeAndSection;

  @HiveField(5)
  DateTime createdAt;

  ClassroomModel({
    required this.id,
    required this.teacherId,
    required this.classroomName,
    required this.classroomCode,
    this.gradeAndSection,
    required this.createdAt,
  });
}
