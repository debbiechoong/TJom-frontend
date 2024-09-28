import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/user/script_game/script_game.dart';
import 'package:jejom/modules/user/trip/components/build_carousel.dart';
import 'package:jejom/modules/user/trip/components/get_opening_hours.dart';
import 'package:jejom/providers/user/script_game_provider.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:jejom/utils/text_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DestSection extends StatefulWidget {
  const DestSection({super.key, required this.trip, required this.focusDate});
  final Trip trip;
  final DateTime focusDate;

  @override
  State<DestSection> createState() => _DestSectionState();
}

class _DestSectionState extends State<DestSection> {
  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;
    final scriptGameProvider = Provider.of<ScriptGameProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: trip.destinations.map((destination) {
        if (destination.startDate !=
            DateFormat('yyyy-MM-dd').format(widget.focusDate)) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildCarousel(photos: destination.photos),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        destination.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      destination.destinationWebsiteUrl == ""
                          ? const SizedBox()
                          : IconButton(
                              onPressed: () async {
                                final Uri url = Uri.parse(
                                    destination.destinationWebsiteUrl);
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              icon: const Icon(Icons.language)),
                      const SizedBox(width: 8),
                      destination.googleMapsUrl == ""
                          ? const SizedBox()
                          : IconButton(
                              onPressed: () async {
                                final Uri url =
                                    Uri.parse(destination.googleMapsUrl);
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              icon: const Icon(Icons.directions)),
                    ],
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
                      const Spacer(),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.travel_explore_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Recommended Visiting Hours: ${destination.visitingTime.toTitleCase()}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  destination.isMurderMysteryCafe
                      ? GlassContainer(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Murder Mystery Restaurant",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "It offers murder mystery game!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                              // const Spacer(),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  final currentResId = destination.resId;
                                  // find the script related to the restaurant Id
                                  scriptGameProvider.selectGame(
                                      scriptGameProvider.games
                                          .where((element) =>
                                              element.restaurantId ==
                                              currentResId)
                                          .first);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ScriptGamePage(),
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
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: Transform.rotate(
                                          angle: 1.5708 / 2,
                                          child: const Icon(
                                              Icons.arrow_upward_rounded),
                                        ))),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 56),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
