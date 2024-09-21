import 'package:flutter/material.dart';
import 'package:jejom/models/acccomodation.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/models/flight.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TripDetails extends StatefulWidget {
  final Trip trip;
  const TripDetails({super.key, required this.trip});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  List<List<Destination>> destinations = [[]];
  final String _googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;
    for (int i = 0; i < trip.destinations.length; i++) {
      if (i == 0) {
        destinations[destinations.length - 1].add(trip.destinations[i]);
      } else {
        if (trip.destinations[i].startDate !=
            trip.destinations[i - 1].startDate) {
          destinations.add([]);
        }
        destinations[destinations.length - 1].add(trip.destinations[i]);
      }
    }

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
                  _buildDestinationsSection(),
                  const SizedBox(height: 16),
                  _buildAccommodationsSection(),
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

// Method to build individual flight cards
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

  Widget _buildAccommodationsSection() {
    final Trip trip = widget.trip;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Accommodations", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          "There would be ${trip.accommodations.length} accommodations recommended for this trip",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trip.accommodations.length,
            itemBuilder: (context, index) {
              final accommodation = trip.accommodations[index];
              return _buildAccommodationCard(accommodation);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAccommodationCard(Accommodation accommodation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<String?>(
          future: getPlacePhoto(accommodation.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Image.asset(
                'assets/images/image1.jpg',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              );
            }
            final photoUrl =
                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${snapshot.data}&key=$_googleApiKey';
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                photoUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          accommodation.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          accommodation.address,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        Text("Price: ${accommodation.price}",
            style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildDestinationsSection() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: destinations.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("Day ${index + 1}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 32),
              destinations[index].isNotEmpty
                  ? _buildDestinationCard(destinations, index)
                  : const SizedBox(),
              const Divider(),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Future<String?> getPlacePhoto(String placeName) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$placeName&inputtype=textquery&fields=photos&key=$_googleApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['candidates'] != null &&
          jsonResponse['candidates'].isNotEmpty &&
          jsonResponse['candidates'][0]['photos'] != null &&
          jsonResponse['candidates'][0]['photos'].isNotEmpty) {
        return jsonResponse['candidates'][0]['photos'][0]['photo_reference'];
      }
    }
    return null;
  }

  Widget _buildDestinationCard(
      List<List<Destination>> destinations, int index) {
    return Column(
      children: destinations[index]
          .map((destination) => Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: getPlacePhoto(destination.name),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return Image.asset(
                              'assets/images/image1.jpg',
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            );
                          }
                          final photoUrl =
                              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${snapshot.data}&key=$_googleApiKey';

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              photoUrl,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              destination.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.8)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                                "Entry Fee: ${destination.price == "None" ? "Free" : destination.price}",
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ))
          .toList(),
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
