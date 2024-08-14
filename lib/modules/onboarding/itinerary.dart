import 'package:flutter/material.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/trip_provider.dart';
import 'package:m3_carousel/m3_carousel.dart';
import 'package:provider/provider.dart';

class Itinerary extends StatefulWidget {
  const Itinerary({super.key});

  @override
  State<Itinerary> createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          IconButton(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              onPressed: () {
                onboardingProvider.previousPage();
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          const SizedBox(height: 16),
          Text(
            "Itinerary",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tripProvider.trips.length,
              itemBuilder: (context, index) {
                final trip = tripProvider.trips[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Day ${index + 1}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        Text(trip.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_rounded)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: M3Carousel(
                        visible: 3, // number of visible slabs
                        borderRadius: 20,
                        slideAnimationDuration: 500, // milliseconds
                        titleFadeAnimationDuration: 300, // milliseconds
                        childClick: (int index) {
                          print("Clicked $index");
                        },
                        children: [
                          {"image": "assets/images/image1.jpg", "title": "Lol"},
                          {
                            "image": "assets/images/image2.jpg",
                            "title": "Bruh"
                          },
                          {
                            "image": "assets/images/image1.jpg",
                            "title": "Lol2"
                          },
                          {
                            "image": "assets/images/image2.jpg",
                            "title": "Bruh"
                          },
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
