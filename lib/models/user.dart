import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final Timestamp createdAt;
  final String dietary;
  final List<String> allergies;
  final List<String> interests;

  User({
    required this.userId,
    required this.createdAt,
    required this.dietary,
    required this.allergies,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      createdAt: json['created_at'] as Timestamp,
      dietary: json['dietary'] as String,
      allergies: List<String>.from(json['allergies']),
      interests: List<String>.from(json['interests']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'created_at': createdAt,
      'dietary': dietary,
      'allergies': allergies,
      'interests': interests,
    };
  }

  User copyWith({
    String? userId,
    Timestamp? createdAt,
    String? dietary,
    List<String>? allergies,
    List<String>? interests,
  }) {
    return User(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      dietary: dietary ?? this.dietary,
      allergies: allergies ?? this.allergies,
      interests: interests ?? this.interests,
    );
  }
}
