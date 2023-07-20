import 'package:school/models/Class.dart';
import 'package:school/models/ScoreType.dart';
import 'package:school/models/Student.dart';
import 'package:school/models/Subject.dart';

class Score {
  late Student studentId;
  late Subject subjectId;
  late ScoreType scoreTypeId;
  late Class classId;
  late int semester;
  late int score;

  Score({
    required this.studentId,
    required this.subjectId,
    required this.scoreTypeId,
    required this.classId,
    required this.semester,
    required this.score,
  });

  Score.fromMap(Map<String, dynamic> map) {
    studentId = Student.fromMap(map['student']);
    subjectId = Subject.fromMap(map['subject']);
    scoreTypeId = ScoreType.fromMap(map['scoreType']);
    classId = Class.fromMap(map['classes']);
    semester = map['semester'];
    score = map['score'];
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'subjectId': subjectId,
      'scoreTypeId': scoreTypeId,
      'classId': classId,
      'semester': semester,
      'score': score,
    };
  }
}
