import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/user/trip/components/build_carousel.dart';
import 'package:jejom/modules/user/trip/components/get_opening_hours.dart';

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
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
