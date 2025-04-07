import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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

          // Phone frame with glassmorphic effect
          Center(
            child: Container(
              width: size.width * 0.7,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: AiThoughtProcess(),
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
}

class AiThoughtProcess extends StatefulWidget {
  const AiThoughtProcess({super.key});

  @override
  State<AiThoughtProcess> createState() => _AiThoughtProcessState();
}

class _AiThoughtProcessState extends State<AiThoughtProcess> {
  final ScrollController _scrollController = ScrollController();
  final List<WordEntry> _words = [];
  int _currentParagraphIndex = 0;
  int _currentWordIndex = 0;
  Timer? _timer;
  final int _maxWordsToShow = 500; // Show last 500 words
  
  // Define the thought process essay in paragraphs
  final List<String> _allParagraphs = [
    "Initiating mystery script generation process. Analyzing user input parameters and preferences...",
    
    "The foundation of any compelling murder mystery is a carefully constructed setting. For this scenario, I'll consider a closed environment that naturally limits the suspect pool.",
    
    "A remote mountain resort during a snowstorm would create tension and isolation. However, a luxury dinner party at a mansion could offer more interpersonal dynamics and social complexity.",
    
    "Based on the theme preferences, I'm leaning toward the dinner party setting. This allows for class tensions, hidden relationships, and subtle power dynamics that can be exploited for plot development.",
    
    "Now considering the victim profile. The victim should be someone with multiple plausible enemies. Perhaps the host of the dinner party - a wealthy but controversial figure with business connections to all guests.",
    
    "For maximum narrative tension, the victim should die approximately 25-30% into the story timeline, allowing sufficient character establishment but leaving ample time for investigation.",
    
    "Creating character profiles now. Each character needs three elements: a connection to the victim, a potential motive, and a hidden secret unrelated to the murder that could be mistaken for guilt.",
    
    "Character 1: The business partner with financial troubles, stands to gain from victim's life insurance policy, secretly having an affair with Character 3.",
    
    "Character 2: The estranged family member with inheritance claims, publicly argued with victim recently, hiding addiction problems that drain finances.",
    
    "Character 3: The household staff member with access to all areas, recently threatened with dismissal, has criminal record under different identity.",
    
    "Character 4: The romantic interest, appears devastated, actually relieved due to abusive relationship dynamics, forged academic credentials to attain current position.",
    
    "Character 5: The apparent outsider with no obvious connection, secretly investigating the victim for journalistic exposé, has personal vendetta against similar powerful figures.",
    
    "Plotting murder method: A poison that simulates natural causes would allow initial ambiguity about whether a crime occurred. However, a more dramatic staging could immediately establish the tone.",
    
    "Considering audience preferences, I'll implement a hybrid approach - death appears accidental until a key piece of evidence reveals deliberate tampering, transforming the gathering into an explicit murder investigation.",
    
    "Designing clue distribution: Critical clues should be revealed at 20%, 40%, 65%, and 85% points in the narrative to maintain engagement and prevent solution too early.",
    
    "Each clue should point to multiple suspects while gradually eliminating possibilities. Red herrings must seem equally plausible to genuine clues to maintain mystery.",
    
    "Mapping character arcs: Each character will undergo revelation of their secrets in order from least to most surprising, creating escalating tension.",
    
    "The true murderer's arc requires special attention - their behavior must be consistent with both innocence and guilt when revisited in hindsight.",
    
    "Creating dialogue distinctive to each character based on background, education level, and emotional state. Regional dialects and speech patterns will enhance differentiation.",
    
    "Generating subplot connections between characters to create a web of relationships that complicate the investigation and provide additional motives.",
    
    "Designing physical environment layout with attention to alibis, secret passages, and timing possibilities. The floor plan must allow for both the murder method and investigation to function logically.",
    
    "Establishing timeline of events with precision to ensure all character movements are accounted for. The critical murder window must have multiple characters with plausible access.",
    
    "Finalizing narrative structure with classic mystery elements: red herrings, false confessions, discovery of new evidence, and a climactic revelation scene.",
    
    "Ensuring solution is complex enough to challenge but with sufficient clues that the answer feels satisfying rather than arbitrary. All clues must be presented before the solution.",
    
    "Reviewing script for plot holes and logical inconsistencies. Murder method physics verified. Timeline checked for continuity errors. Motive strength evaluated for each character.",
    
    "Script preparation nearly complete. Final review of character motivations and psychological profiles to ensure realistic behavior throughout narrative...",
    
    "Mystery script generation complete. Preparing to present full murder mystery scenario with character sheets, location maps, clue timeline, and solution reveal."
  ];

  List<String> _getCurrentParagraphWords() {
    if (_currentParagraphIndex >= _allParagraphs.length) {
      // Start over if we've gone through all paragraphs
      _currentParagraphIndex = 0;
      _currentWordIndex = 0;
    }
    
    return _allParagraphs[_currentParagraphIndex].split(' ');
  }

  @override
  void initState() {
    super.initState();
    
    // Add words with a timer
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        // Get current paragraph's words
        List<String> paragraphWords = _getCurrentParagraphWords();
        
        // Add the next word
        if (_currentWordIndex < paragraphWords.length) {
          _words.add(WordEntry(
            word: paragraphWords[_currentWordIndex], 
            opacity: 0.0,
            isNewLine: _currentWordIndex == 0 && _currentParagraphIndex > 0,
            isPeriod: paragraphWords[_currentWordIndex].contains('.'),
          ));
          
          // Increase word index
          _currentWordIndex++;
          
          // If we've added all words from this paragraph, move to next paragraph
          if (_currentWordIndex >= paragraphWords.length) {
            _currentParagraphIndex++;
            _currentWordIndex = 0;
          }
          
          // Limit the number of words shown
          if (_words.length > _maxWordsToShow) {
            _words.removeAt(0);
          }
          
          // Animate fade-in for newly added word
          _fadeInLastWord();
        }
      });
      
      // Scroll down after adding a word
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }
  
  void _fadeInLastWord() {
    if (_words.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 10), () {
        if (mounted) {
          setState(() {
            _words.last.opacity = 1.0;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: RichText(
        text: TextSpan(
          children: _words.map((entry) {
            return TextSpan(
              text: entry.isNewLine ? '\n\n${entry.word} ' : '${entry.word} ',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black.withOpacity(entry.opacity * 0.7),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class WordEntry {
  final String word;
  double opacity;
  final bool isNewLine;
  final bool isPeriod;
  
  WordEntry({
    required this.word, 
    this.opacity = 0.0, 
    this.isNewLine = false,
    this.isPeriod = false,
  });
}
