import 'package:flutter/material.dart';
import 'package:jejom/modules/home/home.dart';
import 'package:jejom/providers/accomodation_provider.dart';
import 'package:jejom/providers/interest_provider.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/script_game_provider.dart';
import 'package:jejom/providers/trip_provider.dart';
import 'package:jejom/utils/theme.dart';
import 'package:jejom/utils/typography.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "DM Sans", "DM Sans");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnboardingProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        ChangeNotifierProvider(create: (context) => InterestProvider()),
        ChangeNotifierProvider(create: (context) => ScriptGameProvider()),
        ChangeNotifierProvider(create: (context) => AccommodationProvider()),
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
