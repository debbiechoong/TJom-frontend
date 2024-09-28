import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/modules/user/trip/components/get_opening_hours.dart';
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
        children: [
          StoryView(
              storyItems: widget.storyItems,
              controller: widget.controller, // pass controller here too
              // onStoryShow: (s) {notifyServer(s);},
              onComplete: () {
                Navigator.pop(context);
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              } // To disable vertical swipe gestures, ignore this parameter.
              // Preferrably for inline story view.
              ),
          Positioned(
            bottom: 40,
            left: 16,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.dest.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.dest.description,
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
                      Text(widget.dest.rating,
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 8),
                      StarRating(
                        rating: double.tryParse(widget.dest.rating) ?? 0,
                        allowHalfRating: true,
                      ),
                      const SizedBox(width: 8),
                      Text("(${widget.dest.numRating})",
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
                        "Opening Hours: ${getTodayOpeningHours(widget.dest.openingHours)}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
