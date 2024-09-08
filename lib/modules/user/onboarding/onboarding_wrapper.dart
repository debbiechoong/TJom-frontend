import 'package:flutter/material.dart';
import 'package:jejom/modules/user/onboarding/dietary_preference.dart';
import 'package:jejom/modules/user/onboarding/landing.dart';
import 'package:jejom/modules/user/onboarding/onboarding_success.dart';
import 'package:jejom/modules/user/onboarding/personal_interest.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: Center(
                  child: WidgetCircularAnimator(
                innerColor: Theme.of(context).colorScheme.primaryContainer,
                outerColor: Theme.of(context).colorScheme.secondary,
                size: 400,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ),
            PageView(
              controller: onboardingProvider.mainPageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Landing(),
                PersonalInterest(),
                DietaryPreferences(),
                OnboardingSuccess(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
