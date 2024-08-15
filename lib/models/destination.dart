class Destination {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final List<String> imageUrl;
  final String address;
  final double lat;
  final double long;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.imageUrl,
    required this.address,
    required this.lat,
    required this.long,
  });
}
