import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            "Let's plan your next trip with AI Powered Jejom. Where would you like to go?",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 32),
        GlassContainer(
            padding: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                  ),
                  child: Image.network(
                      "https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcTzE4_RYUCn-k0sb_wiO3sRCIvnxOq3b0U8pCgiWeMz5qxYyDbRxFmy0wmv-wE6fLXuB6rC4B1-j7u27attTsFDkIsmCSLs6Bb_PUl5L1w",
                      width: 160),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Destination of the day!",
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        Text("Jeju Island",
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                ),
              ],
            )),
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
                  "            > >",
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
