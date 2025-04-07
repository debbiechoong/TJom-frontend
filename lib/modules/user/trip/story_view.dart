import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/modules/user/trip/components/get_opening_hours.dart';
import 'package:jejom/utils/widgets/glass_container.dart';
import 'package:jejom/utils/theme/app_theme.dart';
import 'package:jejom/utils/widgets/app_back_button.dart';
import 'package:story_view/story_view.dart';

class StoryViewPage extends StatefulWidget {
  const StoryViewPage(
      {super.key,
      required this.storyItems,
      required this.controller,
      required this.dest});
  final List<StoryItem> storyItems;
  final StoryController controller;
  final Destination dest;

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main story view
          StoryView(
            storyItems: widget.storyItems,
            controller: widget.controller,
            onComplete: () => Navigator.pop(context),
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            },
          ),
          
          // Bottom info panel
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: GlassContainer(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dest.name,
                    style: AppTheme.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Text(
                    widget.dest.description,
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.travelPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.dest.rating,
                              style: AppTheme.labelMedium.copyWith(
                                color: AppTheme.travelPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            StarRating(
                              rating: double.tryParse(widget.dest.rating) ?? 0,
                              allowHalfRating: true,
                              starCount: 5,
                              size: 16,
                              color: AppTheme.travelPrimary,
                              borderColor: AppTheme.travelPrimary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "(${widget.dest.numRating})",
                              style: AppTheme.labelSmall.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              getTodayOpeningHours(widget.dest.openingHours),
                              style: AppTheme.labelMedium.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Close button
          Positioned(
            top: 40,
            right: 16,
            child: AppBackButton(
              onTap: () => Navigator.of(context).pop(),
              hasBackground: true,
              icon: Icons.close_rounded,
              iconColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
