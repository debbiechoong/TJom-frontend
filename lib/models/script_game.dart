class ScriptGame {
  final String scriptPlanner;
  final String characterDesigner;
  final String scriptWriter;
  final String clueGenerator;
  final String playerInstructionWriter;
  final String title;
  final String duration;
  final List<String> restaurantIds;
  final List<String> images;

  ScriptGame({
    required this.scriptPlanner,
    required this.characterDesigner,
    required this.scriptWriter,
    required this.clueGenerator,
    required this.playerInstructionWriter,
    required this.title,
    required this.duration,
    required this.restaurantIds,
    required this.images,
  });

  // Factory constructor to create a ScriptGame from JSON
  factory ScriptGame.fromJson(Map<String, dynamic> json) {
    return ScriptGame(
      scriptPlanner: json['Script Planner'],
      characterDesigner: json['Character Designer'],
      scriptWriter: json['Script Writer'],
      clueGenerator: json['Clue Generator'],
      playerInstructionWriter: json['Player Instruction Writer'],
      title: json['Title'],
      duration: json['Duration'],
      restaurantIds: List<String>.from(json['restaurants']),
      images: List<String>.from(json['images']),
    );
  }

  // Method to convert a ScriptGame to JSON
  Map<String, dynamic> toJson() {
    return {
      'Script Planner': scriptPlanner,
      'Character Designer': characterDesigner,
      'Script Writer': scriptWriter,
      'Clue Generator': clueGenerator,
      'Player Instruction Writer': playerInstructionWriter,
      'restaurants': restaurantIds,
      'Title': title,
      'Duration': duration,
      'images': images,
    };
  }
}
