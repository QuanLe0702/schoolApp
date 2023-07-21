class DayOfWeek {
  int? id;
  late String name;

  DayOfWeek({
    this.id,
    required this.name,
  });

  DayOfWeek.fromMap(Map<String, dynamic> map) {
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
