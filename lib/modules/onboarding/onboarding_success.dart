import 'package:flutter/material.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class OnboardingSuccess extends StatelessWidget {
  const OnboardingSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingProvider onboardingProvider =
        Provider.of<OnboardingProvider>(context);
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
            onboardingProvider.nextPage();
          },
          child: Text("Next",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )),
        ),
      ],
    );
  }
}
