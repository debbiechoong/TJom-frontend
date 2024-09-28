import 'package:flutter/material.dart';
import 'package:jejom/api/trip_api.dart';
import 'package:jejom/models/flight_info.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/providers/user/trip_provider.dart';
import 'package:jejom/providers/user/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jejom/providers/user/interest_provider.dart';

class TravelProvider extends ChangeNotifier {
  final PageController _mainPageController = PageController();
  int _page = 0;
  TripApi tripApi = TripApi();

  int get page => _page;
  PageController get mainPageController => _mainPageController;

  String prompt = "";
  bool isLoading = false;
  List<FlightInfo> selectedFlights = [];

  // Any missing details
  bool isDuration = false;
  bool isBudget = false;
  bool isNumberPerson = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String budget = "";
  int numberPerson = 1;

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
    if (_mainPageController.hasClients) {
      _page++;
      _mainPageController.animateToPage(
        _page,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubicEmphasized,
      );
      notifyListeners();
    }
  }

  // void toggleSelectedFlight(FlightInfo flight) {
  //   if (selectedFlights.any((element) => element.id == flight.id)) {
  //     removeSelectedFlight(flight);
  //   } else {
  //     //Remove duplicate origin and destination
  //     selectedFlights.removeWhere((element) =>
  //         element.origin == flight.origin &&
  //         element.destination == flight.destination);
  //     addSelectedFlight(flight);
  //   }
  // }

  // void addSelectedFlight(FlightInfo flight) {
  //   selectedFlights.add(flight);
  //   notifyListeners();
  // }

  // void removeSelectedFlight(FlightInfo flight) {
  //   selectedFlights.removeWhere((element) => element.id == flight.id);
  //   notifyListeners();
  // }

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
    notifyListeners();

    print("prompt: $prompt");

    final response = await tripApi.checkInitInput(prompt);
    // print(response);

    //call API, route if success
    isDuration = !response['isDuration'];
    isBudget = !response['isBudget'];
    isNumberPerson = response['isNumPerson'];

    isLoading = false;
    notifyListeners();
  }

  void updateNumberPerson(int numberPerson) {
    this.numberPerson = numberPerson;
  }

  void updateBudget(String budget) {
    this.budget = budget;
  }

  Future<void> sendTravelDetails(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    String additionalPrompt = "$prompt\n";
    if (isDuration) {
      additionalPrompt += "Start Date: $startDate\n";
      additionalPrompt += "End Date: $endDate\n";
    }
    if (isBudget) {
      additionalPrompt += "Budget: $budget\n";
    }
    if (isNumberPerson) {
      additionalPrompt += "Number of Persons: $numberPerson\n";
    }

    print(additionalPrompt);

    // Update user
    final interestProvider =
        Provider.of<InterestProvider>(context, listen: false);
    await interestProvider.fetchTrendingInterests();
    await interestProvider.recommendBestDestinations();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(interestProvider.userId);

    DocumentSnapshot userSnapshot = await userDoc.get();
    List<String> existingInterests =
        List<String>.from(userSnapshot['interests'] ?? []);
    List<InterestDestination> existingInterestDestinations = [];

    if (userSnapshot.exists) {
      QuerySnapshot destinationsSnapshot =
          await userDoc.collection('interestDestinations').get();
      existingInterestDestinations = destinationsSnapshot.docs
          .map((doc) =>
              InterestDestination.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    }

    Set<String> updatedInterests = {
      ...existingInterests,
      // ...selectedInterests.map((e) => e.name)
    };

    await userDoc.update({
      'interests': updatedInterests.toList(),
      'startDate': startDate,
      'endDate': endDate,
      'budget': budget,
      'numberPerson': numberPerson,
    });

    final newInterestDestinations = interestProvider.getInterests();
    final updatedInterestDestinations = {
      ...existingInterestDestinations,
      ...newInterestDestinations
    };

    final interestsCollection = userDoc.collection('interestDestinations');
    final batch = firestore.batch();

    for (final interest in updatedInterestDestinations) {
      final docRef = interestsCollection.doc(interest.id);
      batch.set(docRef, interest.toJson());
    }

    await batch.commit();

    // Update trip
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userProps =
        await userProvider.fetchUserProps(interestProvider.userId);

    String userPropsString = "";
    userProps.forEach((key, value) {
      userPropsString += "$key: $value; ";
    });

    final response =
        await tripApi.generateTrip(additionalPrompt, userPropsString);
    tripProvider.addTripFromJson(response);

    isLoading = false;
    notifyListeners();
    nextPage();
  }
}
