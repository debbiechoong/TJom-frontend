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
          startDate: DateTime.now().add(const Duration(days: 5)),
          endDate: DateTime.now().add(const Duration(days: 5, hours: 1)),
          price: 0,
          imageUrl: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg/800px-Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg",
            // "https://assets.editorial.aetnd.com/uploads/2011/06/gettyimages-142198198.jpg?width=1920&height=960&crop=1920%3A960%2Csmart&quality=75&auto=webp",
            // "https://cdn.mos.cms.futurecdn.net/z3rNHS9Y6PV6vbhH8w83Yn-650-80.jpg.webp",
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
          startDate: DateTime.now().add(const Duration(days: 5, hours: 2)),
          endDate: DateTime.now().add(const Duration(days: 5, hours: 3)),
          price: 0,
          imageUrl: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Louvre_Museum_Wikimedia_Commons.jpg/800px-Louvre_Museum_Wikimedia_Commons.jpg",
          ],
          address: "Rue de Rivoli, 75001 Paris, France",
          lat: 48.8606,
          long: 2.3376,
        ),
        Destination(
          id: "3",
          name: "Notre-Dame Cathedral",
          description: "Famous Gothic cathedral in Paris",
          startDate: DateTime.now().add(const Duration(days: 6)),
          endDate: DateTime.now().add(const Duration(days: 6, hours: 1)),
          price: 0,
          imageUrl: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Notre-Dame_de_Paris%2C_4_October_2017.jpg/1920px-Notre-Dame_de_Paris%2C_4_October_2017.jpg",
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

  String newPrompt = "";


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

  void sendNewPrompt(String value, String tripId) {
    newPrompt = value;
    notifyListeners();
  }
}
