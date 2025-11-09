// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_attempt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizAttemptModelAdapter extends TypeAdapter<QuizAttemptModel> {
  @override
  final int typeId = 2;

  @override
  QuizAttemptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizAttemptModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      quizId: fields[2] as String,
      quizTitle: fields[3] as String,
      score: fields[4] as int,
      totalQuestions: fields[5] as int,
      correctAnswers: fields[6] as int,
      completedAt: fields[7] as DateTime,
      quarter: fields[8] as String,
      xpEarned: fields[9] as int,
      badgeEarned: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuizAttemptModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.quizId)
      ..writeByte(3)
      ..write(obj.quizTitle)
      ..writeByte(4)
      ..write(obj.score)
      ..writeByte(5)
      ..write(obj.totalQuestions)
      ..writeByte(6)
      ..write(obj.correctAnswers)
      ..writeByte(7)
      ..write(obj.completedAt)
      ..writeByte(8)
      ..write(obj.quarter)
      ..writeByte(9)
      ..write(obj.xpEarned)
      ..writeByte(10)
      ..write(obj.badgeEarned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAttemptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
