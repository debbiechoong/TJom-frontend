import 'package:flutter/material.dart';
import 'package:jejom/api/restaurant_api.dart';
import 'package:jejom/api/script_api.dart';
import 'package:jejom/models/script_restaurants.dart';
import 'package:jejom/modules/restaurant/script_generator/ScriptGenerationSuccess.dart';
import 'package:jejom/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void sendPrompt(BuildContext context, int charactersNum) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      debugPrint('User ID not found in SharedPreferences');
      return;
    }

    ScriptRestaurant? restaurant = await fetchRestaurantFromFirestore(userId);
    if (restaurant == null) {
      debugPrint('Restaurant not found in Firestore');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingWidget(),
    );

    try {
      await generateScript(
          userId, charactersNum, restaurant.name, restaurant.description);

      Navigator.of(context).pop();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ScriptGenerationSuccess(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error generating script: $e');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to generate script. Please try again."),
        ),
      );
    }
  }
}
