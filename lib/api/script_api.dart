import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/models/script_game.dart';
import 'package:jejom/models/script_restaurants.dart';

// Fetch all scripts along with their nested collections (eng and kor)
Future<List<ScriptGame>> fetchAllScriptFromFirestore(Language lang) async {
  try {
    final scriptDocs =
        await FirebaseFirestore.instance.collection('script').get();
    List<ScriptGame> scripts = [];

    if (scriptDocs.docs.isNotEmpty) {
      for (var scriptDoc in scriptDocs.docs) {
        // print(scriptDoc.data());
        final nestedCollection = lang == Language.english ? 'eng' : 'kor';
        final nestedDocs =
            await scriptDoc.reference.collection(nestedCollection).get();

        if (nestedDocs.docs.isNotEmpty) {
          Map<String, dynamic> fullData = {
            ...scriptDoc.data(),
            ...nestedDocs.docs[0].data(),
          };
          scripts.add(ScriptGame.fromJson(fullData));
        }
      }
    }
    return scripts;
  } catch (e) {
    debugPrint("Error running fetchAllScriptFromFirestore : $e");
    return [];
  }
}

String cleanJsonString(String jsonString) {
  // Replace problematic control characters
  return jsonString.replaceAll('\n', '\\n').replaceAll('\t', '\\t');
}

// Fetch restaurant details based on its ID
Future<ScriptRestaurant?> fetchResFromFirestore(String restaurantId) async {
  try {
    final scriptDoc = await FirebaseFirestore.instance
        .collection('script_restaurant')
        .doc(restaurantId)
        .get();
    if (scriptDoc.exists) {
      return ScriptRestaurant.fromJson(scriptDoc.data()!);
    }
    return null;
  } catch (e) {
    debugPrint("Error running fetchResFromFirestore : $e");
    return null;
  }
}
