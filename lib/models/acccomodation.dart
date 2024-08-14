
class Accommodation {
  final String id;
  final String name;
  final String address;
  final DateTime stayDate;
  final List<String> imageUrl;
  final int price;
  final double rating;
  final double lat;
  final double long;
  final String provider;

  Accommodation({
    required this.id,
    required this.name,
    required this.address,
    required this.stayDate,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.lat,
    required this.long,
    required this.provider,
  });
}
