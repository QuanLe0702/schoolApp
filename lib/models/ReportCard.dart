import 'dart:ffi';

class ReportCard {
  late Long studentId;
  late String violate;
  late String description;
  late DateTime date;
  late Long academicYearId;

  ReportCard({
    required this.studentId,
    required this.violate,
    required this.description,
    required this.date,
    required this.academicYearId,
  });

  ReportCard.fromMap(Map<String, dynamic> map) {
    studentId = map['studentId'];
    violate = map['violate'];
    description = map['description'];
    date = DateTime.parse(map['date']);
    academicYearId = map['academicYearId'];
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
