import 'package:flutter/material.dart';
import 'package:jejom/models/flight.dart';
import 'package:jejom/modules/onboarding/travel_details.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController _mainPageController = PageController();
  int _page = 0;

  int get page => _page;
  PageController get mainPageController => _mainPageController;

  String prompt = "";
  bool isLoading = false;
  List<Flight> selectedFlights = [];

  // Any missing details
  bool isDestination = false;
  bool isDuration = false;
  bool isBudget = false;
  bool isInterest = false;

  String destination = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String budget = "";
  Set<Interest> selectedInterests = {};

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

  void toggleSelectedFlight(Flight flight) {
    if (selectedFlights.any((element) => element.id == flight.id)) {
      removeSelectedFlight(flight);
    } else {
      //Remove duplicate origin and destination
      selectedFlights.removeWhere((element) =>
          element.origin == flight.origin &&
          element.destination == flight.destination);
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

  void updatePrompt(String prompt) {
    this.prompt = prompt;
  }

  void goToLoading() {
    _mainPageController.animateToPage(6,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubicEmphasized);
  }

  void sendPrompt() {
    isLoading = true;
    notifyListeners();

    //set Timeout for 2 seconds to stimulate loading
    Future.delayed(const Duration(seconds: 2), () {
      // print(prompt);

      //call API, route if success
      isDestination = true;
      isDuration = true;
      isBudget = true;
      isInterest = true;

      isLoading = false;
      notifyListeners();
    });
  }

  //Future details
  void updateDestination(String destination) {
    this.destination = destination;
  }

  void updateBudget(String budget) {
    this.budget = budget;
  }

  void toggleInterest(Interest interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  void sendTravelDetails() {
    isLoading = true;
    notifyListeners();

    //set Timeout for 2 seconds to stimulate loading
    Future.delayed(const Duration(seconds: 2), () {
      String additionalPrompt = "";
      if (isDestination) {
        additionalPrompt += "Destination: $destination\n";
      }
      if (isDuration) {
        additionalPrompt += "Start Date: $startDate\n";
        additionalPrompt += "End Date: $endDate\n";
      }
      if (isBudget) {
        additionalPrompt += "Budget: $budget\n";
      }
      if (isInterest) {
        additionalPrompt += "Interest: $selectedInterests\n";
      }

      print(additionalPrompt);

      isLoading = false;
      notifyListeners();
      nextPage();
    });
  }
}
