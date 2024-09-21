import 'package:cloud_firestore/cloud_firestore.dart';

class FlightApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchFlightsFromFirebase(
      String tripId) async {
    final flightCollection =
        _db.collection('trips').doc(tripId).collection('flights');
    final querySnapshot = await flightCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addFlightToFirebase(
      String tripId, Map<String, dynamic> flightData) async {
    final flightCollection =
        _db.collection('trips').doc(tripId).collection('flights');
    await flightCollection.add(flightData);
  }
}
