import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/flight.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/travel_provider.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:provider/provider.dart';

class Flights extends StatefulWidget {
  const Flights({super.key});

  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  @override
  Widget build(BuildContext context) {
    final travelProvider = Provider.of<TravelProvider>(context);

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          IconButton(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              onPressed: () {
                travelProvider.previousPage();
              },
              icon: const Icon(
                Icons.arrow_back,
                // size: 24,
              )),
          const SizedBox(height: 16),
          Text(
            "Flights",
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
                              flight: flight,
                              isSelected: travelProvider.selectedFlights
                                  .any((element) => element.id == flight.id)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
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
                  travelProvider.nextPage();
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

  Widget flightCard({required Flight flight, required bool isSelected}) {
    final travelProvider = Provider.of<TravelProvider>(context);

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
                onTap: () {
                  travelProvider.toggleSelectedFlight(flight);
                },
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
