import 'package:jejom/models/flight.dart';

class Trip {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<Flight> flights;
  final List<ItineraryDestination> destinations;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.flights,
    required this.destinations,
  });
}

class ItineraryDestination {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final List<String> imageUrl;
  final String address;
  final double lat;
  final double long;

  ItineraryDestination({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.imageUrl,
    required this.address,
    required this.lat,
    required this.long,
  });
}

class Accommodation {
  final String id;
  final String name;
  final String address;
  final List<String> imageUrl;
  final String price;
  final String rating;
  final double lat;
  final double long;
  final double provider;

  Accommodation({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.lat,
    required this.long,
    required this.provider,
  });
}
