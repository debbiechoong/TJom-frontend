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
}
