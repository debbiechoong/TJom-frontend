import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final String id;
  final DateTime departureTms;
  final DateTime arrivalTms;
  final String origin;
  final String destination;
  final double price;
  final String flightCarrier;

  Flight({
    required this.id,
    required this.departureTms,
    required this.arrivalTms,
    required this.origin,
    required this.destination,
    required this.price,
    required this.flightCarrier,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'],
      departureTms: json['departureTms'] != null
          ? (json['departureTms'] as Timestamp).toDate()
          : DateTime.now(), // Fallback if null
      arrivalTms: json['arrivalTms'] != null
          ? (json['arrivalTms'] as Timestamp).toDate()
          : DateTime.now(), // Fallback if null
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      price: (json['price'] as num).toDouble(),
      flightCarrier: json['flightCarrier'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departureTms': Timestamp.fromDate(departureTms),
      'arrivalTms': Timestamp.fromDate(arrivalTms),
      'origin': origin,
      'destination': destination,
      'price': price,
      'flightCarrier': flightCarrier,
    };
  }
}
