import 'package:flutter/material.dart';
import 'package:jejom/api/trip_api.dart';
import 'package:jejom/models/flight_info.dart';
import 'package:jejom/modules/user/trip/trip_details.dart';
import 'package:jejom/providers/user/trip_provider.dart';
import 'package:jejom/providers/user/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TravelProvider extends ChangeNotifier {
  TripApi tripApi = TripApi();

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

  void updatePrompt(String prompt) {
    this.prompt = prompt;
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

    print("Final prompt $additionalPrompt");

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    // Update trip
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userProps = await userProvider.fetchUserProps(userId ?? "");

    String userPropsString = "";
    userProps.forEach((key, value) {
      userPropsString += "$key: $value; ";
    });

    print("Before Response");
    final response =
        await tripApi.generateTrip(additionalPrompt, userPropsString);
    tripProvider.addTripFromJson(response);
    tripProvider.addTripsToFirebase(userId ?? "");

    isLoading = false;
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TripDetails(
          trip: tripProvider.trips.first,
          isEditing: true,
        ),
      ),
    );
  }
}
