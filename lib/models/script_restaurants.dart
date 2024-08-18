class ScriptRestaurant {
  final String address;
  final String description;
  final List<String> imageUrl;
  final double lat;
  final double long;
  final String name;
  final String phoneNum;

  ScriptRestaurant({
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.lat,
    required this.long,
    required this.name,
    required this.phoneNum,
  });

  factory ScriptRestaurant.fromJson(Map<String, dynamic> json) {
    return ScriptRestaurant(
      address: json['address'] as String,
      description: json['description'] as String,
      imageUrl: List<String>.from(json['image_url']),
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
      name: json['name'] as String,
      phoneNum: json['phone_num'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'description': description,
      'image_url': imageUrl,
      'lat': lat,
      'long': long,
      'name': name,
      'phone_num': phoneNum,
    };
  }

  ScriptRestaurant copyWith({
    String? address,
    String? description,
    List<String>? imageUrl,
    double? lat,
    double? long,
    String? name,
    String? phoneNum,
  }) {
    return ScriptRestaurant(
      address: address ?? this.address,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      name: name ?? this.name,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }
}
