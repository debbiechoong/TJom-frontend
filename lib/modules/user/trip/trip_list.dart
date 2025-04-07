import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/user/trip/trip_details.dart';
import 'package:jejom/providers/user/trip_provider.dart';
import 'package:jejom/utils/clean_text.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/widgets/glass_container.dart';
import 'package:jejom/utils/theme/app_theme.dart';
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0E6FF),
                  Color(0xFFD5E6F3),
                ],
              ),
            ),
          ),

          // Abstract design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'My Trips',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimationLimiter(
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppTheme.paddingMedium),
                                        child:
                                            tripCard(tripProvider.trips[index]),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tripCard(Trip trip) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: AppTheme.paddingMedium),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: Stack(
                children: [
                  Image.network(
                    trip.thumbnail,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.paddingMedium),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Text(
                        cleanText(trip.title),
                        style: AppTheme.displaySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.travelPrimary.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Text(
                    '${trip.startDate} until ${trip.endDate}',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.travelPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingSmall),
                Text(
                  cleanText(trip.description),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textDark.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate approximately how many items can fit in a row
                          // Assuming average chip width of 100 + spacing
                          final double chipWidth = 100 + AppTheme.paddingSmall;
                          final int itemsPerRow =
                              (constraints.maxWidth / chipWidth).floor();

                          // 2 rows maximum
                          final int maxItems = itemsPerRow * 2;

                          final destinations = trip.destinations;
                          final displayedDestinations = destinations.length >
                                  maxItems
                              ? destinations.sublist(
                                  0, maxItems - 1) // Leave space for "+X more"
                              : destinations;

                          final List<Widget> chips =
                              displayedDestinations.map((destination) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.paddingSmall,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(
                                    AppTheme.borderRadiusSmall),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                destination.name,
                                style: AppTheme.labelSmall.copyWith(
                                  color: AppTheme.textDark,
                                ),
                              ),
                            );
                          }).toList();

                          // Add "+X more" chip if needed
                          if (destinations.length > maxItems) {
                            final moreCount =
                                destinations.length - (maxItems - 1);
                            chips.add(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.paddingSmall,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.travelPrimary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.borderRadiusSmall),
                                  border: Border.all(
                                    color:
                                        AppTheme.travelPrimary.withOpacity(0.3),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  "+$moreCount more",
                                  style: AppTheme.labelSmall.copyWith(
                                    color: AppTheme.travelPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Wrap(
                            spacing: AppTheme.paddingSmall,
                            runSpacing: AppTheme.paddingSmall,
                            children: chips,
                          );
                        },
                      ),
                    ),
                    GestureDetector(
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.travelPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppTheme.travelPrimary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.travelPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
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
