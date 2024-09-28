import 'package:flutter/material.dart';
import 'package:jejom/api/trip_api.dart';
import 'package:jejom/models/trip.dart';

class TripProvider extends ChangeNotifier {
  List<Trip> trips = [];
  TripApi tripApi = TripApi();

  String newPrompt = "";

  void addTripFromJson(dynamic response) {
    Trip trip = Trip.fromJson(response);

    trips.insert(0, trip);
    notifyListeners();
  }

  Future<void> addTripsToFirebase(String userId) async {
    await tripApi.addTripToFirebase(userId, trips[0].toJson());
  }

  void fetchTrip(String userId) async {
    var response = await tripApi.fetchTripFromFirebase(userId);
    trips = response;
  }

  void addTrip(Trip trip) {
    trips.add(trip);
    notifyListeners();
  }

  List<Trip> getTrips() {
    return trips;
  }

  void sendNewPrompt(String value, String tripId) {
    newPrompt = value;
    notifyListeners();
  }
}
