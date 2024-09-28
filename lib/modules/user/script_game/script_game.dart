import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/modules/user/trip/components/build_carousel.dart';
import 'package:jejom/modules/user/trip/components/get_photo_url.dart';
import 'package:jejom/providers/user/script_game_provider.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScriptGamePage extends StatefulWidget {
  const ScriptGamePage({super.key});

  @override
  State<ScriptGamePage> createState() => _ScriptGamePageState();
}

class _ScriptGamePageState extends State<ScriptGamePage> {
  final PageController _pageController = PageController();
  _SelectedTab selectedTab = _SelectedTab.restaurant;

  void handleIndexChanged(int i) {
    setState(() {
      selectedTab = _SelectedTab.values[i];
      _pageController.jumpToPage(i);
    });
  }

  Future<void> launchGoogleMaps(
      double destinationLatitude, double destinationLongitude) async {
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
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
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                SegmentedButton<Language>(
                  segments: const <ButtonSegment<Language>>[
                    ButtonSegment<Language>(
                        value: Language.english, label: Text('Eng')),
                    ButtonSegment<Language>(
                        value: Language.korean, label: Text('Kor')),
                  ],
                  selected: <Language>{scriptGameProvider.lang},
                  onSelectionChanged: (Set<Language> newSelection) {
                    scriptGameProvider.updateLanguage(newSelection.first);
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          //Show divider when on scroll
          Container(
            height: 1,
            color: Theme.of(context).colorScheme.surface,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedTab = _SelectedTab.values[index];
                });
              },
              children: [
                _buildRestaurantTab(scriptGameProvider),
                _buildScriptTab(scriptGameProvider),
                // _buildCharacterTab(scriptGameProvider),
                // _buildAddTab(scriptGameProvider),
                // _buildClueTab(scriptGameProvider),
                // _buildPlayerTab(scriptGameProvider),
              ],
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          marginR: const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
          currentIndex: _SelectedTab.values.indexOf(selectedTab),
          unselectedItemColor: Colors.white70,
          selectedItemColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Colors.black.withOpacity(0.1),
          onTap: handleIndexChanged,
          enableFloatingNavBar: true,
          items: [
            CrystalNavigationBarItem(
              icon: Icons.restaurant_rounded,
              unselectedIcon: Icons.restaurant_outlined,
            ),
            CrystalNavigationBarItem(
              icon: Icons.home,
              unselectedIcon: Icons.home_outlined,
            ),
            // CrystalNavigationBarItem(
            //   icon: Icons.child_care_rounded,
            //   unselectedIcon: Icons.child_care_outlined,
            // ),
            // CrystalNavigationBarItem(
            //   icon: Icons.book_rounded,
            //   unselectedIcon: Icons.book_outlined,
            // ),
            // CrystalNavigationBarItem(
            //   icon: Icons.follow_the_signs_rounded,
            //   unselectedIcon: Icons.follow_the_signs_outlined,
            // ),
            // CrystalNavigationBarItem(
            //   icon: Icons.person_rounded,
            //   unselectedIcon: Icons.person_outline_rounded,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantTab(ScriptGameProvider scriptGameProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              scriptGameProvider.selectedGame?.title ?? "",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Duration: ${scriptGameProvider.selectedGame?.duration ?? ""}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Text(
              scriptGameProvider.restaurant?.name ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildCarousel(
                    photos: scriptGameProvider.restaurant?.images ?? []),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      scriptGameProvider.restaurant?.description ?? "",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 7,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                            "${scriptGameProvider.restaurant?.userRatingsTotal}",
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(width: 8),
                        StarRating(
                          rating: scriptGameProvider
                                  .restaurant?.userRatingsTotal
                                  ?.toDouble() ??
                              0,
                          allowHalfRating: true,
                        ),
                        const SizedBox(width: 8),
                        Text(
                            "(${scriptGameProvider.restaurant?.userRatingsTotal})",
                            style: Theme.of(context).textTheme.labelLarge),
                        const Spacer(),
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
                          "Opening Hours: ${(scriptGameProvider.restaurant?.currentOpeningHours?.weekdayText![0])}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Address: ${(scriptGameProvider.restaurant?.address)}",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 56),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // Widget _buildScriptTab(ScriptGameProvider scriptGameProvider) {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(height: 32),
  //           Text(
  //             "Storyline",
  //             style: Theme.of(context).textTheme.headlineLarge,
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             scriptGameProvider.games.first.scriptPlanner
  //                 .replaceAll(r'\n', '\n'),
  //             style: Theme.of(context).textTheme.bodyLarge,
  //             maxLines: 9,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           const SizedBox(height: 24),
  //           Text("Visit the restaurant to know about the full story!",
  //               style: Theme.of(context).textTheme.bodyMedium),
  //           const SizedBox(height: 120),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildScriptTab(ScriptGameProvider scriptGameProvider) {
    final List<String> scriptSections =
        scriptGameProvider.games.first.scriptPlanner.split("<image>");
    final List<String> images = scriptGameProvider.games.first.images;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Storyline",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            ..._buildScriptWithImages(scriptSections, images),
            const SizedBox(height: 24),
            Text(
              "Visit the restaurant to know about the full story!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScriptWithImages(
      List<String> scriptSections, List<String> images) {
    List<Widget> widgets = [];

    for (int i = 0; i < scriptSections.length; i++) {
      widgets.add(
        Text(
          scriptSections[i].replaceAll(r'\n', '\n'),
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 9,
          overflow: TextOverflow.ellipsis,
        ),
      );

      if (i < images.length && images[i].isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Image.network(
              images[i],
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildCharacterTab(ScriptGameProvider scriptGameProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Character Designer",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              scriptGameProvider.games.first.characterDesigner
                  .replaceAll(r'\n', '\n'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTab(ScriptGameProvider scriptGameProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Script Writer",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              scriptGameProvider.games.first.scriptWriter
                  .replaceAll(r'\n', '\n'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildClueTab(ScriptGameProvider scriptGameProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Clue Generator",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              scriptGameProvider.games.first.clueGenerator
                  .replaceAll(r'\n', '\n'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerTab(ScriptGameProvider scriptGameProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Player Instruction Writer",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              scriptGameProvider.games.first.playerInstructionWriter
                  .replaceAll(r'\n', '\n'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { restaurant, storyline }
