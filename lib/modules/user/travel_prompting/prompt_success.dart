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
          "Yay! Here comes your first trip with Jejom!",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
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
          child: Text("Get Started",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )),
        ),
      ],
    );
  }
}
