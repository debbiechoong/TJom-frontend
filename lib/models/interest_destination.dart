class InterestDestination {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrl;
  final String address;
  final double lat;
  final double long;
  String? llmDescription;

  InterestDestination({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.lat,
    required this.long,
    this.llmDescription,
  });

  // Factory constructor to create an InterestDestination from JSON
  factory InterestDestination.fromJson(Map<String, dynamic> json) {
    return InterestDestination(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: List<String>.from(json['imageUrl']),
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      llmDescription: json['llmDescription'],
    );
  }

  // Method to convert an InterestDestination to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'address': address,
      'lat': lat,
      'long': long,
      'llmDescription': llmDescription,
    };
  }

  // Copy with method to create a modified copy of InterestDestination
  InterestDestination copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? imageUrl,
    String? address,
    double? lat,
    double? long,
    String? llmDescription,
  }) {
    return InterestDestination(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      llmDescription: llmDescription ?? this.llmDescription,
    );
  }
}
