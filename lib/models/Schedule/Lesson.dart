class Lesson {
  int? id;
  late String name;

  Lesson({
    this.id,
    required this.name,
  });

  Lesson.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
