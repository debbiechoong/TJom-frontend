import 'package:flutter/material.dart';
import 'package:jejom/models/flight.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController _mainPageController = PageController();

  List<Flight> selectedFlights = [];
  int _page = 0;

  void toggleSelectedFlight(Flight flight) {
    if (selectedFlights.any((element) => element.id == flight.id)) {
      removeSelectedFlight(flight);
    } else {
      //Remove duplicate origin and destination
      selectedFlights.removeWhere((element) =>
          element.origin == flight.origin &&
          element.destinations.first == flight.destinations.first);
      addSelectedFlight(flight);
    }
  }

  void addSelectedFlight(Flight flight) {
    selectedFlights.add(flight);
    notifyListeners();
  }

  void removeSelectedFlight(Flight flight) {
    selectedFlights.removeWhere((element) => element.id == flight.id);
    notifyListeners();
  }

  void previousPage() {
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

  int get page => _page;
  PageController get mainPageController => _mainPageController;
}
