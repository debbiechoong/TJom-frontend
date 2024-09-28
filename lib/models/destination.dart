class Destination {
  final String address;
  final String description;
  final String destinationWebsiteUrl;
  final String googleMapsUrl;
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
  final bool isMurderMysteryCafe;
  final String visitingTime;
  final String resId;

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
    required this.isMurderMysteryCafe,
    required this.visitingTime,
    required this.resId,
    required this.destinationWebsiteUrl,
    required this.googleMapsUrl,
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
      photos: json['Photos'] != null
          ? List<String>.from(json['Photos'].map((x) => (x)))
          : [],
      price: json['Price'] ?? 'Unknown',
      rating: json['Rating'] ?? 'Unknown',
      endDate: json['endDate'] ?? 'Unknown',
      startDate: json['startDate'] ?? 'Unknown',
      isMurderMysteryCafe: json['isMurderMysteryCafe'] ?? false,
      visitingTime: json['visitingTime'] ?? '',
      resId: json['id'] ?? '',
      destinationWebsiteUrl: json['DestinationWebsiteURL'] ?? '',
      googleMapsUrl: json['GoogleMapsURL'] ?? '',
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
      'endDate': endDate,
      'startDate': startDate,
      'isMurderMysteryCafe': isMurderMysteryCafe,
      'visitingTime': visitingTime,
      'id': resId,
      'DestinationWebsiteURL': destinationWebsiteUrl,
      'GoogleMapsURL': googleMapsUrl,
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
    bool? isMurderMysteryCafe,
    String? visitingTime,
    String? resId,
    String? destinationWebsiteUrl,
    String? googleMapsUrl,
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
      isMurderMysteryCafe: isMurderMysteryCafe ?? this.isMurderMysteryCafe,
      visitingTime: visitingTime ?? this.visitingTime,
      resId: resId ?? this.resId,
      destinationWebsiteUrl:
          destinationWebsiteUrl ?? this.destinationWebsiteUrl,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
    );
  }
}
