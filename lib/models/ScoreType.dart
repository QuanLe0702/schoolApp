class ScoreType {
  int? id;
  late String name;
  late int coefficient;
  late String description;
  // late Classes className;

  ScoreType({
    this.id,
    required this.name,
    required this.coefficient,
    required this.description,
  });

  ScoreType.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    coefficient = map['coefficient'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'coefficient': coefficient,
      'description': description,
    };
  }
}
