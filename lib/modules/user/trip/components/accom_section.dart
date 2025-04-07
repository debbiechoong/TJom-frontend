import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/user/trip/components/build_carousel.dart';
import 'package:jejom/modules/user/trip/components/get_opening_hours.dart';
import 'package:jejom/utils/theme/app_theme.dart';
import 'package:jejom/utils/widgets/glass_container.dart';
import 'package:jejom/utils/widgets/section_header.dart';

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
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
        child: SectionHeader(
          title: "Accommodations",
          icon: Icons.hotel_rounded,
        ),
      ),
      const SizedBox(height: AppTheme.paddingMedium),
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
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingMedium),
              child: GlassContainer(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accommodation.name,
                      style: AppTheme.displaySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Text(
                      accommodation.description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textDark.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    Wrap(
                        spacing: AppTheme.paddingSmall,
                        runSpacing: AppTheme.paddingSmall,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.paddingSmall,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.travelPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadiusSmall),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  accommodation.rating,
                                  style: AppTheme.labelMedium.copyWith(
                                    color: AppTheme.travelPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                StarRating(
                                  rating:
                                      double.tryParse(accommodation.rating) ??
                                          0,
                                  allowHalfRating: true,
                                  starCount: 5,
                                  size: 16,
                                  color: AppTheme.travelPrimary,
                                  borderColor: AppTheme.travelPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(${accommodation.numRating})",
                                  style: AppTheme.labelSmall.copyWith(
                                    color: AppTheme.textDark.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.paddingSmall,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadiusSmall),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: AppTheme.textDark.withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${accommodation.startDate} - ${accommodation.endDate}",
                                  style: AppTheme.labelMedium.copyWith(
                                    color: AppTheme.textDark.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.paddingSmall,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadiusSmall),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_rounded,
                                  color: AppTheme.textDark.withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  getTodayOpeningHours(
                                      accommodation.openingHours),
                                  style: AppTheme.labelMedium.copyWith(
                                    color: AppTheme.textDark.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.paddingLarge),
          ],
        );
      }),
    ]);
  }
}
