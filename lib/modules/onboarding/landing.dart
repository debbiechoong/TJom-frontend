import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 80),
        Text(
          "Looking for",
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text("New Trip", style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Text(
            "Type in your destinations, budget, duration, interest and number of traveller to get started!",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 32),
        const GlassContainer(child: Text("Hello")),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(49, 217, 217, 217),
                  Color.fromARGB(49, 115, 115, 115),
                ],
              ),
              borderRadius: BorderRadius.circular(64.0),
              // border: Border.all(
              //   width: 2,
              //   color: Colors.white.withOpacity(0.3),
              // ),
            ),
            child: SwipeButton(
                width: double.infinity,
                height: 80,
                thumb: Center(
                  child: Icon(
                    Icons.travel_explore,
                    size: 32,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                activeThumbColor:
                    Theme.of(context).colorScheme.primaryContainer,
                activeTrackColor: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0),
                child: Text(
                  "            Explore",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                onSwipe: () => onboardingProvider.nextPage()),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
