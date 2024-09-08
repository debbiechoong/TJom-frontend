import 'package:flutter/material.dart';
import 'package:jejom/modules/user/home/home.dart';

class OnboardingSuccess extends StatelessWidget {
  const OnboardingSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 120),
        Text(
          "Success!",
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "Yay! Let's start your first trip with Jejom!",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primaryContainer),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: Text("Go to Home",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )),
            ),
            // const SizedBox(width: 16),
            // OutlinedButton(
            //   style: ButtonStyle(
            //     visualDensity: VisualDensity.adaptivePlatformDensity,
            //     padding: MaterialStateProperty.all(
            //       const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const TravelWrapper(),
            //       ),
            //     );
            //   },
            //   child: Text("Plan A Trip",
            //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            //             color: Theme.of(context).colorScheme.onBackground,
            //           )),
            // ),
          ],
        )
      ],
    );
  }
}
