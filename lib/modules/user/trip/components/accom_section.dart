import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/user/trip/components/build_carousel.dart';
import 'package:jejom/modules/user/trip/components/get_opening_hours.dart';

class AccomSection extends StatefulWidget {
  const AccomSection({super.key, required this.trip, required this.focusDate});
  final Trip trip;
  final DateTime focusDate;
  
  @override
  State<AccomSection> createState() => _AccomSectionState();
}

class _AccomSectionState extends State<AccomSection> {
  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          "Accommodations",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      const SizedBox(height: 16),
      ...trip.accommodations.map((accommodation) {
        if (accommodation.startDate !=
            DateFormat('yyyy-MM-dd').format(widget.focusDate)) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildCarousel(photos: accommodation.photos),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              ),
            ),
          ],
        );
      }),
    ]);
  }
}
