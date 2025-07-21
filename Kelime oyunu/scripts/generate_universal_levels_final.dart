import 'dart:io';
import 'dart:convert';
import 'dart:math';

// Supported languages enum
enum SupportedLanguage {
  english('en', 'English'),
  german('de', 'Deutsch'),
  turkish('tr', 'Türkçe');

  const SupportedLanguage(this.code, this.nativeName);
  
  final String code;
  final String nativeName;
}

// Universal word entry model
class UniversalWordEntry {
  final String wordId;
  final String word;
  final String cefrLevel;
  final String category;
  final Map<String, String> translations;

  const UniversalWordEntry({
    required this.wordId,
    required this.word,
    required this.cefrLevel,
    required this.category,
    required this.translations,
  });

  String getTranslation(String languageCode) {
    return translations[languageCode] ?? translations['en'] ?? word;
  }
}

// Load word data from existing files by importing them directly
List<UniversalWordEntry> loadEnglishA1Words() {
  // This will be populated by reading the actual file content
  return [
    UniversalWordEntry(
      wordId: 'word_house',
      word: 'house',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'house', 'de': 'haus', 'tr': 'ev'},
    ),
    UniversalWordEntry(
      wordId: 'word_water',
      word: 'water',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'water', 'de': 'wasser', 'tr': 'su'},
    ),
    UniversalWordEntry(
      wordId: 'word_book',
      word: 'book',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'book', 'de': 'buch', 'tr': 'kitap'},
    ),
    UniversalWordEntry(
      wordId: 'word_time',
      word: 'time',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'time', 'de': 'zeit', 'tr': 'zaman'},
    ),
    UniversalWordEntry(
      wordId: 'word_man',
      word: 'man',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'man', 'de': 'mann', 'tr': 'adam'},
    ),
    UniversalWordEntry(
      wordId: 'word_woman',
      word: 'woman',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'woman', 'de': 'frau', 'tr': 'kadın'},
    ),
    UniversalWordEntry(
      wordId: 'word_child',
      word: 'child',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'child', 'de': 'kind', 'tr': 'çocuk'},
    ),
    UniversalWordEntry(
      wordId: 'word_good',
      word: 'good',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'good', 'de': 'gut', 'tr': 'iyi'},
    ),
    UniversalWordEntry(
      wordId: 'word_big',
      word: 'big',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'big', 'de': 'groß', 'tr': 'büyük'},
    ),
    UniversalWordEntry(
      wordId: 'word_small',
      word: 'small',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'small', 'de': 'klein', 'tr': 'küçük'},
    ),
    UniversalWordEntry(
      wordId: 'word_work',
      word: 'work',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'work', 'de': 'arbeiten', 'tr': 'çalışmak'},
    ),
    UniversalWordEntry(
      wordId: 'word_come',
      word: 'come',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'come', 'de': 'kommen', 'tr': 'gelmek'},
    ),
    UniversalWordEntry(
      wordId: 'word_make',
      word: 'make',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'make', 'de': 'machen', 'tr': 'yapmak'},
    ),
    UniversalWordEntry(
      wordId: 'word_school',
      word: 'school',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'school', 'de': 'schule', 'tr': 'okul'},
    ),
    UniversalWordEntry(
      wordId: 'word_family',
      word: 'family',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'family', 'de': 'familie', 'tr': 'aile'},
    ),
    UniversalWordEntry(
      wordId: 'word_friend',
      word: 'friend',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'friend', 'de': 'freund', 'tr': 'arkadaş'},
    ),
    UniversalWordEntry(
      wordId: 'word_money',
      word: 'money',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'money', 'de': 'geld', 'tr': 'para'},
    ),
    UniversalWordEntry(
      wordId: 'word_night',
      word: 'night',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'night', 'de': 'nacht', 'tr': 'gece'},
    ),
    UniversalWordEntry(
      wordId: 'word_place',
      word: 'place',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'place', 'de': 'platz', 'tr': 'yer'},
    ),
    UniversalWordEntry(
      wordId: 'word_world',
      word: 'world',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'world', 'de': 'welt', 'tr': 'dünya'},
    ),
  ];
}

