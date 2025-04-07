import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jejom/models/trip.dart';
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
      // "mode": "test",
    };

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Connection': 'keep-alive', // Keep connection alive
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

  Future<List<Trip>> fetchTripFromFirebase(String userId) async {
    try {
      var trip = await FirebaseFirestore.instance
          .collection('trips')
          // .where('userId', isEqualTo: userId)
          .get();
      print('Trip fetched from Firebase: ${trip.docs}');
      final trips = trip.docs.map((doc) => Trip.fromJson(doc.data())).toList();

      print("Fetched Trips are: $trips");
      return trips;
    } catch (e) {
      print('Error fetching trip from Firebase: $e');
      return [];
    }
  }

  // Future<void> updateTripInFirebase(
  //     String userId, Map<String, dynamic> trip) async {
  //   try {
  //     var tripDoc = await fetchTripFromFirebase(userId);
  //     await tripDoc.reference.update(trip);
  //   } catch (e) {
  //     print('Error updating trip in Firebase: $e');
  //   }
  // }

  Future<void> deleteTripFromFirebase(String tripId) async {
    try {
      await FirebaseFirestore.instance.collection('trips').doc(tripId).delete();
    } catch (e) {
      print('Error deleting trip from Firebase: $e');
    }
  }
}
