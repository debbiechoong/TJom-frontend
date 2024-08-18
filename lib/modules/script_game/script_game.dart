import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/providers/script_game_provider.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:jejom/utils/theme.dart';
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
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
                _buildCharacterTab(scriptGameProvider),
                _buildAddTab(scriptGameProvider),
                _buildClueTab(scriptGameProvider),
                _buildPlayerTab(scriptGameProvider),
              ],
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          marginR: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
            CrystalNavigationBarItem(
              icon: Icons.child_care_rounded,
              unselectedIcon: Icons.child_care_outlined,
            ),
            CrystalNavigationBarItem(
              icon: Icons.book_rounded,
              unselectedIcon: Icons.book_outlined,
            ),
            CrystalNavigationBarItem(
              icon: Icons.follow_the_signs_rounded,
              unselectedIcon: Icons.follow_the_signs_outlined,
            ),
            CrystalNavigationBarItem(
              icon: Icons.person_rounded,
              unselectedIcon: Icons.person_outline_rounded,
            ),
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
            // const SizedBox(height: 32),
            // Text(
            //   "Offered Restaurants",
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
            // const SizedBox(height: 16),
            MediaQuery.removePadding(
              context: context,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scriptGameProvider.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = scriptGameProvider.restaurants[index];
                  return GlassContainer(
                    padding: 16,
                    marginBottom: 16,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: M3Carousel(
                            visible: 2,
                            slideAnimationDuration: 300, // milliseconds
                            titleFadeAnimationDuration: 200, // milliseconds
                            children: [
                              ...restaurant.imageUrl.map((url) {
                                return {"image": url, "title": ""};
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    restaurant.description,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                launchGoogleMaps(
                                    restaurant.lat, restaurant.long);
                              },
                              child: Container(
                                width: 64,
                                height: 64,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Transform.rotate(
                                  angle: 1.5708 / 2,
                                  child: const Icon(Icons.arrow_upward_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildScriptTab(ScriptGameProvider scriptGameProvider) {
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
            Text(
              scriptGameProvider.games.first.scriptPlanner,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
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
              scriptGameProvider.games.first.characterDesigner,
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
              scriptGameProvider.games.first.scriptWriter,
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
              scriptGameProvider.games.first.clueGenerator,
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
              scriptGameProvider.games.first.playerInstructionWriter,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { restaurant, script, character, add, clue, player }
