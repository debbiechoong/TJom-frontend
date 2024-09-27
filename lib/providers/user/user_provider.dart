import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jejom/api/user_api.dart';
import 'package:jejom/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  UserProvider() {
    fetchUser();
  }

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print('User ID not found in SharedPreferences');
      return;
    }

    // Fetch user from Firestore
    try {
      final user = await fetchUserFromFirestore(userId);
      setUser(user);
      print("User set");
    } catch (e) {
      // Handle errors (e.g., connection issues)
      await createUserInFirestore(userId);
    }
  }

  Future<void> updateUser(String userId,
      {String? dietary,
      List<String>? allergies,
      List<String>? interests}) async {
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(data);
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

  // get user from firestore
  Future<Map<String, String>> fetchUserProps(String userId) async {
    final user = await fetchUserFromFirestore(userId);
    // Return user props if user is not null
    if (user != null) {
      var userProps = {
        'interests': user.interests.join(','),
        'dietary': user.dietary,
        'allergies': user.allergies.join(','),
        'desc': user.desc,
        'residingCity': user.residingCity,
      };
      debugPrint('User props: $userProps');
      return userProps;
    }
    debugPrint('User is null');
    return {};
  }
}
