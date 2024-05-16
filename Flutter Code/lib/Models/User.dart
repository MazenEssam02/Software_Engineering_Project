// To parse this JSON data, do
//
//     final appUser = appUserFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AppUser appUserFromJson(String str) => AppUser.fromJson(json.decode(str));

String appUserToJson(AppUser data) => json.encode(data.toJson());

class AppUser {
  AppUser({
    required this.name,
    required this.birthdate,
    required this.bio,
    required this.profilePicture,
    required this.email,
    this.creditScore = 100,
  });

  String name;
  Timestamp birthdate;
  String bio;
  String profilePicture;
  String email;
  num creditScore;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
      name: json["name"],
      birthdate: json["birthdate"],
      bio: json["bio"],
      profilePicture: json["profilePicture"],
      email: json["email"],
      creditScore: json["credit_score"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "birthdate": birthdate,
        "bio": bio,
        "profilePicture": profilePicture,
        "email": email,
        "credit_score": creditScore
      };
}
