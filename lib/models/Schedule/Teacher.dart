class Teacher {
  int? id;
  late String name;

  Teacher({
    this.id,
    required this.name,
  });

  Teacher.fromMap(Map<String, dynamic> map) {
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
