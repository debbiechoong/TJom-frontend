import 'package:flutter/material.dart';
import 'package:jejom/api/restaurant_api.dart';
import 'package:jejom/models/script_restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantOnboardingProvider extends ChangeNotifier {
  String name = '';
  String description = '';
  String phoneNum = '';
  String address = '';
  double latitude = 0.0;
  double longitude = 0.0;
  List<String> images = [];

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setPhoneNum(String value) {
    phoneNum = value;
    notifyListeners();
  }

  void setAddress(String value) {
    address = value;
    notifyListeners();
  }

  void setLatitude(double value) {
    latitude = value;
    notifyListeners();
  }

  void setLongitude(double value) {
    longitude = value;
    notifyListeners();
  }

  void setImages(List<String> value) {
    images = value;
    notifyListeners();
  }

  void clear() {
    name = '';
    description = '';
    phoneNum = '';
    address = '';
    latitude = 0.0;
    longitude = 0.0;
    images = [];
    notifyListeners();
  }

  Future<void> uploadToDB() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print("User ID not found in SharedPreferences");
      throw Exception("User ID not found in SharedPreferences");
    }

    // Upload data to database
    ScriptRestaurant restaurant = ScriptRestaurant(
      address: address,
      description: description,
      images: images,
      name: name,
      // lat: latitude,
      // long: longitude,
      // phoneNum: phoneNum,
    );

    await createRestaurantInFirestore(userId, restaurant);
    print("Restaurant created");
    await prefs.setBool('onboarded', true);
    await prefs.setBool('isRestaurant', true);
  }
}
