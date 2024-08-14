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
      departureTms: (json['start_tms'] as Timestamp).toDate(),
      arrivalTms: (json['end_tms'] as Timestamp).toDate(),
      origin: json['origin'] as String,
      destination: json['destinations'] as String,
      price: (json['price'] as num).toDouble(),
      flightCarrier: json['flight_carrier'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_tms': Timestamp.fromDate(departureTms),
      'end_tms': Timestamp.fromDate(arrivalTms),
      'origin': origin,
      'destination': destination,
      'price': price,
      'flight_carrier': flightCarrier,
    };
  }

  Flight copyWith({
    String? id,
    DateTime? startTms,
    DateTime? endTms,
    String? origin,
    String? destination,
    double? price,
    String? flightCarrier,
  }) {
    return Flight(
      id: id ?? this.id,
      departureTms: startTms ?? this.departureTms,
      arrivalTms: endTms ?? this.arrivalTms,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      price: price ?? this.price,
      flightCarrier: flightCarrier ?? this.flightCarrier,
    );
  }

  @override
  String toString() {
    return 'Flight{id: $id, startTms: $departureTms, endTms: $arrivalTms, origin: $origin, destinations: $destination, price: $price, flightCarrier: $flightCarrier}';
  }
}
