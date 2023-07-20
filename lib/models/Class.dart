class Class {
  int? id;
  late String name;
  late String grade;
  late String description;

  Class({
    this.id,
    required this.name,
    required this.grade,
    required this.description,
  });

  Class.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    grade = map['grade'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'description': description,
    };
  }
}
