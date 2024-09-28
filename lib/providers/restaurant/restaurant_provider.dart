import 'package:flutter/material.dart';
import 'package:jejom/api/restaurant_api.dart';
import 'package:jejom/models/script_restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantProvider extends ChangeNotifier {
  ScriptRestaurant? _restaurant;

  RestaurantProvider() {
    fetchRestaurant();
  }

  ScriptRestaurant? get restaurant => _restaurant;

  void setRestaurant(ScriptRestaurant? restaurant) {
    _restaurant = restaurant;
    notifyListeners();
  }

  Future<void> fetchRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print('User ID not found in SharedPreferences');
      return;
    }

    // Fetch restaurant from Firestore
    try {
      final restaurant = await fetchRestaurantFromFirestore(userId);
      setRestaurant(restaurant);
      print("Restaurant set");
    } catch (e) {
      // Handle errors (e.g., connection issues)
      print("Failed to fetch restaurant from Firestore: $e");
    }
  }
}
