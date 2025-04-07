import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/modules/user/trip/components/build_carousel.dart';
import 'package:jejom/providers/user/script_game_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class ScriptGamePage extends StatefulWidget {
  const ScriptGamePage({super.key});

  @override
  State<ScriptGamePage> createState() => _ScriptGamePageState();
}

class _ScriptGamePageState extends State<ScriptGamePage> {
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
    final scriptGameProvider = Provider.of<ScriptGameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Background gradient
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

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header with back button and language selector
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                    child: Row(
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(Icons.arrow_back,
                                color: Colors.black54),
                          ),
                        ),

                        const Spacer(),

                        // Language selector
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  scriptGameProvider
                                      .updateLanguage(Language.english);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: scriptGameProvider.lang ==
                                            Language.english
                                        ? Colors.black
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      if (scriptGameProvider.lang ==
                                          Language.english)
                                        const Icon(Icons.check,
                                            size: 14, color: Colors.white),
                                      if (scriptGameProvider.lang ==
                                          Language.english)
                                        const SizedBox(width: 4),
                                      const Text(
                                        "Eng",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  scriptGameProvider
                                      .updateLanguage(Language.korean);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: scriptGameProvider.lang ==
                                            Language.korean
                                        ? Colors.black
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      if (scriptGameProvider.lang ==
                                          Language.korean)
                                        const Icon(Icons.check,
                                            size: 14, color: Colors.white),
                                      if (scriptGameProvider.lang ==
                                          Language.korean)
                                        const SizedBox(width: 4),
                                      const Text(
                                        "Kor",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content sections - display both on same page
                  _buildRestaurantSection(scriptGameProvider),
                  _buildScriptSection(scriptGameProvider),

                  // Add padding at bottom for better scrolling experience
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Top gradient overlay that fades to transparent
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantSection(ScriptGameProvider scriptGameProvider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game title
          Text(
            scriptGameProvider.selectedGame?.title ?? "",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Duration
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.7),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Duration header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Duration",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        scriptGameProvider.selectedGame?.duration ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Restaurant details card
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant name
                    Text(
                      scriptGameProvider.restaurant?.name ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Restaurant images
                    BuildCarousel(
                      photos: scriptGameProvider.restaurant?.images ?? [],
                    ),

                    const SizedBox(height: 16),

                    // Restaurant description
                    Text(
                      scriptGameProvider.restaurant?.description ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 7,
                    ),

                    const SizedBox(height: 16),

                    // Ratings
                    Row(
                      children: [
                        Text(
                          "${scriptGameProvider.restaurant?.userRatingsTotal ?? 0}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StarRating(
                          rating: scriptGameProvider
                                  .restaurant?.userRatingsTotal
                                  ?.toDouble() ??
                              0,
                          allowHalfRating: true,
                          size: 20,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "(${scriptGameProvider.restaurant?.userRatingsTotal ?? 0})",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Opening hours
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.timer_rounded,
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Opening Hours: ${(scriptGameProvider.restaurant?.currentOpeningHours?.weekdayText?.isNotEmpty ?? false) ? scriptGameProvider.restaurant?.currentOpeningHours?.weekdayText![0] : 'Not available'}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.black54,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Address: ${scriptGameProvider.restaurant?.address ?? 'Not available'}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScriptSection(ScriptGameProvider scriptGameProvider) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Storyline",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Story preview
                    scriptGameProvider.games.isEmpty
                        ? const Text(
                            "No story available. Please check back later.",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          )
                        : Text(
                            scriptGameProvider.games.first.scriptPlanner
                                .replaceAll(r'\n', '\n'),
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                            maxLines: 9,
                            overflow: TextOverflow.ellipsis,
                          ),

                    const SizedBox(height: 24),

                    // Note
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Visit the restaurant to know about the full story!",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
