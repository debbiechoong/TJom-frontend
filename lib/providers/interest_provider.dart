import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:http/http.dart' as http;

class InterestProvider extends ChangeNotifier {
  List<InterestDestination>? interests;

  final String _googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final String _jejuLocation = '33.489011,126.498302'; // Hardcode miao

  InterestProvider() {
    fetchTrendingInterests();
  }

  Future<void> fetchTrendingInterests() async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$_jejuLocation&radius=10000&type=tourist_attraction&key=$_googleApiKey',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> results = jsonResponse['results'];

        interests = results.map<InterestDestination>((place) {
          return InterestDestination(
            id: place['place_id'],
            name: place['name'],
            description: place['vicinity'] ?? '',
            imageUrl: (place['photos'] != null && place['photos'].isNotEmpty)
                ? [
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['photos'][0]['photo_reference']}&key=$_googleApiKey'
                  ]
                : [],
            address: place['vicinity'] ?? '',
            lat: place['geometry']['location']['lat'],
            long: place['geometry']['location']['lng'],
          );
        }).toList();

        print("Interests: $interests");

        notifyListeners();
      } else {
        print("Trending error: ${response.statusCode}");
        interests = [];
      }
    } catch (e) {
      print("Fetching error: $e");
      interests = [];
    }
  }

  List<InterestDestination> getInterests() {
    return interests ?? [];
  }
}
