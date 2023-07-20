import 'package:flutter/material.dart';

class Student {
  int? id;
  late String name;
  late String gender;
  late DateTime dob;
  late String email;
  late String address;
  late String phone;
  late String status;
  late String image;
  // late Classes className;

  Student({
    this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.email,
    required this.address,
    required this.phone,
    required this.status,
    this.image = '',
  });

  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    gender = map['gender'];
    dob = DateTime.parse(map['dob']);
    email = map['email'];
    address = map['address'];
    phone = map['phone'];
    status = map['status'];
    image = map['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'email': email,
      'address': address,
      'phone': phone,
      'status': status,
      'image': image,
    };
  }
}
