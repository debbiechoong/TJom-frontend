import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> fetchUserFromFirestore(String userId) async {
  try {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      await createUserInFirestore(userId);
    }
  } catch (e) {
    // Handle errors (e.g., connection issues)
    await createUserInFirestore(userId);
  }
}

Future<void> createUserInFirestore(String userId) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'user_id': userId,
    'created_at': FieldValue.serverTimestamp(),
    "dietary": "",
    "allergies": [],
    "interests": [],
  });
}

//update allergies
Future<void> updateUserAllergies(String userId, List<String> allergies) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'allergies': allergies,
  });
}

//update interests
Future<void> updateUserInterests(String userId, List<String> interests) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'interests': interests,
  });
}

//update dietary
Future<void> updateUserDietary(String userId, String dietary) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'dietary': dietary,
  });
}
