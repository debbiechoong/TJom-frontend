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

//update User
Future<void> updateUserInFirestore(String userId,
    {String? dietary, List<String>? allergies, List<String>? interests}) async {
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
  await FirebaseFirestore.instance.collection('users').doc(userId).update(data);
}
