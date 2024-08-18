import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/providers/script_game_provider.dart';
import 'package:provider/provider.dart';

class ScriptGamePage extends StatefulWidget {
  const ScriptGamePage({super.key});

  @override
  State<ScriptGamePage> createState() => _ScriptGamePageState();
}

class _ScriptGamePageState extends State<ScriptGamePage> {
  final PageController _pageController = PageController();
  _SelectedTab selectedTab = _SelectedTab.script;

  void handleIndexChanged(int i) {
    setState(() {
      selectedTab = _SelectedTab.values[i];
      _pageController.jumpToPage(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scriptGameProvider = Provider.of<ScriptGameProvider>(context);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(selectedTab),
          unselectedItemColor: Colors.white70,
          selectedItemColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundColor: Colors.black.withOpacity(0.1),
          onTap: handleIndexChanged,
          items: [
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

  Widget _buildScriptTab(ScriptGameProvider scriptGameProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Script Planner",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              scriptGameProvider.games!.first.scriptPlanner,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 80),
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
              scriptGameProvider.games!.first.characterDesigner,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 80),
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
              scriptGameProvider.games!.first.scriptWriter,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 80),
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              scriptGameProvider.games!.first.clueGenerator,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 80),
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              scriptGameProvider.games!.first.playerInstructionWriter,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { script, character, add, clue, player }
