class Accommodation {
  final String name;
  final String address;
  final String price;
  final String rating;
  final double? lat;
  final double? long;
  final String provider;

  Accommodation({
    required this.name,
    required this.address,
    required this.price,
    required this.rating,
    this.lat,
    this.long,
    required this.provider,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      name: json['Name'],
      address: json['Address'],
      price: json['Price'],
      rating: json['Rating'],
      lat: (json['Latitude'] != "None" && json['Latitude'] != "Not provided")
          ? double.tryParse(json['Latitude'])
          : null,
      long: (json['Longitude'] != "None" && json['Longitude'] != "Not provided")
          ? double.tryParse(json['Longitude'])
          : null,
      provider: json['Provider'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Address': address,
      'Price': price,
      'Rating': rating,
      'Latitude': lat?.toString() ?? "None",
      'Longitude': long?.toString() ?? "None",
      'Provider': provider,
    };
  }

  Accommodation copyWith({
    String? name,
    String? address,
    String? price,
    String? rating,
    double? lat,
    double? long,
    String? provider,
  }) {
    return Accommodation(
      name: name ?? this.name,
      address: address ?? this.address,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      provider: provider ?? this.provider,
    );
  }
}
