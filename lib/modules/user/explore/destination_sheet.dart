import 'package:flutter/material.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/utils/base_draggable.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

// ignore: must_be_immutable
class DestinationBottomSheet extends StatefulWidget {
  DestinationBottomSheet({
    super.key,
    required this.destinationSheetKey,
    required this.destinationSheetController,
    required this.openSheet,
    required this.closeSheet,
    this.pickedDestination,
  });

  final GlobalKey destinationSheetKey;
  final DraggableScrollableController destinationSheetController;
  final Function openSheet;
  final Function closeSheet;
  InterestDestination? pickedDestination;

  @override
  State<DestinationBottomSheet> createState() => _DestinationBottomSheetState();
}

class _DestinationBottomSheetState extends State<DestinationBottomSheet> {
  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.destinationSheetController.removeListener(() {});
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeData = Theme.of(context);
    super.didChangeDependencies();
  }

  Future<void> launchGoogleMaps(
      double destinationLatitude, double destinationLongitude) async {
    final uri = Uri(
        scheme: "google.navigation",
        queryParameters: {'q': '$destinationLatitude, $destinationLongitude'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDraggableSheet(
      sheetKey: widget.destinationSheetKey,
      controller: widget.destinationSheetController,
      minChildSize: 120 / MediaQuery.of(context).size.height,
      child: SliverToBoxAdapter(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE0E6FF),
                    Color(0xFFD5E6F3),
                  ],
                  stops: [0.0, 1.0],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 64,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.black26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    widget.pickedDestination?.name ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.pickedDestination != null) {
                            launchGoogleMaps(widget.pickedDestination!.lat,
                                widget.pickedDestination!.long);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.directions,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Navigate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      GestureDetector(
                        onTap: () {
                          // Save functionality could be added here
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bookmark_outline,
                                color: Colors.black87,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Images carousel
                  if (widget.pickedDestination != null && 
                      widget.pickedDestination!.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: M3Carousel(
                          slideAnimationDuration: 300,
                          titleFadeAnimationDuration: 200,
                          children: [
                            ...widget.pickedDestination!.imageUrl.map((img) {
                              return {"image": img, "title": ""};
                            }),
                          ],
                        ),
                      ),
                    ),
                    
                  const SizedBox(height: 20),
                  
                  // Description section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About this place",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.pickedDestination?.description ?? "No description available",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Address section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.pickedDestination?.address ?? "No address available",
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