List<UniversalWordEntry> loadGermanA1Words() {
  return [
    UniversalWordEntry(
      wordId: 'word_haus',
      word: 'haus',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'house', 'de': 'haus', 'tr': 'ev'},
    ),
    UniversalWordEntry(
      wordId: 'word_wasser',
      word: 'wasser',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'water', 'de': 'wasser', 'tr': 'su'},
    ),
    UniversalWordEntry(
      wordId: 'word_buch',
      word: 'buch',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'book', 'de': 'buch', 'tr': 'kitap'},
    ),
    UniversalWordEntry(
      wordId: 'word_zeit',
      word: 'zeit',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'time', 'de': 'zeit', 'tr': 'zaman'},
    ),
    UniversalWordEntry(
      wordId: 'word_mann',
      word: 'mann',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'man', 'de': 'mann', 'tr': 'adam'},
    ),
    UniversalWordEntry(
      wordId: 'word_frau',
      word: 'frau',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'woman', 'de': 'frau', 'tr': 'kadın'},
    ),
    UniversalWordEntry(
      wordId: 'word_kind',
      word: 'kind',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'child', 'de': 'kind', 'tr': 'çocuk'},
    ),
    UniversalWordEntry(
      wordId: 'word_gut',
      word: 'gut',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'good', 'de': 'gut', 'tr': 'iyi'},
    ),
    UniversalWordEntry(
      wordId: 'word_groß',
      word: 'groß',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'big', 'de': 'groß', 'tr': 'büyük'},
    ),
    UniversalWordEntry(
      wordId: 'word_klein',
      word: 'klein',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'small', 'de': 'klein', 'tr': 'küçük'},
    ),
    UniversalWordEntry(
      wordId: 'word_arbeiten',
      word: 'arbeiten',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'work', 'de': 'arbeiten', 'tr': 'çalışmak'},
    ),
    UniversalWordEntry(
      wordId: 'word_kommen',
      word: 'kommen',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'come', 'de': 'kommen', 'tr': 'gelmek'},
    ),
    UniversalWordEntry(
      wordId: 'word_machen',
      word: 'machen',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'make', 'de': 'machen', 'tr': 'yapmak'},
    ),
    UniversalWordEntry(
      wordId: 'word_schule',
      word: 'schule',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'school', 'de': 'schule', 'tr': 'okul'},
    ),
    UniversalWordEntry(
      wordId: 'word_familie',
      word: 'familie',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'family', 'de': 'familie', 'tr': 'aile'},
    ),
    UniversalWordEntry(
      wordId: 'word_freund',
      word: 'freund',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'friend', 'de': 'freund', 'tr': 'arkadaş'},
    ),
    UniversalWordEntry(
      wordId: 'word_geld',
      word: 'geld',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'money', 'de': 'geld', 'tr': 'para'},
    ),
    UniversalWordEntry(
      wordId: 'word_nacht',
      word: 'nacht',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'night', 'de': 'nacht', 'tr': 'gece'},
    ),
    UniversalWordEntry(
      wordId: 'word_platz',
      word: 'platz',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'place', 'de': 'platz', 'tr': 'yer'},
    ),
    UniversalWordEntry(
      wordId: 'word_welt',
      word: 'welt',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'world', 'de': 'welt', 'tr': 'dünya'},
    ),
  ];
}

List<UniversalWordEntry> loadTurkishA1Words() {
  return [
    UniversalWordEntry(
      wordId: 'word_ev',
      word: 'ev',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'house', 'de': 'haus', 'tr': 'ev'},
    ),
    UniversalWordEntry(
      wordId: 'word_su',
      word: 'su',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'water', 'de': 'wasser', 'tr': 'su'},
    ),
    UniversalWordEntry(
      wordId: 'word_kitap',
      word: 'kitap',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'book', 'de': 'buch', 'tr': 'kitap'},
    ),
    UniversalWordEntry(
      wordId: 'word_zaman',
      word: 'zaman',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'time', 'de': 'zeit', 'tr': 'zaman'},
    ),
    UniversalWordEntry(
      wordId: 'word_adam',
      word: 'adam',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'man', 'de': 'mann', 'tr': 'adam'},
    ),
    UniversalWordEntry(
      wordId: 'word_kadın',
      word: 'kadın',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'woman', 'de': 'frau', 'tr': 'kadın'},
    ),
    UniversalWordEntry(
      wordId: 'word_çocuk',
      word: 'çocuk',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'child', 'de': 'kind', 'tr': 'çocuk'},
    ),
    UniversalWordEntry(
      wordId: 'word_iyi',
      word: 'iyi',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'good', 'de': 'gut', 'tr': 'iyi'},
    ),
    UniversalWordEntry(
      wordId: 'word_büyük',
      word: 'büyük',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'big', 'de': 'groß', 'tr': 'büyük'},
    ),
    UniversalWordEntry(
      wordId: 'word_küçük',
      word: 'küçük',
      cefrLevel: 'A1',
      category: 'adjective',
      translations: {'en': 'small', 'de': 'klein', 'tr': 'küçük'},
    ),
    UniversalWordEntry(
      wordId: 'word_çalışmak',
      word: 'çalışmak',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'work', 'de': 'arbeiten', 'tr': 'çalışmak'},
    ),
    UniversalWordEntry(
      wordId: 'word_gelmek',
      word: 'gelmek',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'come', 'de': 'kommen', 'tr': 'gelmek'},
    ),
    UniversalWordEntry(
      wordId: 'word_yapmak',
      word: 'yapmak',
      cefrLevel: 'A1',
      category: 'verb',
      translations: {'en': 'make', 'de': 'machen', 'tr': 'yapmak'},
    ),
    UniversalWordEntry(
      wordId: 'word_okul',
      word: 'okul',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'school', 'de': 'schule', 'tr': 'okul'},
    ),
    UniversalWordEntry(
      wordId: 'word_aile',
      word: 'aile',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'family', 'de': 'familie', 'tr': 'aile'},
    ),
    UniversalWordEntry(
      wordId: 'word_arkadaş',
      word: 'arkadaş',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'friend', 'de': 'freund', 'tr': 'arkadaş'},
    ),
    UniversalWordEntry(
      wordId: 'word_para',
      word: 'para',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'money', 'de': 'geld', 'tr': 'para'},
    ),
    UniversalWordEntry(
      wordId: 'word_gece',
      word: 'gece',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'night', 'de': 'nacht', 'tr': 'gece'},
    ),
    UniversalWordEntry(
      wordId: 'word_yer',
      word: 'yer',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'place', 'de': 'platz', 'tr': 'yer'},
    ),
    UniversalWordEntry(
      wordId: 'word_dünya',
      word: 'dünya',
      cefrLevel: 'A1',
      category: 'noun',
      translations: {'en': 'world', 'de': 'welt', 'tr': 'dünya'},
    ),
  ];
}

