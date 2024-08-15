import 'package:jejom/models/acccomodation.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/models/flight.dart';

class Trip {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<Flight> flights;
  final List<Destination> destinations;
  final List<Accommodation> accommodations;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.flights,
    required this.destinations,
    required this.accommodations,
  });
}
