import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/itinerary.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class Itinerary extends StatefulWidget {
  const Itinerary({super.key});

  @override
  State<Itinerary> createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
  @override
  Widget build(BuildContext context) {
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
                // size: 24,
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
          // MediaQuery.removePadding(
          //   context: context,
          //   removeTop: true,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: itineraryDays.length,
          //     itemBuilder: (context, index) {
          //       final itineraryDay = itineraryDays[index];
          //       return ExpansionTile(
          //         title: Text(
          //           DateFormat('EEEE, MMM d').format(itineraryDay.date),
          //           style: Theme.of(context).textTheme.headline6,
          //         ),
          //         children: itineraryDay.items.map((item) {
          //           return ListTile(
          //             leading: Icon(item.icon,
          //                 color: Theme.of(context).primaryColor),
          //             title: Text(item.title),
          //             subtitle: Text('${item.time} • ${item.description}'),
          //           );
          //         }).toList(),
          //       );
          //     },
          //   ),
          // ),
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
