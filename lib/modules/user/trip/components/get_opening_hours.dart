// Function to get today's opening hours
import 'package:intl/intl.dart';

String getTodayOpeningHours(List<String> openingHours) {
  DateTime now = DateTime.now();
  String today = DateFormat('EEEE')
      .format(now); // Get current day in full format (e.g., "Monday")

  for (String hours in openingHours) {
    if (hours.startsWith(today)) {
      return hours.split(": ")[1];
    }
  }
  return "Not Available";
}
