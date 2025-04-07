import 'package:flutter/material.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/providers/restaurant/script_restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class ScriptDetailsPage extends StatefulWidget {
  const ScriptDetailsPage({super.key});

  @override
  State<ScriptDetailsPage> createState() => _ScriptDetailsPageState();
}

class _ScriptDetailsPageState extends State<ScriptDetailsPage> {
  final PageController _pageController = PageController();
  _SelectedTab selectedTab = _SelectedTab.storyline;

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
        queryParameters: {'q': '$destinationLatitude, $destinationLongitude'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scriptGameProvider = Provider.of<ScriptRestaurantProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Check if the games list is empty or no selected game is available
    if (scriptGameProvider.games.isEmpty ||
        scriptGameProvider.selectedGame == null) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: Text(
            'No scripts available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBody: true,
      extendBodyBehindAppBar: true,
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

          // Main scrollable content
          SafeArea(
            bottom: false,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedTab = _SelectedTab.values[index];
                });
              },
              children: [
                _buildScriptTab(scriptGameProvider),
                _buildCharacterTab(scriptGameProvider),
                _buildAddTab(scriptGameProvider),
                _buildClueTab(scriptGameProvider),
                _buildPlayerTab(scriptGameProvider),
              ],
            ),
          ),

          // Top header overlay - more translucent
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Header with back button and language selector
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.black87),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                "Script Details",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Row(
                                          children: [
                                            if (scriptGameProvider.lang ==
                                                Language.english)
                                              const Icon(Icons.check,
                                                  size: 14,
                                                  color: Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Row(
                                          children: [
                                            if (scriptGameProvider.lang ==
                                                Language.korean)
                                              const Icon(Icons.check,
                                                  size: 14,
                                                  color: Colors.white),
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

                        // Time and script info card - more transparent
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            scriptGameProvider
                                                    .selectedGame?.title ??
                                                "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Duration: ${scriptGameProvider.selectedGame?.duration ?? ""}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom navigation overlay - fixed overflow
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(0, Icons.menu_book,
                            Icons.menu_book_outlined, "Story"),
                        _buildNavItem(1, Icons.person, Icons.person_outlined,
                            "Character"),
                        _buildNavItem(2, Icons.theater_comedy,
                            Icons.theater_comedy_outlined, "Script"),
                        _buildNavItem(
                            3, Icons.search, Icons.search_outlined, "Clues"),
                        _buildNavItem(4, Icons.people_alt,
                            Icons.people_alt_outlined, "Players"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData selectedIcon, IconData unselectedIcon, String label) {
    final isSelected = index == _SelectedTab.values.indexOf(selectedTab);

    return GestureDetector(
      onTap: () => handleIndexChanged(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:
                  isSelected ? Colors.black87 : Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? Colors.white : Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  isSelected ? Colors.black87 : Colors.black87.withOpacity(0.7),
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  content.replaceAll(r'\n', '\n'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScriptTab(ScriptRestaurantProvider scriptGameProvider) {
    final selectedGame = scriptGameProvider.selectedGame;

    if (selectedGame == null) {
      return const Center(child: Text('No game selected.'));
    }

    if (scriptGameProvider.games.isEmpty) {
      return const Center(child: Text('No games available.'));
    }

    final List<String> scriptSections =
        selectedGame.scriptPlanner.split("<image>");
    final List<String> images = selectedGame.images;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 200), // Reduced padding for header
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Storyline",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ..._buildScriptWithImages(scriptSections, images),
            const SizedBox(height: 80), // Reduced padding for bottom
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScriptWithImages(
      List<String> scriptSections, List<String> images) {
    List<Widget> widgets = [];

    for (int i = 0; i < scriptSections.length; i++) {
      if (scriptSections[i].trim().isNotEmpty) {
        widgets.add(
          _buildContentCard("Part ${i + 1}", scriptSections[i]),
        );
      }

      if (i < images.length && images[i].isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildCharacterTab(ScriptRestaurantProvider scriptGameProvider) {
    if (scriptGameProvider.games.isEmpty) {
      return const Center(child: Text('No games available.'));
    }

    if (scriptGameProvider.selectedGame == null) {
      return const Center(child: Text('No game selected.'));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 200), // Reduced paFdding for header
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Character Designer",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildContentCard(
              "Character Details",
              scriptGameProvider.selectedGame!.characterDesigner,
            ),
            const SizedBox(height: 80), // Reduced padding for bottom
          ],
        ),
      ),
    );
  }

  Widget _buildAddTab(ScriptRestaurantProvider scriptGameProvider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 200), // Reduced padding for header
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Script Writer",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildContentCard(
              "Script Details",
              scriptGameProvider.games.first.scriptWriter,
            ),
            const SizedBox(height: 80), // Reduced padding for bottom
          ],
        ),
      ),
    );
  }

  Widget _buildClueTab(ScriptRestaurantProvider scriptGameProvider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 200), // Reduced padding for header
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Clue Generator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildContentCard(
              "Clue Details",
              scriptGameProvider.games.first.clueGenerator,
            ),
            const SizedBox(height: 80), // Reduced padding for bottom
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerTab(ScriptRestaurantProvider scriptGameProvider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 200), // Reduced padding for header
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Player Instruction Writer",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildContentCard(
              "Player Instructions",
              scriptGameProvider.games.first.playerInstructionWriter,
            ),
            const SizedBox(height: 80), // Reduced padding for bottom
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { storyline, character, add, clue, player }
