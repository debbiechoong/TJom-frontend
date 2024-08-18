import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:http/http.dart' as http;

class InterestProvider extends ChangeNotifier {
  List<InterestDestination>? interests;
  final String userId;

  final String _googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final List<Map<String, String>> _locations = [
    {'name': 'Jeju', 'lat': '33.489011', 'long': '126.498302'},
    {'name': 'Seoul', 'lat': '37.5665', 'long': '126.9780'},
    {'name': 'Busan', 'lat': '35.1796', 'long': '129.0756'}
  ];

  InterestProvider(this.userId) {
    fetchUserInterests();
  }

  Future<void> fetchUserInterests() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final interestsCollection =
            userDoc.reference.collection('interestDestinations');
        final querySnapshot = await interestsCollection.get();

        if (querySnapshot.docs.isNotEmpty) {
          interests = querySnapshot.docs
              .map((doc) => InterestDestination.fromJson(doc.data()))
              .toList();
        } else {
          await fetchTrendingInterests();
          await saveInterestsToFirebase();
        }
      } else {
        await _createUserInFirestore();
        await fetchTrendingInterests();
        await saveInterestsToFirebase();
      }
    } catch (e) {
      debugPrint('Error fetching user interests: $e');
    }

    notifyListeners();
  }

  Future<void> fetchTrendingInterests() async {
    List<InterestDestination> allInterests = [];

    for (final location in _locations) {
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location['lat']},${location['long']}&radius=10000&type=tourist_attraction&key=$_googleApiKey',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final List<dynamic> results = jsonResponse['results'];

          final locationInterests = results.map<InterestDestination>((place) {
            return InterestDestination(
              id: place['place_id'],
              name: place['name'],
              description: place['types'] != null && place['types'].isNotEmpty
                  ? place['types'].join(', ')
                  : 'Tourist Attraction',
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
          allInterests.addAll(locationInterests);
        } else {
          debugPrint(
              "Trending error for ${location['name']}: ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("Fetching error for ${location['name']}: $e");
      }
    }

    interests = allInterests.isNotEmpty ? allInterests : [];
    if (interests!.isNotEmpty) {
      await recommendBestDestinations();
    }

    notifyListeners();
  }

  Future<void> recommendBestDestinations() async {
    if (interests == null || interests!.isEmpty) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        debugPrint("User does not exist in Firestore.");
        return;
      }

      List<String> userInterests =
          List<String>.from(userDoc.data()?['interests'] ?? []);

      String interestsString = userInterests.isNotEmpty
          ? userInterests.join(', ')
          : 'no specific interests';

      String userPrompt = '''
      Based on the user's interests in $interestsString, please recommend the top 10 destinations from the following list.
      Provide a brief justification for each recommendation.
      Here are the trending places in Jeju, Seoul, and Busan: 
      ${interests!.map((interest) => "Name: ${interest.name}\nDescription: ${interest.description}.").join("\n")}
      
      Your response format should be as follows:
      1. Destination Name 1 > Reason 1
      2. Destination Name 2 > Reason 2
      3. Destination Name 3 > Reason 3
      4. Destination Name 4 > Reason 4
      5. Destination Name 5 > Reason 5
      6. Destination Name 6 > Reason 6
    ''';

      final url = Uri.parse('https://api.upstage.ai/v1/solar/chat/completions');
      String apiKey = dotenv.env['UPSTAGE_API_KEY'] ?? '';
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'model': 'solar-1-mini-chat',
        'messages': [
          {'role': 'user', 'content': userPrompt},
        ],
        'stream': false,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = utf8.decode(response.bodyBytes);
        final responseBody = json.decode(responseData);

        if (responseBody is Map<String, dynamic> &&
            responseBody.containsKey('choices')) {
          final llmMessage = responseBody['choices'][0]['message']['content'];

          List<String> recommendedNames = extractRecommendedNames(llmMessage);
          interests = interests!.map((interest) {
            if (recommendedNames.contains(interest.name)) {
              final llmReason =
                  extractReasonForDestination(llmMessage, interest.name);
              return interest.copyWith(llmDescription: llmReason);
            }
            return interest;
          }).toList();

          notifyListeners();
        } else {
          debugPrint('Error: Unexpected LLM response structure.');
        }
      } else {
        debugPrint('LLM error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('LLM Fetching error: $e');
    }
  }

  Future<void> saveInterestsToFirebase() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final interestsCollection = userDoc.collection('interestDestinations');

    final batch = FirebaseFirestore.instance.batch();

    for (final interest in interests!) {
      final docRef = interestsCollection.doc(interest.id);
      batch.set(docRef, interest.toJson());
    }

    await batch.commit();
  }

  Future<void> _createUserInFirestore() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.set({'userId': userId});
  }

  String extractReasonForDestination(
      String llmMessage, String destinationName) {
    final lines = llmMessage.split('\n');
    for (final line in lines) {
      final match = RegExp(r'^\d+\.\s*(.*?)\s*>\s*(.*)').firstMatch(line);
      if (match != null && match.group(1)?.trim() == destinationName) {
        debugPrint(match.group(2)?.trim());
        return match.group(2)?.trim() ?? '';
      }
    }
    return '';
  }

  List<String> extractRecommendedNames(String llmMessage) {
    final recommendedNames = <String>[];
    final lines = llmMessage.split('\n');

    for (final line in lines) {
      final match = RegExp(r'^\d+\.\s*(.*?)\s*>\s*(.*)').firstMatch(line);
      if (match != null) {
        final name = match.group(1)?.trim();
        if (name != null && name.isNotEmpty) {
          recommendedNames.add(name);
        }
      }
    }
    return recommendedNames;
  }

  List<InterestDestination> getInterests() {
    return interests ?? [];
  }
}
