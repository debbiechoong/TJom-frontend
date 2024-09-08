import 'package:flutter/material.dart';

class RestaurantOnboardingProvider extends ChangeNotifier {
  String name = '';
  String description = '';
  String phoneNum = '';
  String address = '';

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
}
