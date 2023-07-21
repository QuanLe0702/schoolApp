import 'package:school/models/Class.dart';
import 'package:school/models/Schedule/DayOfWeek.dart';
import 'package:school/models/Schedule/Lesson.dart';
import 'package:school/models/Schedule/Teacher.dart';
import 'package:school/models/Subject.dart';

class ScheduleDetail {
  late DayOfWeek dayOfWeekId;
  late Subject subjectId;
  late Lesson lessonId;
  late Class classId;
  late Teacher teacherId;
  late bool status;

  ScheduleDetail({
    required this.dayOfWeekId,
    required this.subjectId,
    required this.lessonId,
    required this.classId,
    required this.teacherId,
    required this.status,
  });

  ScheduleDetail.fromMap(Map<String, dynamic> map) {
    dayOfWeekId = DayOfWeek.fromMap(map['dayOfWeek']);
    subjectId = Subject.fromMap(map['subject']);
    lessonId = Lesson.fromMap(map['lesson']);
    classId = Class.fromMap(map['classes']);
    teacherId = Teacher.fromMap(map['teacher']);
    status = map['status'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dayOfWeekId': dayOfWeekId,
      'subjectId': subjectId,
      'lessonId': lessonId,
      'classId': classId,
      'teacherId': teacherId,
      'status': status,
    };
  }
}
