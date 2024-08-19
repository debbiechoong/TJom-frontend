class Accommodation {
  final String name;
  final String address;
  final String price;
  final String rating;
  final double? latitude;
  final double? longitude;
  final String provider;
  final String startDate;
  final String endDate;

  Accommodation({
    required this.name,
    required this.address,
    required this.price,
    required this.rating,
    this.latitude,
    this.longitude,
    required this.provider,
    required this.startDate,
    required this.endDate,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      name: json['Name'] ?? 'Unknown', // Provide a default value if null
      address: json['Address'] ?? 'Unknown',
      price: json['Price'] ?? 'Unknown',
      rating: json['Rating'] ?? 'No Rating', // Assuming rating as 0 if null
      latitude:
          (json['Latitude'] != "None" && json['Latitude'] != "Not provided")
              ? double.tryParse(json['Latitude'].toString())
              : null,
      longitude:
          (json['Longitude'] != "None" && json['Longitude'] != "Not provided")
              ? double.tryParse(json['Longitude'].toString())
              : null,
      provider: json['Provider'] ?? 'Unknown',
      startDate: json['startDate'] ?? 'Unknown',
      endDate: json['endDate'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Address': address,
      'Price': price,
      'Rating': rating,
      'Latitude': latitude?.toString() ?? "None",
      'Longitude': longitude?.toString() ?? "None",
      'Provider': provider,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Accommodation copyWith({
    String? name,
    String? address,
    String? price,
    String? rating,
    double? latitude,
    double? longitude,
    String? provider,
    String? startDate,
    String? endDate,
  }) {
    return Accommodation(
      name: name ?? this.name,
      address: address ?? this.address,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      provider: provider ?? this.provider,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
