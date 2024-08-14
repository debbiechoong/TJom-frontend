import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/loading.gif",
            width: 200,
          ),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Finding hotels...',
                textStyle: Theme.of(context).textTheme.headlineLarge,
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Checking flights...',
                textStyle: Theme.of(context).textTheme.headlineLarge,
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Creating itinerary...',
                textStyle: Theme.of(context).textTheme.headlineLarge,
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Preparing your trip...',
                textStyle: Theme.of(context).textTheme.headlineLarge,
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 4,
            pause: const Duration(milliseconds: 500),
          )
        ],
      ),
    );
  }
}
