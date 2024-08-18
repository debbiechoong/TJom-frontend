import 'package:flutter/material.dart';
import 'package:jejom/models/acccomodation.dart';

class AccommodationProvider extends ChangeNotifier {
  final List<Accommodation> accommodations = [];
  Accommodation? selectedAccommodation;

  AccommodationProvider() {
    fetchAccommodations();
  }

  void toggleSelectedAccommodation(Accommodation accommodation) {
    if (selectedAccommodation == accommodation) {
      selectedAccommodation = null;
    } else {
      selectedAccommodation = accommodation;
    }
    notifyListeners();
  }

  void fetchAccommodations() {
    for (var i = 0; i < response.length; i++) {
      accommodations.add(Accommodation.fromJson(response[i]));
    }
    notifyListeners();
  }

  void addAccommodation(Accommodation accommodation) {
    accommodations.add(accommodation);
    notifyListeners();
  }
}

const response = [
  {
    "Name": "Hotel RegentMarine The Blue",
    "Address": "20, Seobudu 2-gil, Jeju City, 63276 Jeju, South Korea",
    "Price": "KRW 55,000 - 110,000 per night",
    "Rating": "8.6 out of 10",
    "Latitude": "None",
    "Longitude": "None",
    "Provider": "Booking.com, HotelsCombined, Agoda, Momondo"
  },
  {
    "Name": "Ocean Suites Jeju Hotel",
    "Address": "74, Tapdonghaean-ro, Jeju City, 63165 Jeju, South Korea",
    "Price": "Around \$85 per night",
    "Rating": "4 out of 5",
    "Latitude": "33.5065",
    "Longitude": "126.4914",
    "Provider": "Ocean Suites Jeju Hotel"
  },
  {
    "Name": "Jeju Oriental Hotel & Casino",
    "Address": "47 Tapdong-ro, Jeju, Jeju Island, 63166, South Korea",
    "Price": "\$48 to \$62 per night",
    "Rating": "8.1",
    "Latitude": "None",
    "Longitude": "None",
    "Provider": "Jeju Oriental Hotel & Casino"
  },
  {
    "Name": "Ramada Plaza Jeju Ocean Front",
    "Address": "66, Tapdong-ro, Jeju City, 63165 Jeju, South Korea",
    "Price": "Starting at \$69 per night",
    "Rating": "8.1 out of 10",
    "Latitude": "33.247204",
    "Longitude": "126.412185",
    "Provider": "Wyndham Hotels"
  },
  {
    "Name": "Hotel Shinhwa World",
    "Address":
        "38, Sinhwayeoksa-ro 304beon-gil, Andeok-myeon, Andeok, 63522 Seogwipo, South Korea",
    "Price": "Not provided",
    "Rating": "4.5 out of 5",
    "Latitude": "Not provided",
    "Longitude": "Not provided",
    "Provider": "Shinhwa World Company"
  }
];
