import 'package:flutter/material.dart';

class RestaurantScriptGeneratorProvider extends ChangeNotifier {
  String prompt = "";
  int numberOfCharacters = 0;

  void updatePrompt(String value) {
    prompt = value;
    notifyListeners();
  }

  void updateNumberOfCharacters(int value) {
    numberOfCharacters = value;
    notifyListeners();
  }

  void sendPrompt() {
    print(prompt);
  }
}
