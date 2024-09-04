import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jejom/api/user_api.dart';
import 'package:jejom/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  UserProvider(String userId) {
    fetchUser(userId);
  }

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUser(String userId) async {
    // Fetch user from Firestore
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        setUser(User.fromJson(userDoc.data() as Map<String, dynamic>));
      } else {
        await createUserInFirestore(userId);
      }
    } catch (e) {
      // Handle errors (e.g., connection issues)
      await createUserInFirestore(userId);
    }
  }

  Future<void> updateUser(String userId,
      {String? dietary, List<String>? allergies, List<String>? interests}) async {
    final Map<String, dynamic> data = {};
    if (dietary != null) {
      data['dietary'] = dietary;
    }
    if (allergies != null) {
      data['allergies'] = allergies;
    }
    if (interests != null) {
      data['interests'] = interests;
    }
    await FirebaseFirestore.instance.collection('users').doc(userId).update(data);
  }

  // update allergies
  Future<void> updateUserAllergies(List<String> allergies) async {
    try {
      await updateUserInFirestore(user!.userId, allergies: allergies);
      setUser(user!.copyWith(allergies: allergies));
    } catch (e) {
      // Handle errors (e.g., connection issues)
    }
  }

  // update dietary
  Future<void> updateUserDietary(String dietary) async {
    try {
      await updateUserInFirestore(user!.userId, dietary: dietary);
      setUser(user!.copyWith(dietary: dietary));
    } catch (e) {
      // Handle errors (e.g., connection issues)
    }
  }

  // update interests
  Future<void> updateUserInterests(List<String> interests) async {
    try {
      await updateUserInFirestore(user!.userId, interests: interests);
      setUser(user!.copyWith(interests: interests));
    } catch (e) {
      // Handle errors (e.g., connection issues)
    }
  }
}
