class Student {
  late String name;
  late String className;
  Student(this.name, this.className);
  Student.fromJson(Map<String, dynamic> body) {
    name = body["name"];
    className = body["className"];
  }
}
