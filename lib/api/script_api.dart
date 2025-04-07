
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/models/script_game.dart';
import 'package:jejom/models/script_restaurant.dart';
import 'package:jejom/utils/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Fetch all scripts along with their nested collections (eng and kor)
Future<List<ScriptGame>> fetchAllScriptFromFirestore(Language lang) async {
  try {
    final scriptDocs =
        await FirebaseFirestore.instance.collection('script').get();
    List<ScriptGame> scripts = [];

    print("scriptDocs: ${scriptDocs.docs.length}");

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

Future<List<ScriptGame>> fetchResScriptFromFirestore(
    Language lang, String resId) async {
  try {
    final scriptDocs =
        await FirebaseFirestore.instance.collection('script').get();
    List<ScriptGame> scripts = [];

    if (scriptDocs.docs.isNotEmpty) {
      for (var scriptDoc in scriptDocs.docs) {
        String restaurant = scriptDoc.data()['restaurant'] ?? '';

        // Check if the restaurants array contains the given resId
        if (restaurant == resId) {
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
    }
    return scripts;
  } catch (e) {
    debugPrint("Error running fetchResScriptFromFirestore: $e");
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
    printWrapped("${scriptDoc.data()}");
    if (scriptDoc.exists) {
      return ScriptRestaurant.fromJson(scriptDoc.data()!);
    }
    return null;
  } catch (e) {
    debugPrint("Error running fetchResFromFirestore : $e");
    return null;
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Future<void> generateScript(String restaurantId, int charactersNum,
    String cafeName, String cafeEnv) async {
  var url = Uri.parse('http://${Constants.API_URL}/generate_script');

  var body = {
    'characters_num': charactersNum.toString(),
    'cafe_name': cafeName,
    'cafe_environment': cafeEnv,
    'mode': ''
  };

  print("Sent Script Generator");
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: body,
  );

  print("Responsed");

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);

    var engScript = responseBody['eng_script'];
    var korScript = responseBody['kor_script'];

    print('Eng Script: $engScript');
    print('Kor Script: $korScript');

    await uploadScriptToFirestore(restaurantId, korScript, engScript);

    print('Scripts and ScriptGame saved successfully to Firestore.');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> uploadScriptToFirestore(String restaurantId,
    Map<String, dynamic> korScript, Map<String, dynamic> engScript) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = 'script';
    DocumentReference docRef = firestore.collection(collectionPath).doc();
    await docRef.set({
      'restaurant': restaurantId,
    });

    await docRef
        .collection('kor')
        .doc()
        .set({...korScript, 'restaurant': restaurantId});
    await docRef
        .collection('eng')
        .doc()
        .set({...engScript, 'restaurant': restaurantId});

    print('Script uploaded successfully to Firestore: $collectionPath');
  } catch (e) {
    print('Failed to upload script to Firestore: $e');
  }
}
