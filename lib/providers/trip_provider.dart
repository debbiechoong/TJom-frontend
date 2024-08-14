import 'package:flutter/material.dart';
import 'package:jejom/models/itinerary.dart';


class TripProvider extends ChangeNotifier {
  List<Trip> trips = [];
  
  void addTrip(Trip trip) {
    trips.add(trip);
    notifyListeners();
  }

  void removeTrip(Trip trip) {
    trips.removeWhere((element) => element.id == trip.id);
    notifyListeners();
  }

  void updateTrip(Trip trip) {
    final index = trips.indexWhere((element) => element.id == trip.id);
    trips[index] = trip;
    notifyListeners();
  }

  Trip getTripById(String id) {
    return trips.firstWhere((element) => element.id == id);
  }

  Trip getFirstTrip() {
    return trips.first;
  }
} 


