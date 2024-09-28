import 'package:jejom/models/acccomodation.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/models/flight.dart';

class Trip {
  // final String id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  // final List<Flight> flights;
  final List<Destination> destinations;
  final List<Accommodation> accommodations;
  final List<Flight> flights;
  final String thumbnail;

  Trip({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.destinations,
    required this.accommodations,
    required this.flights,
    required this.thumbnail,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      title: json['title'] ?? 'Untitled Trip',
      description: json['description'] ?? 'No description available',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      destinations: json['destinations'] != null
          ? List<Destination>.from(
              json['destinations'].map((x) => Destination.fromJson(x)))
          : [],
      accommodations: json['accomodations'] != null
          ? List<Accommodation>.from(
              json['accomodations'].map((x) => Accommodation.fromJson(x)))
          : [],
      flights: json['flights'] != null
          ? List<Flight>.from(json['flights'].map((x) => Flight.fromJson(x)))
          : [],
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'destinations': destinations.map((x) => x.toJson()).toList(),
      'accomodations': accommodations.map((x) => x.toJson()).toList(),
      'flights': flights.map((x) => x.toJson()).toList(),
      'thumbnail': thumbnail,
    };
  }

  Trip copyWith({
    String? title,
    String? description,
    String? startDate,
    String? endDate,
    List<Destination>? destinations,
    List<Accommodation>? accommodations,
    List<Flight>? flights,
    String? thumbnail,
  }) {
    return Trip(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destinations: destinations ?? this.destinations,
      accommodations: accommodations ?? this.accommodations,
      flights: flights ?? this.flights,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
