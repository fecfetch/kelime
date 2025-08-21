class GameLevel {
  final dynamic hints; // Can be String (old format) or Map<String, String> (new multilingual format)
  final String sourceWord; // Letters to use (word)
  final List<String> targetWords; // Words to find (answers)
  final List<String> validWords; // All valid words including bonus
  
  final int world;
  final int subWorld;
  final int level;
  
  GameLevel({
    required this.hints,
    required this.sourceWord,
    required this.targetWords,
    required this.validWords,
    this.world = 0,
    this.subWorld = 0,
    this.level = 0,
  });
  
  factory GameLevel.fromJson(Map<String, dynamic> json) {
    return GameLevel(
      hints: json['hints'] ?? '',
      sourceWord: json['sourceWord'] ?? '',
      targetWords: List<String>.from(json['targetWords'] ?? []),
      validWords: List<String>.from(json['validWords'] ?? []),
      world: json['world'] ?? 0,
      subWorld: json['subWorld'] ?? 0,
      level: json['level'] ?? 0,
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
      
      // Map language codes to language names used in level files
      final languageMap = {
        'en': 'english',
        'de': 'german',
        'fr': 'french',
        'es': 'spanish',
        'tr': 'turkish',
        'zh': 'chinese',
        'hi': 'hindi',
      };
      
      final languageName = languageMap[languageCode] ?? languageCode;
      
      return hintsMap[languageName] ?? hintsMap.values.first;
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