import 'package:flutter/material.dart';
import 'package:jejom/api/user_api.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/modules/restaurant/home/restaurant_home.dart';
import 'package:jejom/modules/user/home/home.dart';
import 'package:jejom/modules/user/onboarding/onboarding_wrapper.dart';
import 'package:jejom/providers/restaurant/restaurant_provider.dart';
import 'package:jejom/providers/restaurant/script_generator_provider.dart';
import 'package:jejom/providers/restaurant/script_restaurant_provider.dart';
import 'package:jejom/providers/restaurant/restaurant_onboarding_provider.dart';
import 'package:jejom/providers/user/accomodation_provider.dart';
import 'package:jejom/providers/user/interest_provider.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:jejom/providers/user/script_game_provider.dart';
import 'package:jejom/providers/user/travel_provider.dart';
import 'package:jejom/providers/user/trip_provider.dart';
import 'package:jejom/providers/user/user_provider.dart';
import 'package:jejom/utils/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fetch or create userId and store it in SharedPreferences
  final String userId = await _fetchOrCreateUserId();
  final bool isOnBoarded = await isUserOnBoarded();
  final bool isRestaurant = await isRestaurantCheck();

  // Apply system UI settings
  AppTheme.configureSystemUI();

  runApp(MyApp(
      userId: userId, isOnBoarded: isOnBoarded, isRestaurant: isRestaurant));
}

class MyApp extends StatelessWidget {
  final String userId;
  final bool isOnBoarded;
  final bool isRestaurant;

  const MyApp(
      {super.key,
      required this.userId,
      required this.isOnBoarded,
      required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OnboardingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TripProvider()..fetchTrip(""),
        ),
        ChangeNotifierProvider(
            create: (context) =>
                ScriptGameProvider()..fetchGames(Language.english)),
        ChangeNotifierProvider(create: (context) => InterestProvider(userId)),
        ChangeNotifierProvider(create: (context) => AccommodationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TravelProvider()),
        ChangeNotifierProvider(create: (context) => RestaurantProvider()),
        ChangeNotifierProvider(
          create: (context) => RestaurantScriptGeneratorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScriptRestaurantProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantOnboardingProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Jejom App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: isOnBoarded
            ? isRestaurant
                ? const RestaurantHome()
                : const Home()
            : const OnBoarding(),
      ),
    );
  }
}

Future<String> _fetchOrCreateUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  print("userId: $userId");

  if (userId == null) {
    userId = const Uuid().v4(); // Generate a new userId
    await prefs.setString('userId', userId);
    await createUserInFirestore(userId);
  }

  return userId;
}

Future<bool> isUserOnBoarded() async {
  final prefs = await SharedPreferences.getInstance();

  print("isUserOnBoarded: ${prefs.getBool('onboarded')}");
  return prefs.getBool('onboarded') ?? false;
}

Future<bool> isRestaurantCheck() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isRestaurant') ?? false;
}
