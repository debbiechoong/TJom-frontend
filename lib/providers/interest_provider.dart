import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jejom/models/interest_destination.dart';

class InterestProvider extends ChangeNotifier {
  List<InterestDestination>? interests;

  InterestProvider() {
    fetchInterests();
  }

  void fetchInterests() {
    try {
      interests = jsonDecode(response)
          .map<InterestDestination>(
              (location) => InterestDestination.fromJson(location))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error parsing interests: $e");
      interests = [];
    }
  }

  List<InterestDestination> getInterests() {
    return interests ?? [];
  }
}

String response = '''
    [
      {
        "id": "1",
        "name": "Jeju Loveland",
        "description": "A unique sculpture park focused on eroticism, located near Jeju Airport.",
        "imageUrl": [
          "https://example.com/images/jeju_loveland_1.jpg",
          "https://example.com/images/jeju_loveland_2.jpg"
        ],
        "address": "2894-72, 1100-ro, Jeju-si, Jeju-do, South Korea",
        "lat": 33.4712,
        "long": 126.4925
      },
      {
        "id": "2",
        "name": "Yongduam Rock (Dragon Head Rock)",
        "description": "A famous rock formation resembling a dragon's head, created by strong winds and waves over thousands of years.",
        "imageUrl": [
          "https://example.com/images/yongduam_rock_1.jpg",
          "https://example.com/images/yongduam_rock_2.jpg"
        ],
        "address": "Yongdam 2(i)-dong, Jeju-si, Jeju-do, South Korea",
        "lat": 33.5171,
        "long": 126.4896
      },
      {
        "id": "3",
        "name": "Jeju National Museum",
        "description": "A museum showcasing the rich history and culture of Jeju Island.",
        "imageUrl": [
          "https://example.com/images/jeju_national_museum_1.jpg",
          "https://example.com/images/jeju_national_museum_2.jpg"
        ],
        "address": "17 Iljudong-ro, Jeju-si, Jeju-do, South Korea",
        "lat": 33.5103,
        "long": 126.5214
      },
      {
        "id": "4",
        "name": "Dongmun Traditional Market",
        "description": "A bustling market offering local foods, products, and souvenirs.",
        "imageUrl": [
          "https://example.com/images/dongmun_market_1.jpg",
          "https://example.com/images/dongmun_market_2.jpg"
        ],
        "address": "1329-6 Ildo 1(il)-dong, Jeju-si, Jeju-do, South Korea",
        "lat": 33.5125,
        "long": 126.5267
      },
      {
        "id": "5",
        "name": "Halla Arboretum",
        "description": "A beautiful arboretum featuring a wide variety of native Jeju plants and trees.",
        "imageUrl": [
          "https://example.com/images/halla_arboretum_1.jpg",
          "https://example.com/images/halla_arboretum_2.jpg"
        ],
        "address": "1000 Yeon-dong, Jeju-si, Jeju-do, South Korea",
        "lat": 33.4866,
        "long": 126.4982
      }
    ]
    ''';
