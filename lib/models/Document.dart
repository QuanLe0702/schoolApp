import 'package:flutter/material.dart';
import 'package:school/models/User.dart';

class Document {
  int? id;
  late String fileName;
  late String title;
  late String description;
  late String filePath;
  late User uploadedBy;
  late DateTime uploadedAt;
  late DateTime updatedAt;

  Document({
    this.id,
    required this.fileName,
    required this.title,
    this.description = '',
    this.filePath = '',
    required this.uploadedBy,
    required this.uploadedAt,
    required this.updatedAt,
  });

  Document.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fileName = map['fileName'];
    title = map['title'];
    description = map['description'];
    filePath = map['filePath'];
    uploadedBy = User.fromMap(map['uploadedBy']);
    uploadedAt = DateTime.parse(map['uploadedAt']);
    updatedAt = DateTime.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'title': title,
      'description': description,
      'filePath': filePath,
      'uploadedBy': uploadedBy.toMap(),
      'uploadedAt': uploadedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
