import 'package:flutter/material.dart';
import 'package:jejom/api/user_api.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/modules/home/home.dart';
import 'package:jejom/modules/onboarding/onboarding_wrapper.dart';
import 'package:jejom/providers/accomodation_provider.dart';
import 'package:jejom/providers/interest_provider.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/script_game_provider.dart';
import 'package:jejom/providers/travel_provider.dart';
import 'package:jejom/providers/trip_provider.dart';
import 'package:jejom/providers/user_provider.dart';
import 'package:jejom/utils/theme.dart';
import 'package:jejom/utils/typography.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  // Ensures that the widget binding is initialized before Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fetch or create userId and store it in SharedPreferences
  final String userId = await _fetchOrCreateUserId();
  final bool isOnBoarded = await isUserOnBoarded();

  runApp(MyApp(userId: userId, isOnBoarded: isOnBoarded));
}

class MyApp extends StatelessWidget {
  final String userId;
  final bool isOnBoarded;

  const MyApp({super.key, required this.userId, required this.isOnBoarded});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "DM Sans", "DM Sans");

    // print("isOnBoarded: $isOnBoarded");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnboardingProvider()),
        ChangeNotifierProvider(
            create: (context) => TripProvider()..fetchTrip("5ca0ff7a-6548-469b-8efe-e1e161911ea6"
)),
        ChangeNotifierProvider(create: (context) => InterestProvider(userId)),
        ChangeNotifierProvider(
            create: (context) =>
                ScriptGameProvider()..fetchGames(Language.english)),
        ChangeNotifierProvider(create: (context) => AccommodationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider(userId)),
        ChangeNotifierProvider(create: (context) => TravelProvider()),
      ],
      child: MaterialApp(
        title: 'Jejom',
        debugShowCheckedModeBanner: false,
        // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        theme: theme.dark(),
        home: isOnBoarded ? const Home() : const OnBoarding(),
      ),
    );
  }
}

Future<String> _fetchOrCreateUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  if (userId == null) {
    userId = const Uuid().v4(); // Generate a new userId
    await prefs.setString('userId', userId);
    await createUserInFirestore(userId);
  }

  return userId;
}

Future<bool> isUserOnBoarded() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarded') ?? false;
}
