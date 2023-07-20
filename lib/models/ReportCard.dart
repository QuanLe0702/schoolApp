import 'package:school/models/AcademicYear.dart';
import 'package:school/models/Student.dart';

class ReportCard {
  late Student studentId;
  late String violate;
  late String description;
  late DateTime date;
  late AcademicYear academicYearId;

  ReportCard({
    required this.studentId,
    required this.violate,
    required this.description,
    required this.date,
    required this.academicYearId,
  });

  ReportCard.fromMap(Map<String, dynamic> map) {
    studentId = Student.fromMap(map['student']);
    violate = map['violate'];
    description = map['description'];
    date = DateTime.parse(map['date']);
    academicYearId = AcademicYear.fromMap(map['academicYear']);
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'violate': violate,
      'description': description,
      'date': date.toIso8601String(),
      'academicYearId': academicYearId,
    };
  }
}
