import 'package:school/models/AcademicYear.dart';

class Class {
  int? id;
  late String name;
  late String grade;
  late String description;
  late AcademicYear academicYearId;
  Class({
    this.id,
    required this.name,
    required this.grade,
    required this.description,
    required this.academicYearId,
  });

  Class.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    grade = map['grade'];
    description = map['description'] ?? '';
    academicYearId = AcademicYear.fromMap(map['academicYear']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'description': description,
      'academicYearId': academicYearId,
    };
  }
}
