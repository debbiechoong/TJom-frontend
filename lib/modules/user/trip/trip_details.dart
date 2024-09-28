import 'dart:ui';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/modules/user/travel_prompting/prompt_success.dart';
import 'package:jejom/modules/user/trip/components/accom_section.dart';
import 'package:jejom/modules/user/trip/components/dest_section.dart';
import 'package:jejom/modules/user/trip/components/flights_section.dart';
import 'package:jejom/modules/user/trip/components/get_photo_url.dart';
import 'package:jejom/modules/user/trip/story_view.dart';
import 'package:jejom/utils/clean_text.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:story_view/story_view.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key, required this.trip, this.isEditing = false});
  final Trip trip;
  final bool isEditing;

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  late DateTime focusDate;
  final StoryController controller = StoryController();

  @override
  void initState() {
    super.initState();
    focusDate = DateTime.parse(widget.trip.startDate);
  }

  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      cleanText(trip.title),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("${trip.startDate} until ${trip.endDate}",
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 24),
                    Text(cleanText(trip.description),
                        style: Theme.of(context).textTheme.bodyMedium),
                    // _buildDescriptionText(),
                  ],
                )),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FlightsSection(trip: trip),
                            ),
                          );
                        },
                        child: Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Transform.rotate(
                              angle: 1.5708 / 2,
                              child: const Icon(Icons.flight),
                            )),
                      ),
                      const SizedBox(height: 8),
                      Text("Flights",
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Container(
                      height: 64,
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.6)),
                  const SizedBox(width: 16),
                  ...trip.destinations.map((dest) {
                    String url = dest.photos.isEmpty
                        ? "https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM="
                        : dest.photos.first;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            List<StoryItem> storyItems = dest.photos
                                .map((imgUrl) => StoryItem.pageImage(
                                    url: getPhotoUrl(imgUrl), controller: controller))
                                .toList();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => StoryViewPage(
                                    storyItems: storyItems,
                                    controller: controller,
                                    dest: dest),
                              ),
                            );
                          },
                          child: Container(
                            height: 64,
                            width: 64,
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.network(
                                getPhotoUrl(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 64, // Set fixed width
                          child: Text(
                            dest.name,
                            style: Theme.of(context).textTheme.labelSmall,
                            maxLines: 1, // Limit to 1 line
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis if text overflows
                            textAlign:
                                TextAlign.center, // Center align the text
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
            StickyHeader(
              header: _buildCalendarHeader(),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  DestSection(trip: trip, focusDate: focusDate),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  AccomSection(trip: trip, focusDate: focusDate),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            widget.isEditing
                ? Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primaryContainer),
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PromptSuccess(),
                              ),
                            );
                          },
                          child: Text("Get Started",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  )),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.only(top: 40, bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              bottom:
                  BorderSide(width: 1.5, color: Colors.white.withOpacity(0.3)),
            ),
          ),
          child: EasyInfiniteDateTimeLine(
            // controller: _controller,
            selectionMode: const SelectionMode.alwaysFirst(),
            firstDate: DateTime.parse(widget.trip.startDate),
            focusDate: focusDate,
            lastDate: DateTime.parse(widget.trip.endDate),
            onDateChange: (selectedDate) {
              setState(() {
                focusDate = selectedDate;
              });
            },
            dayProps: const EasyDayProps(width: 64.0, height: 64),
            locale: "en_GB",
            showTimelineHeader: false,
            itemBuilder: (
              BuildContext context,
              DateTime date,
              bool isSelected,
              VoidCallback onTap,
            ) {
              return GestureDetector(
                // You can use `InkResponse` to make your widget clickable.
                // The `onTap` callback responsible for triggering the `onDateChange`
                // callback and animating to the selected date if the `selectionMode` is
                // SelectionMode.autoCenter() or SelectionMode.alwaysFirst().
                onTap: onTap,
                child: CircleAvatar(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.black,
                  radius: 32.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          EasyDateFormatter.shortDayName(date, "en_GB"),
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildDescriptionText() {
  //   final String description = widget.trip.description;
  //   return LayoutBuilder(
  //     builder: (BuildContext context, BoxConstraints constraints) {
  //       final textStyle = Theme.of(context).textTheme.bodyMedium;

  //       // Create a TextSpan to measure the text size
  //       final textSpan = TextSpan(text: description, style: textStyle);
  //       final textPainter = TextPainter(
  //         text: textSpan,
  //         maxLines: _isExpanded ? null : 3, // Limit to 3 lines if collapsed
  //         textAlign: TextAlign.left,
  //         textDirection: TextDirection.ltr,
  //       );

  //       textPainter.layout(maxWidth: constraints.maxWidth);

  //       // Check if text is overflowing
  //       bool isTextOverflowing = textPainter.didExceedMaxLines;

  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             description,
  //             maxLines: _isExpanded ? null : 3, // Show full text if expanded
  //             overflow: TextOverflow.ellipsis,
  //             style: textStyle,
  //           ),
  //           if (isTextOverflowing) // Show "Read More" only if text overflows
  //             GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   _isExpanded =
  //                       !_isExpanded; // Toggle between collapsed and expanded
  //                 });
  //               },
  //               child: Text(
  //                 _isExpanded ? "Show Less" : "Read More",
  //                 style: TextStyle(
  //                   color: Theme.of(context).colorScheme.primary,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
