import 'package:flutter/material.dart';
import 'package:jejom/api/trip_api.dart';
import 'package:jejom/models/flight.dart';
import 'package:jejom/modules/onboarding/travel_details.dart';
import 'package:jejom/providers/trip_provider.dart';
import 'package:provider/provider.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController _mainPageController = PageController();
  int _page = 0;
  TripApi tripApi = TripApi();

  int get page => _page;
  PageController get mainPageController => _mainPageController;

  String prompt = "I want to go jeju, from 13 sep to 15 sep";
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

  Future<void> sendPrompt() async {
    isLoading = true;
    nextPage();
    notifyListeners();
    print("prompt: $prompt");

    final response = await tripApi.checkInitInput(prompt);
    // print(response);

    //call API, route if success
    isDestination = !response['isDestination'];
    isDuration = !response['isDuration'];
    isBudget = !response['isBudget'];
    isInterest = !response['isInterest'];

    isLoading = false;
    notifyListeners();
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

  Future<void> sendTravelDetails(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    //set Timeout for 2 seconds to stimulate loading
    String additionalPrompt = "$prompt\n";
    String userInterest = "";
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
      userInterest = "Interest: ${selectedInterests.join(", ")}\n";
    }

    print(additionalPrompt);

    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final response = await tripApi.generateTrip(additionalPrompt, userInterest);
    tripProvider.addTripFromJson(response);

    isLoading = false;
    notifyListeners();
    nextPage();
  }
}
