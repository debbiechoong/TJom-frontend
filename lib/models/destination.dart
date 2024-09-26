class Destination {
  final String address;
  final String description;
  final String googlePlaceID;
  final double latitude;
  final double longitude;
  final String name;
  final int numRating;
  final List<String> openingHours;
  final List<String> photos;
  final String price;
  final String rating;
  final String endDate;
  final String startDate;

  Destination({
    required this.address,
    required this.description,
    required this.googlePlaceID,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.numRating,
    required this.openingHours,
    required this.photos,
    required this.price,
    required this.rating,
    required this.endDate,
    required this.startDate,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      address: json['Address'] ?? 'Unknown',
      description: json['Description'] ?? 'No description available',
      googlePlaceID: json['GooglePlaceID'] ?? 'Unknown',
      latitude: double.tryParse(json['Latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['Longitude']?.toString() ?? '') ?? 0.0,
      name: json['Name'] ?? 'Unknown',
      numRating: json['NumRating'] ?? 0,
      openingHours: json['OpeningHours'] != null
          ? List<String>.from(json['OpeningHours'].map((x) => x))
          : [],
      photos: (json['Photos'] as List<dynamic>)
          .map((photo) => photo['photo_reference'] as String)
          .toList(),
      price: json['Price'] ?? 'Unknown',
      rating: json['Rating'] ?? 'Unknown',
      endDate: json['EndDate'] ?? 'Unknown',
      startDate: json['StartDate'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Address': address,
      'Description': description,
      'GooglePlaceID': googlePlaceID,
      'Latitude': latitude,
      'Longitude': longitude,
      'Name': name,
      'NumRating': numRating,
      'OpeningHours': openingHours,
      'Photos': photos,
      'Price': price,
      'Rating': rating,
      'EndDate': endDate,
      'StartDate': startDate,
    };
  }

  Destination copyWith({
    String? address,
    String? description,
    String? googlePlaceID,
    double? latitude,
    double? longitude,
    String? name,
    int? numRating,
    List<String>? openingHours,
    List<String>? photos,
    String? price,
    String? rating,
    String? endDate,
    String? startDate,
  }) {
    return Destination(
      address: address ?? this.address,
      description: description ?? this.description,
      googlePlaceID: googlePlaceID ?? this.googlePlaceID,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      numRating: numRating ?? this.numRating,
      openingHours: openingHours ?? this.openingHours,
      photos: photos ?? this.photos,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
    );
  }
}
