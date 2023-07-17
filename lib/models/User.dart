import 'package:flutter/material.dart';

class User {
  int? id;
  late String email;
  late String password;
  late String status;
  late String? resetPasswordToken;
  // late Role role;

  User({
    required this.email,
    required this.password,
    required this.status,
    this.resetPasswordToken,
    // required this.role,
  });

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    password = map['password'];
    status = map['status'];
    resetPasswordToken = map['resetPasswordToken'];
    // role = Role.fromMap(map['role']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'status': status,
      'resetPasswordToken': resetPasswordToken,
      // 'role': role.toMap(),
    };
  }
}
