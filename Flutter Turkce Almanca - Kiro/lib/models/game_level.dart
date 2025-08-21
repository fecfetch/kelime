class GameLevel {
  final dynamic hints; // Can be String (old format) or Map<String, String> (new multilingual format)
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
  
  // Get hints for a specific language (backward compatible)
  String getHintsForLanguage(String languageCode) {
    if (hints is String) {
      // Old format - return as is (assumed to be Turkish)
      return hints as String;
    } else if (hints is Map<String, dynamic>) {
      // New multilingual format
      final hintsMap = Map<String, String>.from(hints as Map);
      return hintsMap[languageCode] ?? hintsMap.values.first;
    }
    return '';
  }
  
  // Get available hint languages
  List<String> getAvailableLanguages() {
    if (hints is Map<String, dynamic>) {
      return (hints as Map<String, dynamic>).keys.cast<String>().toList();
    }
    return ['turkish']; // Default for old format
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