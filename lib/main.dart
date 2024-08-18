import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejom/api/user_api.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/modules/home/home.dart';
import 'package:jejom/providers/accomodation_provider.dart';
import 'package:jejom/providers/interest_provider.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/script_game_provider.dart';
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

  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final String userId;
  const MyApp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "DM Sans", "DM Sans");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnboardingProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        ChangeNotifierProvider(create: (context) => InterestProvider(userId)),
        ChangeNotifierProvider(
            create: (context) =>
                ScriptGameProvider()..fetchGames(Language.english)),
        ChangeNotifierProvider(create: (context) => AccommodationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider(userId)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        theme: theme.dark(),
        home: const Home(),
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
  } else {
    await fetchUserFromFirestore(userId);
  }

  return userId;
}
