import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jejom/utils/constants/constants.dart';
import 'package:http/http.dart' as http;

class TripApi {
  checkInitInput(String prompt) async {
    var url = Uri.parse('http://${Constants.API_URL}/check_init_input');

    var body = {
      'query': prompt,
    };

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print('Check Response: $responseBody');
      return responseBody;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  generateTrip(String query, String userProps) async {
    var url = Uri.parse('http://${Constants.API_URL}/generate_trip');

    var body = {
      'query': query,
      "user_props": userProps,
      "mode": "test",
    };

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print('Trip Response: ${responseBody['data']}');
      return responseBody['data'];
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> addTripToFirebase(
      String userId, Map<String, dynamic> trip) async {
    // Add trip to Firebase
    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .add({"userId": userId, ...trip});
    } catch (e) {
      print('Error adding trip to Firebase: $e');
    }
  }
}
