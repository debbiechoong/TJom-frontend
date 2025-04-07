import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/user/script_game/script_game.dart';
import 'package:jejom/modules/user/trip/components/build_carousel.dart';
import 'package:jejom/modules/user/trip/components/get_opening_hours.dart';
import 'package:jejom/providers/user/script_game_provider.dart';
import 'package:jejom/utils/widgets/glass_container.dart';
import 'package:jejom/utils/text_formatter.dart';
import 'package:jejom/utils/theme/app_theme.dart';
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
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingMedium),
              child: GlassContainer(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          destination.name,
                          style: AppTheme.displaySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        destination.destinationWebsiteUrl == ""
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.borderRadiusSmall),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                        destination.destinationWebsiteUrl);
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: const Icon(
                                    Icons.language,
                                    color: AppTheme.travelPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                        const SizedBox(width: 8),
                        destination.googleMapsUrl == ""
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.borderRadiusSmall),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    final Uri url =
                                        Uri.parse(destination.googleMapsUrl);
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: const Icon(
                                    Icons.directions,
                                    color: AppTheme.travelPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Text(
                      destination.description,
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
                                destination.rating,
                                style: AppTheme.labelMedium.copyWith(
                                  color: AppTheme.travelPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              StarRating(
                                rating:
                                    double.tryParse(destination.rating) ?? 0,
                                allowHalfRating: true,
                                starCount: 5,
                                size: 16,
                                color: AppTheme.travelPrimary,
                                borderColor: AppTheme.travelPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "(${destination.numRating})",
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
                                Icons.timer_rounded,
                                color: AppTheme.textDark.withOpacity(0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                getTodayOpeningHours(destination.openingHours),
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
                                Icons.travel_explore_rounded,
                                color: AppTheme.textDark.withOpacity(0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Visit: ${destination.visitingTime.toTitleCase()}",
                                style: AppTheme.labelMedium.copyWith(
                                  color: AppTheme.textDark.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (destination.isMurderMysteryCafe) ...[
                      const SizedBox(height: AppTheme.paddingMedium),
                      GlassContainer(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusSmall),
                        backgroundColor:
                            AppTheme.travelPrimary.withOpacity(0.1),
                        padding: const EdgeInsets.all(AppTheme.paddingMedium),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Murder Mystery Restaurant",
                                    style: AppTheme.labelLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "It offers murder mystery game!",
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.textDark.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                final currentResId = destination.resId;
                                // find the script related to the restaurant Id
                                scriptGameProvider.selectGame(scriptGameProvider
                                    .games
                                    .where((element) =>
                                        element.restaurantId == currentResId)
                                    .first);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ScriptGamePage(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.travelPrimary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color:
                                        AppTheme.travelPrimary.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppTheme.travelPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.paddingLarge),
          ],
        );
      }).toList(),
    );
  }
}
