import 'package:cloud_firestore/cloud_firestore.dart';

class Flight {
  final int id;
  final DateTime startTms;
  final DateTime endTms;
  final String origin;
  final List<String> destinations; // Modified field
  final double price;
  final String flightCarrier;

  Flight({
    required this.id,
    required this.startTms,
    required this.endTms,
    required this.origin,
    required this.destinations,
    required this.price,
    required this.flightCarrier,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] as int,
      startTms: (json['start_tms'] as Timestamp).toDate(),
      endTms: (json['end_tms'] as Timestamp).toDate(),
      origin: json['origin'] as String,
      destinations:
          List<String>.from(json['destinations'] as List), // Modified line
      price: (json['price'] as num).toDouble(),
      flightCarrier: json['flight_carrier'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_tms': Timestamp.fromDate(startTms),
      'end_tms': Timestamp.fromDate(endTms),
      'origin': origin,
      'destinations': destinations,
      'price': price,
      'flight_carrier': flightCarrier,
    };
  }

  Flight copyWith({
    int? id,
    DateTime? startTms,
    DateTime? endTms,
    String? origin,
    List<String>? destinations,
    double? price,
    String? flightCarrier,
  }) {
    return Flight(
      id: id ?? this.id,
      startTms: startTms ?? this.startTms,
      endTms: endTms ?? this.endTms,
      origin: origin ?? this.origin,
      destinations: destinations ?? this.destinations,
      price: price ?? this.price,
      flightCarrier: flightCarrier ?? this.flightCarrier,
    );
  }

  @override
  String toString() {
    return 'Flight{id: $id, startTms: $startTms, endTms: $endTms, origin: $origin, destinations: $destinations, price: $price, flightCarrier: $flightCarrier}';
  }
}
