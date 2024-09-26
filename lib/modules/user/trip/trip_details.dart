import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/models/flight.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jejom/utils/m3_carousel.dart';

class TripDetails extends StatefulWidget {
  final Trip trip;
  const TripDetails({super.key, required this.trip});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  List<List<Destination>> destinations = [[]];
  final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

// Function to get today's opening hours
  String getTodayOpeningHours(List<String> openingHours) {
    DateTime now = DateTime.now();
    String today = DateFormat('EEEE')
        .format(now); // Get current day in full format (e.g., "Monday")

    for (String hours in openingHours) {
      if (hours.startsWith(today)) {
        return hours.split(": ")[1]; // Split and return only the time part
      }
    }
    return "Closed"; // Default value if today's hours are not found
  }

  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.title,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text("${trip.startDate} until ${trip.endDate}",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  _buildDestinationsSection(trip),
                  const SizedBox(height: 16),
                  Text(
                    "Accommodations",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildAccommodationsSection(trip),
                  const SizedBox(height: 16),
                  _buildFlightsSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPhotoUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googleApiKey';
  }

  // Method to build the entire Flights section
  Widget _buildFlightsSection() {
    final Trip trip = widget.trip;

    if (trip.flights.isEmpty) {
      return const Text("No flights available for this trip.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        Text(
          "Flights",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          "There would be ${trip.flights.length} flights for this trip",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        // List of flight cards
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trip.flights.length,
          itemBuilder: (context, index) {
            return _buildFlightCard(trip.flights[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildFlightCard(Flight flight, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flight number and carrier name
        Text(
          "Flight ${index + 1} - ${flight.flightCarrier}",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),

        // Flight details
        Text(
          "Origin: ${flight.origin}",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        Text(
          "Destination: ${flight.destination}",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        Text(
          "Departure: ${flight.departureTms}",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        Text(
          "Arrival: ${flight.arrivalTms}",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        Text(
          "Price: \$${flight.price}",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),

        // Divider between flight cards
        const Divider(),
      ],
    );
  }

  Widget _buildAccommodationsSection(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: trip.accommodations.map((accommodation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(accommodation.photos),
            const SizedBox(height: 16),
            Text(
              accommodation.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              accommodation.description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8)),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(accommodation.rating,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(width: 8),
                StarRating(
                  rating: double.tryParse(accommodation.rating) ?? 0,
                  allowHalfRating: true,
                ),
                const SizedBox(width: 8),
                Text("(${accommodation.numRating})",
                    style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  "Date: ${accommodation.startDate} - ${accommodation.endDate} ",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.timer_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  "Opening Hours: ${getTodayOpeningHours(accommodation.openingHours)}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildImageCarousel(List<String> photos) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: M3Carousel(
        visible: 3,
        slideAnimationDuration: 300, // milliseconds
        titleFadeAnimationDuration: 200, // milliseconds
        children: [
          ...photos.map((url) {
            return {"image": _getPhotoUrl(url), "title": ""};
          }),
        ],
      ),
    );
  }

  Widget _buildDestinationsSection(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: trip.destinations.map((destination) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(destination.photos),
            const SizedBox(height: 16),
            Text(
              destination.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              destination.description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8)),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(destination.rating,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(width: 8),
                StarRating(
                  rating: double.tryParse(destination.rating) ?? 0,
                  allowHalfRating: true,
                ),
                const SizedBox(width: 8),
                Text("(${destination.numRating})",
                    style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.timer_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  "Opening Hours: ${getTodayOpeningHours(destination.openingHours)}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        );
      }).toList(),
    );
  }

  Future showAnimatedDialog(BuildContext context,
      {IconData? icon,
      required String title,
      required String desc,
      required String buttonText,
      required Function() onPressed,
      required String prompt}) async {
    final colors = Theme.of(context).colorScheme;
    // final tripProvider = Provider.of<TripProvider>(context);

    List<Widget> dialogWidgets = [
      Icon(
        icon,
        color: colors.primary,
        size: 32,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          desc,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Material(
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter your prompt here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (value) => setState(() {
              prompt = value;
            }),
          ),
        ),
      ),
    ];
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, child) {
          return AnimatedOpacity(
            opacity: a1.value,
            duration: const Duration(milliseconds: 200),
            child: Center(
              child: Container(
                height: 312,
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  height: a1.value * 312,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: EMPHASIZED_DECELERATE,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                ...dialogWidgets.asMap().entries.map((e) {
                                  int index = e.key;
                                  Widget widget = e.value;
                                  return AnimatedOpacity(
                                    duration: Duration(
                                        milliseconds: 500 + index * 1000),
                                    curve: EMPHASIZED_DECELERATE,
                                    opacity: a1.value,
                                    child: widget,
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          right: 24,
                          width: MediaQuery.of(context).size.width * 0.8 - 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: colors.onPrimary,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              FilledButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  visualDensity:
                                      VisualDensity.adaptivePlatformDensity,
                                ),
                                onPressed: () {
                                  onPressed();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  buttonText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: colors.onPrimary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }
}
