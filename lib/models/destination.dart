class Destination {
  final String name;
  final String address;
  final String description;
  final double lat;
  final double long;
  final String price;
  final String startDate;
  final String endDate;

  Destination({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.address,
    required this.lat,
    required this.long,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['Name'] ?? 'Unknown',
      address: json['Address'] ?? 'Unknown',
      description: json['Description'] ?? 'No description available',
      lat: double.tryParse(json['Latitude']?.toString() ?? '') ?? 0.0,
      long: double.tryParse(json['Longitude']?.toString() ?? '') ?? 0.0,
      price: json['Price'] ?? 'Unknown',
      startDate: json['startDate'] ?? 'Unknown',
      endDate: json['endDate'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Address': address,
      'Description': description,
      'Latitude': lat.toString(),
      'Longitude': long.toString(),
      'Price': price.toString(),
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Destination copyWith({
    String? name,
    String? address,
    String? description,
    double? lat,
    double? long,
    String? price,
    String? startDate,
    String? endDate,
  }) {
    return Destination(
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      price: price ?? this.price,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
