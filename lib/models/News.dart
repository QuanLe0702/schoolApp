import 'package:path/path.dart';

class News {
  int? id;
  late String title;
  late String imageName;
  late String content;
  late String imagePath;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isActive;

  News({
    required this.title,
    required this.imageName,
    required this.content,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

//gọi
  News.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    imageName = map['imageName'];
    content = map['content'];
    imagePath = map['imagePath'];
    createdAt = DateTime.parse(map['createdAt']);
    updatedAt = DateTime.parse(map['updatedAt']);
    isActive = map['isActive'];
  }

//lưu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageName': imageName,
      'content': content,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
