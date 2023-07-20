class Subject {
  int? id;
  late String name;

  Subject({
    required this.id,
    required this.name,
  });

  Subject.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Subject{id: $id, name: $name}';
  }
}
