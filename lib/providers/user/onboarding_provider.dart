import 'package:flutter/material.dart';
import 'package:jejom/api/user_api.dart';
import 'package:jejom/modules/user/onboarding/personal_interest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController _mainPageController = PageController();
  int _page = 0;
  int get page => _page;
  PageController get mainPageController => _mainPageController;
  bool isLoading = false;

  // User data
  String name = "";
  String desc = "";
  Set<Interest> selectedInterests = {};
  String residingCity = "";
  String allergies = "";
  String dietary = "";

  // Update values
  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setDesc(String value) {
    desc = value;
    notifyListeners();
  }

  void toggleInterest(Interest interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  void setResidingCity(String value) {
    residingCity = value;
    notifyListeners();
  }

  void setAllergies(String value) {
    allergies = value;
    notifyListeners();
  }

  void setDietary(String value) {
    dietary = value;
    notifyListeners();
  }

  Future<void> updateUser() async {
    try {
      isLoading = true;
      notifyListeners();

      final allergiesSplited =
          allergies.split(',').map((e) => e.trim()).toList();
      List<String> interests = selectedInterests.map((e) => e.name).toList();

      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      print("User ID: $userId");

      if (userId == null) {
        print("User ID not found in SharedPreferences");
        throw Exception("User ID not found in SharedPreferences");
      }

      // Update user in Firestore
      await updateUserInFirestore(userId,
          dietary: dietary,
          allergies: allergiesSplited,
          interests: interests,
          residingCity: residingCity,
          name: name,
          desc: desc);

      await prefs.setBool('onboarded', true);
      isLoading = false;
      notifyListeners();
      nextPage();
      
    } catch (e) {
      // Handle the error appropriately, such as showing an error message to the user
      print("Failed to update user: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  // Page controller
  void previousPage() {
    if (_page == 0) {
      return;
    }

    _page--;
    _mainPageController.animateToPage(_page,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubicEmphasized);
    notifyListeners();
  }

  void nextPage() {
    _page++;
    _mainPageController.animateToPage(_page,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubicEmphasized);
    notifyListeners();
  }
}