// Word data loader
class WordDataLoader {
  static List<UniversalWordEntry> getWordsForLanguage(SupportedLanguage language, String cefrLevel) {
    switch (language) {
      case SupportedLanguage.english:
        return loadEnglishA1Words().where((entry) => entry.cefrLevel == cefrLevel).toList();
      case SupportedLanguage.german:
        return loadGermanA1Words().where((entry) => entry.cefrLevel == cefrLevel).toList();
      case SupportedLanguage.turkish:
        return loadTurkishA1Words().where((entry) => entry.cefrLevel == cefrLevel).toList();
    }
  }
}

// Word validator
class WordValidator {
  static bool canFormWord(String sourceWord, String targetWord) {
    final sourceLetters = sourceWord.toLowerCase().split('');
    final targetLetters = targetWord.toLowerCase().split('');

    final sourceCount = <String, int>{};
    for (String letter in sourceLetters) {
      sourceCount[letter] = (sourceCount[letter] ?? 0) + 1;
    }

    final targetCount = <String, int>{};
    for (String letter in targetLetters) {
      targetCount[letter] = (targetCount[letter] ?? 0) + 1;
    }

    for (String letter in targetCount.keys) {
      if ((sourceCount[letter] ?? 0) < targetCount[letter]!) {
        return false;
      }
    }

    return true;
  }

  static List<String> findPossibleWords(String sourceWord, List<String> wordBank) {
    return wordBank
        .where((word) => word.length >= 2 && canFormWord(sourceWord, word))
        .toList();
  }
}

// Level generator
class LevelGenerator {
  static final Set<String> _usedSourceWords = {};
  
  static Map<String, dynamic>? generateLevel(
    int levelId,
    SupportedLanguage targetLanguage,
    SupportedLanguage nativeLanguage,
    String cefrLevel,
  ) {
    try {
      // Get words for target language
      final wordEntries = WordDataLoader.getWordsForLanguage(targetLanguage, cefrLevel);
      if (wordEntries.isEmpty) {
        return null;
      }

      // Get source words (4+ letters for better gameplay)
      final sourceWords = wordEntries
          .where((entry) => entry.word.length >= 4)
          .where((entry) => !_usedSourceWords.contains('${targetLanguage.code}_${entry.word}'))
          .map((entry) => entry.word)
          .toList();

      if (sourceWords.isEmpty) {
        // Reset used words if we've exhausted all options
        _usedSourceWords.clear();
        final allSourceWords = wordEntries
            .where((entry) => entry.word.length >= 4)
            .map((entry) => entry.word)
            .toList();
        if (allSourceWords.isEmpty) return null;
        sourceWords.addAll(allSourceWords);
      }

      // Select a source word based on level ID for consistency
      final random = Random(levelId + targetLanguage.code.hashCode + nativeLanguage.code.hashCode);
      final sourceWord = sourceWords[random.nextInt(sourceWords.length)];
      
      // Mark this source word as used for this target language
      _usedSourceWords.add('${targetLanguage.code}_$sourceWord');

      // Get all words for validation
      final allWords = wordEntries.map((entry) => entry.word).toList();

      // Find possible target words from the source word
      final possibleWords = WordValidator.findPossibleWords(sourceWord, allWords);

      if (possibleWords.length < 2) {
        return null; // Need at least 2 words for a level
      }

      // Select target words (3-5 words depending on available words)
      final targetCount = min(5, max(3, possibleWords.length));
      possibleWords.sort((a, b) => b.length.compareTo(a.length)); // Longer words first
      final targetWords = possibleWords.take(targetCount).toList();

      // Generate hints in native language
      final hints = targetWords.map((word) {
        final wordEntry = wordEntries.firstWhere(
          (entry) => entry.word.toLowerCase() == word.toLowerCase(),
          orElse: () => UniversalWordEntry(
            wordId: 'unknown',
            word: word,
            cefrLevel: cefrLevel,
            category: 'unknown',
            translations: {targetLanguage.code: word},
          ),
        );
        return wordEntry.getTranslation(nativeLanguage.code);
      }).join(' | ');

      return {
        'levelId': levelId,
        'sourceWord': sourceWord.toUpperCase(),
        'targetWords': targetWords.map((w) => w.toUpperCase()).toList(),
        'hints': hints,
        'validWords': possibleWords.map((w) => w.toLowerCase()).toList(),
        'difficulty': _calculateDifficulty(sourceWord, targetWords),
      };
    } catch (e) {
      print('Error generating level $levelId: $e');
      return null;
    }
  }

