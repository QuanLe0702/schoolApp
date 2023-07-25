class Lesson {
  int? id;
  late String name;
  late String startTime;
  late String endTime;

  Lesson({
    this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  Lesson.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    startTime = map['startTime'];
    endTime = map['endTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
