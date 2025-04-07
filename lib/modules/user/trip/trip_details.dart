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
import 'package:jejom/utils/theme/app_theme.dart';
import 'package:jejom/utils/widgets/app_back_button.dart';
import 'package:jejom/utils/widgets/glass_container.dart';
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
    // final scriptGameProvider = Provider.of<ScriptGameProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0E6FF),
                  Color(0xFFD5E6F3),
                ],
              ),
            ),
          ),

          // Abstract design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AppBackButton(
                        onTap: () => Navigator.of(context).pop(),
                        hasBackground: true,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppTheme.paddingLarge),
                          Text(
                            cleanText(trip.title),
                            style: AppTheme.displayMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppTheme.paddingMedium),
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
                            child: Text(
                              "${trip.startDate} until ${trip.endDate}",
                              style: AppTheme.labelMedium.copyWith(
                                color: AppTheme.travelPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.paddingMedium),
                          Text(
                            cleanText(trip.description),
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textDark.withOpacity(0.8),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: AppTheme.paddingLarge),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: AppTheme.paddingMedium),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FlightsSection(trip: trip),
                                  ),
                                );
                              },
                              child: GlassContainer(
                                width: 64,
                                height: 64,
                                borderRadius: BorderRadius.circular(32),
                                child: Center(
                                  child: Transform.rotate(
                                    angle: 1.5708 / 2,
                                    child: const Icon(
                                      Icons.flight,
                                      color: AppTheme.travelPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.paddingSmall),
                            Text(
                              "Flights",
                              style: AppTheme.labelSmall.copyWith(
                                color: AppTheme.textDark.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: AppTheme.paddingMedium),
                        Container(
                            height: 64,
                            width: 1,
                            color: Colors.white.withOpacity(0.3)),
                        const SizedBox(width: AppTheme.paddingMedium),
                        ...trip.destinations.map((dest) {
                          String url = dest.photos.isEmpty
                              ? "https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM="
                              : dest.photos.first;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  List<StoryItem> storyItems = dest.photos
                                      .map((imgUrl) => StoryItem.pageImage(
                                          url: getPhotoUrl(imgUrl),
                                          controller: controller))
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
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.only(
                                      right: AppTheme.paddingMedium),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: AppTheme.travelPrimary
                                          .withOpacity(0.3),
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
                              const SizedBox(height: AppTheme.paddingSmall),
                              SizedBox(
                                width: 64,
                                child: Text(
                                  dest.name,
                                  style: AppTheme.labelSmall.copyWith(
                                    color: AppTheme.textDark.withOpacity(0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
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
                        const Divider(color: Colors.black26),
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
                              padding:
                                  const EdgeInsets.all(AppTheme.paddingMedium),
                              child: GlassContainer.button(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PromptSuccess(),
                                    ),
                                  );
                                },
                                isActive: true,
                                child: Text(
                                  "Get Started",
                                  style: AppTheme.labelLarge.copyWith(
                                    color: AppTheme.travelPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return GlassContainer(
      width: double.infinity,
      borderRadius: BorderRadius.zero,
      backgroundColor: Colors.white.withOpacity(0.1),
      blurIntensity: 8.0,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 16),
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
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: isSelected
                    ? GlassContainer(
                        width: 48.0,
                        height: 48.0,
                        padding: const EdgeInsets.all(AppTheme.paddingSmall),
                        borderRadius: BorderRadius.circular(24.0),
                        backgroundColor:
                            AppTheme.travelPrimary.withOpacity(0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: AppTheme.labelLarge.copyWith(
                                color: AppTheme.travelPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              EasyDateFormatter.shortDayName(date, "en_GB"),
                              style: AppTheme.labelSmall.copyWith(
                                color: AppTheme.travelPrimary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: AppTheme.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              EasyDateFormatter.shortDayName(date, "en_GB"),
                              style: AppTheme.labelSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          },
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
