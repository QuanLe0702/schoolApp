class AcademicYear {
  int? id;
  late String name;
  late DateTime startDate;
  late DateTime endDate;

  AcademicYear({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  AcademicYear.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    startDate = DateTime.parse(map['startDate']);
    endDate = DateTime.parse(map['endDate']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
