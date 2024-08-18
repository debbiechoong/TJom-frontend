import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jejom/models/language_enum.dart';
import 'package:jejom/providers/script_game_provider.dart';
import 'package:provider/provider.dart';

class ScriptGamePage extends StatefulWidget {
  const ScriptGamePage({super.key});

  @override
  State<ScriptGamePage> createState() => _ScriptGamePageState();
}

class _ScriptGamePageState extends State<ScriptGamePage> {
  @override
  Widget build(BuildContext context) {
    final scriptGameProvider = Provider.of<ScriptGameProvider>(context);
    var _selectedTab = _SelectedTab.script;
    void _handleIndexChanged(int i) {
      setState(() {
        _selectedTab = _SelectedTab.values[i];
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                const SizedBox(height: 16),
                Text(
                  "Script Game",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  "Let's play a game! Can you guess the script?",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                ExpansionTile(
                  title: Text(
                    "Script Planner",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        scriptGameProvider.games!.first.scriptPlanner,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Character Designer",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        scriptGameProvider.games!.first.characterDesigner,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Script Writer",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        scriptGameProvider.games!.first.scriptWriter,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Clue Generator",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        scriptGameProvider.games!.first.clueGenerator,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Player Instruction Writer",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        scriptGameProvider.games!.first.playerInstructionWriter,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Start Game"),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          // indicatorColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.1),
          // outlineBorderColor: Colors.black.withOpacity(0.1),
          onTap: _handleIndexChanged,
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: Icons.home,
              unselectedIcon: Icons.home_outlined,
              selectedColor: Colors.white,
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: Icons.child_care_rounded,
              unselectedIcon: Icons.child_care_outlined,
              selectedColor: Colors.red,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: Icons.book_rounded,
              unselectedIcon: Icons.book_outlined,
              selectedColor: Colors.white,
            ),

            /// Search
            CrystalNavigationBarItem(
                icon: Icons.follow_the_signs_rounded,
                unselectedIcon: Icons.follow_the_signs_outlined,
                selectedColor: Colors.white),

            /// Profile
            CrystalNavigationBarItem(
              icon: Icons.person_rounded,
              unselectedIcon: Icons.person_outline_rounded,
              selectedColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { script, character, add, clue, player }
