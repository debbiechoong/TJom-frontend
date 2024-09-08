import 'package:flutter/material.dart';
import 'package:jejom/modules/user/travel_prompting/itinerary.dart';
import 'package:jejom/modules/user/onboarding/onboarding_success.dart';
import 'package:jejom/modules/user/travel_prompting/travel_details.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class TravelWrapper extends StatefulWidget {
  const TravelWrapper({super.key});

  @override
  State<TravelWrapper> createState() => _TravelWrapperState();
}

class _TravelWrapperState extends State<TravelWrapper> {

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
                TravelDetails(),
                Itinerary(),
                OnboardingSuccess(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
