import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final Timestamp createdAt;
  final String dietary;
  final List<String> allergies;
  final List<String> interests;
  final String name;
  final String desc;
  final String residingCity;

  User({
    required this.userId,
    required this.createdAt,
    required this.dietary,
    required this.allergies,
    required this.interests,
    required this.name,
    required this.desc,
    required this.residingCity,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      createdAt: json['created_at'] as Timestamp,
      dietary: json['dietary'] as String,
      allergies: List<String>.from(json['allergies']),
      interests: List<String>.from(json['interests']),
      name: json['name'] as String,
      desc: json['desc'] as String,
      residingCity: json['residingCity'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'created_at': createdAt,
      'dietary': dietary,
      'allergies': allergies,
      'interests': interests,
      'name': name,
      'desc': desc,
      'residingCity': residingCity,
    };
  }

  User copyWith({
    String? userId,
    Timestamp? createdAt,
    String? dietary,
    List<String>? allergies,
    List<String>? interests,
    String? name,
    String? desc,
    String? residingCity,
  }) {
    return User(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      dietary: dietary ?? this.dietary,
      allergies: allergies ?? this.allergies,
      interests: interests ?? this.interests,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      residingCity: residingCity ?? this.residingCity,
    );
  }
}
