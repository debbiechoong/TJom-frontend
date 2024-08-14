import 'package:flutter/material.dart';
import 'package:jejom/models/acccomodation.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/models/flight.dart';
import 'package:jejom/models/trip.dart';

class TripProvider extends ChangeNotifier {
  List<Trip> trips = [
    Trip(
      id: "1",
      title: "Trip to Paris",
      description: "A trip to the city of love",
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 5)),
      flights: [
        Flight(
          id: "1",
          departureTms: DateTime.now(),
          arrivalTms: DateTime.now().add(const Duration(hours: 12)),
          origin: "Singapore",
          destination: "Paris",
          price: 500,
          flightCarrier: 'DEF Airlines',
        ),
      ],
      destinations: [
        Destination(
          id: "1",
          name: "Eiffel Tower",
          description: "Iconic landmark in Paris",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 5)),
          price: 0,
          imageUrl: [
            "https://example.com/eiffel_tower_1.jpg",
            "https://example.com/eiffel_tower_2.jpg",
            "https://example.com/eiffel_tower_3.jpg",
          ],
          address:
              "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France",
          lat: 48.8584,
          long: 2.2945,
        ),
        Destination(
          id: "2",
          name: "Louvre Museum",
          description: "World's largest art museum and historic monument",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 5)),
          price: 0,
          imageUrl: [
            "https://example.com/louvre_museum_1.jpg",
            "https://example.com/louvre_museum_2.jpg",
            "https://example.com/louvre_museum_3.jpg",
          ],
          address: "Rue de Rivoli, 75001 Paris, France",
          lat: 48.8606,
          long: 2.3376,
        ),
        Destination(
          id: "3",
          name: "Notre-Dame Cathedral",
          description: "Famous Gothic cathedral in Paris",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 5)),
          price: 0,
          imageUrl: [
            "https://example.com/notre_dame_cathedral_1.jpg",
            "https://example.com/notre_dame_cathedral_2.jpg",
            "https://example.com/notre_dame_cathedral_3.jpg",
          ],
          address:
              "6 Parvis Notre-Dame - Pl. Jean-Paul II, 75004 Paris, France",
          lat: 48.8529,
          long: 2.3499,
        ),
      ],
      accommodations: [
        Accommodation(
          id: "1",
          name: "Hotel ABC",
          address: "123 Main Street, Paris, France",
          stayDate: DateTime.now(),
          imageUrl: [
            "https://example.com/hotel_1.jpg",
            "https://example.com/hotel_2.jpg",
            "https://example.com/hotel_3.jpg",
          ],
          price: 200,
          rating: 4.5,
          lat: 48.8566,
          long: 2.3522,
          provider: "XYZ Accommodations",
        ),
        Accommodation(
          id: "2",
          name: "Hotel XYZ",
          address: "456 Broadway, Paris, France",
          stayDate: DateTime.now(),
          imageUrl: [
            "https://example.com/hotel_4.jpg",
            "https://example.com/hotel_5.jpg",
            "https://example.com/hotel_6.jpg",
          ],
          price: 150,
          rating: 4.2,
          lat: 48.8566,
          long: 2.3522,
          provider: "ABC Accommodations",
        ),
      ],
    ),
    Trip(
      id: "2",
      title: "Trip to Tokyo",
      description: "A trip to the city of lights",
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 5)),
      flights: [],
      destinations: [],
      accommodations: [],
    ),
    Trip(
      id: "3",
      title: "Trip to New York",
      description: "A trip to the city that never sleeps",
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 5)),
      flights: [],
      destinations: [],
      accommodations: [],
    ),
  ];

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

  List<Trip> getTrips() {
    return trips;
  }
}
