class GameLevel {
  final String hints; // Turkish hints (arananlar)
  final String sourceWord; // Letters to use (word)
  final List<String> targetWords; // Words to find (answers)
  final List<String> validWords; // All valid words including bonus
  
  GameLevel({
    required this.hints,
    required this.sourceWord,
    required this.targetWords,
    required this.validWords,
  });
  
  factory GameLevel.fromJson(Map<String, dynamic> json) {
    return GameLevel(
      hints: json['hints'] ?? '',
      sourceWord: json['sourceWord'] ?? '',
      targetWords: List<String>.from(json['targetWords'] ?? []),
      validWords: List<String>.from(json['validWords'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'hints': hints,
      'sourceWord': sourceWord,
      'targetWords': targetWords,
      'validWords': validWords,
    };
  }
}

class WorldData {
  static const int numSubWorlds = 5;
  
  static int getNumLevels(int world, int subWorld) {
    // Level counts per world/subworld
    const numLevels = [
      [12, 18, 18, 18, 18], // World 0
      [18, 19, 18, 18, 18], // World 1
      [18, 18, 18, 18, 18], // World 2
      [18, 18, 18, 18, 18], // World 3
      [18, 18, 18, 18, 18], // World 4
      [18, 18, 18, 18, 18], // World 5
      [18, 18, 18, 18, 18], // World 6
    ];
    
    if (world < numLevels.length && subWorld < numLevels[world].length) {
      return numLevels[world][subWorld];
    }
    return 18; // Default
  }
}