import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  PageController _mainPageController = PageController();
  int _page = 0;

  void previousPage() {
    _page--;
    mainPageController.animateToPage(_page,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
    notifyListeners();
  }

  void nextPage() {
    _page++;
    mainPageController.animateToPage(_page,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
    notifyListeners();
  }

  int get page => _page;
  PageController get mainPageController => _mainPageController;
}
