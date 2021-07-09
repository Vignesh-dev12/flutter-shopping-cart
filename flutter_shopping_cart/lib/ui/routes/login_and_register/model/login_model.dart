// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.name,
    this.dateOfBirth,
    this.password,
  });

  String? name;
  String? dateOfBirth;
  String? password;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"] == null ? null : json["name"],
    dateOfBirth: json["date_of_birth"] == null ? null : json["date_of_birth"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "date_of_birth": dateOfBirth == null ? null : dateOfBirth,
    "password": password == null ? null : password,
  };
}
