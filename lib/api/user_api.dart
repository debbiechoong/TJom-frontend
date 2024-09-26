import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/models/user.dart';

Future<User?> fetchUserFromFirestore(String userId) async {
  try {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) {}

    print('User data: ${userDoc.data()}');

    return User.fromJson(userDoc.data() as Map<String, dynamic>);
  } catch (e) {
    print('Error fetching user: $e');
    return null;
  }
}

Future<void> createUserInFirestore(String userId) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'user_id': userId,
    'created_at': FieldValue.serverTimestamp(),
  });
}

//update User
Future<void> updateUserInFirestore(String userId,
    {String? dietary,
    List<String>? allergies,
    List<String>? interests,
    String? residingCity,
    String? name,
    String? desc}) async {
  try {
    final Map<String, dynamic> data = {};

    if (dietary != null) {
      data['dietary'] = dietary;
    }
    if (allergies != null) {
      data['allergies'] = allergies;
    }
    if (interests != null) {
      data['interests'] = interests;
    }
    if (residingCity != null) {
      data['residingCity'] = residingCity;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (desc != null) {
      data['desc'] = desc;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(data);
  } catch (e) {
    // Handle the error appropriately
    print("Failed to update user in Firestore: $e");
    rethrow; // Optionally rethrow the error to handle it further up the chain
  }
}

Future<void> addOrUpdateInterestDestination(
    String userId, InterestDestination destination) async {
  try {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('interestDestinations')
        .doc(destination.id);

    await docRef.set(destination.toJson(), SetOptions(merge: true));
  } catch (e) {
    print('Error adding or updating destination: $e');
  }
}

Future<List<InterestDestination>> fetchInterestDestinations(
    String userId) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('interestDestinations')
        .get();

    return querySnapshot.docs
        .map((doc) => InterestDestination.fromJson(doc.data()))
        .toList();
  } catch (e) {
    print('Error fetching destinations: $e');
    return [];
  }
}

Future<void> deleteInterestDestination(
    String userId, String destinationId) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('interestDestinations')
        .doc(destinationId)
        .delete();
  } catch (e) {
    print('Error deleting destination: $e');
  }
}
