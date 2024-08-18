class ScriptGame {
  final String scriptPlanner;
  final String characterDesigner;
  final String scriptWriter;
  final String clueGenerator;
  final String playerInstructionWriter;

  ScriptGame({
    required this.scriptPlanner,
    required this.characterDesigner,
    required this.scriptWriter,
    required this.clueGenerator,
    required this.playerInstructionWriter,
  });

  // Factory constructor to create a ScriptGame from JSON
  factory ScriptGame.fromJson(Map<String, dynamic> json) {
    return ScriptGame(
      scriptPlanner: json['Script Planner'],
      characterDesigner: json['Character Designer'],
      scriptWriter: json['Script Writer'],
      clueGenerator: json['Clue Generator'],
      playerInstructionWriter: json['Player Instruction Writer'],
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
    };
  }
}
