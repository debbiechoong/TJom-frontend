import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/trip/trip_details.dart';
import 'package:jejom/providers/trip_provider.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:provider/provider.dart';

class TripList extends StatefulWidget {
  const TripList({super.key});

  @override
  State<TripList> createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Trip List',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnimationLimiter(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tripProvider.trips.length,
                    itemBuilder: (context, index) {
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
                              child: tripCard(tripProvider.trips[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tripCard(Trip trip) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${trip.startDate} until ${trip.endDate}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.8),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        trip.description,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TripDetails(
                              trip: trip,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          width: 64,
                          height: 64,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Transform.rotate(
                                angle: 1.5708 / 2,
                                child: const Icon(Icons.arrow_upward_rounded),
                              ))),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
            child: ListView.builder(
                itemCount: trip.destinations.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 16.0,
                        right:
                            index == trip.destinations.length - 1 ? 16.0 : 0),
                    child: Chip(
                        label: Text(trip.destinations[index].name,
                            style: Theme.of(context).textTheme.labelMedium)),
                  );
                }),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Widget currentTrip() {
  //   return Container(
  //     padding: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.primaryContainer,
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Next Trip!',
  //               style: Theme.of(context).textTheme.titleMedium,
  //             ),
  //           ],
  //         ),
  //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //           Text(
  //             'Destination: ${tripProvider.trips[0].destination}',
  //             style: Theme.of(context).textTheme.bodyMedium,
  //           ),
  //         ])
  //       ],
  //     ),
  //   );
  // }
}
