import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/flight.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/glass_container.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Flight> flightsDummy = [
    Flight(
      id: '1',
      departureTms: DateTime.now(),
      arrivalTms: DateTime.now().add(Duration(hours: 3)),
      origin: 'Kuala Lumpur',
      destination: 'Jeju',
      price: 500,
      flightCarrier: 'ABC Airlines',
    ),
    Flight(
      id: '2',
      departureTms: DateTime.now().add(Duration(days: 1)),
      arrivalTms: DateTime.now().add(Duration(days: 1, hours: 3)),
      origin: 'Kuala Lumpur',
      destination: 'Jeju',
      price: 400,
      flightCarrier: 'XYZ Airlines',
    ),
    Flight(
      id: '3',
      departureTms: DateTime.now().add(Duration(days: 2)),
      arrivalTms: DateTime.now().add(Duration(days: 2, hours: 3)),
      origin: 'Kuala Lumpur',
      destination: 'Jeju',
      price: 600,
      flightCarrier: 'DEF Airlines',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      // size: 24,
                    )),
                const SizedBox(height: 16),
                Text(
                  "See what others are exploring",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kuala Lumpur",
                        style: Theme.of(context).textTheme.bodyLarge),
                    Transform.rotate(
                      angle: 1.5708,
                      child: const Icon(Icons.flight),
                    ),
                    Text("Jeju", style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
                const SizedBox(height: 32),
                AnimationLimiter(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: flightsDummy.length,
                      itemBuilder: (context, index) {
                        final flight = flightsDummy[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            curve: EMPHASIZED_DECELERATE,
                            child: FadeInAnimation(
                              curve: EMPHASIZED_DECELERATE,
                              child: GlassContainer(
                                padding: 0,
                                marginBottom: 16,
                                width: double.infinity,
                                child: flightCard(
                                    flight: flight, isSelected: false),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget flightCard({required Flight flight, required bool isSelected}) {
    // final onboardingProvider = Provider.of<OnboardingProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormat('kk:mm a').format(flight.departureTms.toLocal())} - ${DateFormat('kk:mm a').format(flight.arrivalTms.toLocal())}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${flight.arrivalTms.toLocal().difference(flight.departureTms.toLocal()).inHours}h  ${flight.flightCarrier}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.8),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${flight.price}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? null
                          : Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              width: 2,
                            ),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isSelected
                          ? const Icon(Icons.check)
                          : Transform.rotate(
                              angle: 1.5708 / 2,
                              child: const Icon(Icons.arrow_upward_rounded),
                            ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
