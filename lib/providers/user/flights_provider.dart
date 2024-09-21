import 'package:flutter/material.dart';
import 'package:jejom/models/flight.dart';

class FlightsProvider extends ChangeNotifier {
  List<Flight> flights = [];

  void fetchFlights(String tripId) {
    flights = [
      Flight(
        id: 'FL123',
        departureTms: DateTime(2024, 9, 22, 14, 30),
        arrivalTms: DateTime(2024, 9, 22, 17, 45),
        origin: 'Seoul',
        destination: 'Jeju',
        price: 250.00,
        flightCarrier: 'Korean Air',
      ),
      Flight(
        id: 'FL456',
        departureTms: DateTime(2024, 9, 23, 9, 0),
        arrivalTms: DateTime(2024, 9, 23, 12, 30),
        origin: 'Singapore',
        destination: 'Tokyo',
        price: 500.00,
        flightCarrier: 'Singapore Airlines',
      ),
      Flight(
        id: 'FL789',
        departureTms: DateTime(2024, 9, 25, 16, 0),
        arrivalTms: DateTime(2024, 9, 25, 19, 15),
        origin: 'Hong Kong',
        destination: 'Sydney',
        price: 750.00,
        flightCarrier: 'Cathay Pacific',
      ),
    ];
    notifyListeners();
  }

  List<Flight> getFlights() {
    return flights;
  }
}
