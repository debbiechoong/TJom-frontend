class ScriptGame {
  final String scriptPlanner;
  final String characterDesigner;
  final String scriptWriter;
  final String clueGenerator;
  final String playerInstructionWriter;
  final String title;
  final String duration;
  final String restaurantId;
  final List<String> images;

  ScriptGame({
    required this.scriptPlanner,
    required this.characterDesigner,
    required this.scriptWriter,
    required this.clueGenerator,
    required this.playerInstructionWriter,
    required this.title,
    required this.duration,
    required this.restaurantId,
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
      restaurantId: json['restaurant'],
      images: json['images'] != null
          ? List<String>.from(json['images'].map((x) => (x)))
          : [],
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
      'restaurant': restaurantId,
      'Title': title,
      'Duration': duration,
      'images': images,
    };
  }
}