  static int _calculateDifficulty(String sourceWord, List<String> targetWords) {
    final avgTargetLength = targetWords.fold<double>(0, (sum, word) => sum + word.length) / targetWords.length;
    final wordCount = targetWords.length;
    
    final lengthScore = (avgTargetLength / sourceWord.length * 5).round();
    final countScore = (wordCount / 2).round();
    
    return max(1, min(10, lengthScore + countScore));
  }
}

// Main function
Future<void> main() async {
  print('🚀 Starting Universal Level Generation...');
  
  // Create assets/levels directory if it doesn't exist
  final levelsDir = Directory('assets/levels');
  if (!await levelsDir.exists()) {
    await levelsDir.create(recursive: true);
  }

  // Generate levels for each language combination
  final languages = [
    SupportedLanguage.english,
    SupportedLanguage.german,
    SupportedLanguage.turkish,
  ];

  final cefrLevels = ['A1']; // Start with A1, can expand later
  int totalGenerated = 0;

  for (final targetLanguage in languages) {
    for (final nativeLanguage in languages) {
      if (targetLanguage == nativeLanguage) continue; // Skip same language combinations
      
      for (final cefrLevel in cefrLevels) {
        final generated = await generateLevelsForCombination(
          targetLanguage: targetLanguage,
          nativeLanguage: nativeLanguage,
          cefrLevel: cefrLevel,
        );
        totalGenerated += generated;
      }
    }
  }

  print('✅ Level generation completed!');
  print('📊 Total levels generated: $totalGenerated');
  print('📁 Files saved in: assets/levels/');
}

Future<int> generateLevelsForCombination({
  required SupportedLanguage targetLanguage,
  required SupportedLanguage nativeLanguage,
  required String cefrLevel,
}) async {
  print('📝 Generating levels for ${targetLanguage.code}_${cefrLevel} (hints in ${nativeLanguage.code})...');

  // Generate levels
  final levels = <Map<String, dynamic>>[];
  
  // Generate up to 100 levels per combination
  for (int i = 1; i <= 100; i++) {
    final levelData = LevelGenerator.generateLevel(
      i,
      targetLanguage,
      nativeLanguage,
      cefrLevel,
    );
    
    if (levelData != null) {
      levels.add(levelData);
    }
    
    // Stop if we can't generate more unique levels
    if (levels.length > 0 && i > levels.length + 20) {
      break;
    }
  }

  if (levels.isEmpty) {
    print('⚠️  No levels generated for ${targetLanguage.code}_${cefrLevel} (hints in ${nativeLanguage.code})');
    return 0;
  }

  // Save to JSON file - one file per language and CEFR level combination
  final fileName = '${targetLanguage.code}_${cefrLevel.toLowerCase()}_levels_${nativeLanguage.code}.json';
  final file = File('assets/levels/$fileName');
  
  final jsonData = {
    'metadata': {
      'targetLanguage': targetLanguage.code,
      'nativeLanguage': nativeLanguage.code,
      'cefrLevel': cefrLevel,
      'totalLevels': levels.length,
      'generatedAt': DateTime.now().toIso8601String(),
    },
    'levels': levels,
  };
  
  await file.writeAsString(JsonEncoder.withIndent('  ').convert(jsonData));
  print('✅ Generated ${levels.length} levels -> $fileName');
  
  return levels.length;
}