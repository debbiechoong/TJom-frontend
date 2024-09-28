import 'package:flutter_dotenv/flutter_dotenv.dart';

String getPhotoUrl(String photoReference) {
  final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googleApiKey';
}
