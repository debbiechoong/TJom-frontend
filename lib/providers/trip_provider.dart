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
        // Accommodation(
        //   id: "1",
        //   name: "Hotel ABC",
        //   address: "123 Main Street, Paris, France",
        //   stayDate: DateTime.now(),
        //   imageUrl: [
        //     "https://example.com/hotel_1.jpg",
        //     "https://example.com/hotel_2.jpg",
        //     "https://example.com/hotel_3.jpg",
        //   ],
        //   price: 200,
        //   rating: 4.5,
        //   lat: 48.8566,
        //   long: 2.3522,
        //   provider: "XYZ Accommodations",
        // ),
        // Accommodation(
        //   id: "2",
        //   name: "Hotel XYZ",
        //   address: "456 Broadway, Paris, France",
        //   stayDate: DateTime.now(),
        //   imageUrl: [
        //     "https://example.com/hotel_4.jpg",
        //     "https://example.com/hotel_5.jpg",
        //     "https://example.com/hotel_6.jpg",
        //   ],
        //   price: 150,
        //   rating: 4.2,
        //   lat: 48.8566,
        //   long: 2.3522,
        //   provider: "ABC Accommodations",
        // ),
      ],
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

const response = [
  {
    "Name": "Seongsan Ilchulbong",
    "Description":
        "Seongsan Ilchulbong, also known as 'Sunrise Peak,' is a volcano on eastern Jeju Island, in Seongsan-ri, Seogwipo, Jeju Province, South Korea. It is 182 meters high and has a volcanic crater at the top. Considered one of South Korea's most beautiful tourist sites, it is famed for being the easternmost mountain on Jeju, and thus the best spot on the island to see the sunrise.",
    "Price": "KRW 2,000",
    "Address": "Seongsan-eup, Seogwipo-si, Jeju-do, South Korea",
    "Latitude": "33.461111",
    "Longitude": "126.940556"
  },
  {
    "Name": "Jeju Olle Trails",
    "Description":
        "The Jeju Olle Trails are a series of walking trails that loop around the outskirts of Jeju-do. The trails cover a distance of 425 km and are divided into 21 main routes and 5 sub-routes. The word olle (올레) in the Jeju dialect means 'a narrow street that leads to a wider road'. The trails offer a unique way to explore Jeju Island, with options for a month-long through-hike or exploring in bite-sized sections.",
    "Price": "Free",
    "Address": "Jeju Island, South Korea",
    "Latitude": "33.373056",
    "Longitude": "126.531944"
  },
  {
    "Name": "Cheonjeyeon Waterfall",
    "Description":
        "Cheonjeyeon Waterfall is a three-tier waterfall located on Jeju Island, South Korea. It is a popular tourist attraction and one of the three famous waterfalls of Jeju, alongside Cheonjiyeon Waterfall and Jeongbang Waterfall. The waterfall has three sections, with the first running from the floor of the mountain on the upper part of Jungmun-dong, which falls 22 meters. The water then falls again two more times to form the second and third sections, which then tributes to the sea. The first segment is usually a pond, but falls when it rains. The forest in which the fall is located is in a warm temperature zone so it is home to a variety of flora and fauna.",
    "Price": "None",
    "Address": "Jungmun-dong, Seogwipo, Jeju-do, South Korea",
    "Latitude": "33.254",
    "Longitude": "126.417"
  }
];
