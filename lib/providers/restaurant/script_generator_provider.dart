import 'package:flutter/material.dart';

class RestaurantScriptGeneratorProvider extends ChangeNotifier {
  String prompt = "";

  void updatePrompt(String value) {
    prompt = value;
    notifyListeners();
  }

  void sendPrompt() {
    print(prompt);
  }
}
