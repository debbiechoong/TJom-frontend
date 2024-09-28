import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/flight_info.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/utils/constants/curve.dart';

class FlightsSection extends StatefulWidget {
  const FlightsSection({super.key, required this.trip});

  final Trip trip;

  @override
  State<FlightsSection> createState() => _FlightsSectionState();
}

class _FlightsSectionState extends State<FlightsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool isDeparture = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;

    if (trip.flight.departureFlight?.airlineLogo == null) {
      return const Text("No flights available for this trip.");
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              IconButton(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Flights",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "KRW ${trip.flight.priceTotal}",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                "There would be ${(trip.flight.departureFlight?.flights?.length ?? 0) + (trip.flight.returnFlight?.flights?.length ?? 0)} flights for this trip",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                onTap: (value) {
                  bool temp = value == 0 ? true : false;
                  setState(() {
                    isDeparture = temp;
                  });
                },
                tabs: const <Widget>[
                  Tab(
                    text: "Departure",
                    icon: Icon(Icons.flight_takeoff),
                  ),
                  Tab(
                    text: "Return",
                    icon: Icon(Icons.flight_land),
                  ),
                ],
              ),
              trip.flight.departureFlight?.airlineLogo == null ||
                      trip.flight.departureFlight?.flights == null
                  ? const Text("No flights available for this trip.")
                  : const SizedBox(),
              isDeparture
                  ? AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            trip.flight.departureFlight?.flights?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _buildFlightCard(
                              trip.flight.departureFlight!.flights![index],
                              index);
                        },
                      ),
                    )
                  : AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            trip.flight.returnFlight?.flights?.length ?? 0,
                        itemBuilder: (context, index) {
                          return _buildFlightCard(
                              trip.flight.returnFlight!.flights![index], index);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightCard(Flights flight, int index) {
    return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
            curve: EMPHASIZED_DECELERATE,
            child: FadeInAnimation(
              curve: EMPHASIZED_DECELERATE,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 33, 33),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            flight.travelClass ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          flight.departureAirport?.id ?? "",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.flight,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          flight.arrivalAirport?.id ?? "",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          transform: Matrix4.translationValues(-28.0, 0, 0.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          width: 24,
                          height: 24,
                        ),
                        const Expanded(child: Divider()),
                        Container(
                          transform: Matrix4.translationValues(28.0, 0, 0.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.network(
                          flight.airlineLogo ?? '',
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                  Icons.error), // Handle image loading error
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "${flight.airline ?? 'Unknown Airline'} - ${flight.flightNumber ?? 'N/A'}", // Handle null airline and flightNumber
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                      ],
                    ),
                    Stepper(
                      physics: const NeverScrollableScrollPhysics(),
                      controlsBuilder:
                          (BuildContext context, ControlsDetails controls) {
                        return const SizedBox.shrink(); // Hide default controls
                      },
                      steps: <Step>[
                        Step(
                          title: Text(
                            '${DateFormat('kk:mm a').format(DateTime.tryParse(flight.departureAirport?.time ?? '') ?? DateTime.now())} · ${flight.departureAirport?.name ?? 'Unknown Airport'}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          content: Row(
                            children: [
                              Text(
                                'Travel Time: ${flight.duration ?? 'Unknown'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.6),
                                    ),
                              ),
                              const SizedBox(width: 8),
                              if (flight.overnight ?? false)
                                Text(
                                  'Overnight',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                            ],
                          ),
                        ),
                        Step(
                          title: Text(
                            '${DateFormat('kk:mm a').format(DateTime.tryParse(flight.arrivalAirport?.time ?? '') ?? DateTime.now())} · ${flight.arrivalAirport?.name ?? 'Unknown Airport'}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          content: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
