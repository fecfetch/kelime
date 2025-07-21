import '../providers/language_provider.dart';
import 'universal_translations.dart';

/// Universal word bank entry structure
class UniversalWordEntry {
  final String wordId;
  final String targetLanguage;
  final String word;
  final String cefrLevel;
  final String category;
  final int difficulty;

  const UniversalWordEntry({
    required this.wordId,
    required this.targetLanguage,
    required this.word,
    required this.cefrLevel,
    required this.category,
    this.difficulty = 1,
  });

  /// Get translation in specified language
  String getTranslation(String languageCode) {
    return UniversalTranslations.getTranslation(wordId, languageCode);
  }

  /// Convert to map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'wordId': wordId,
      'targetLanguage': targetLanguage,
      'word': word,
      'cefrLevel': cefrLevel,
      'category': category,
      'difficulty': difficulty,
    };
  }

  /// Create from map for JSON deserialization
  factory UniversalWordEntry.fromMap(Map<String, dynamic> map) {
    return UniversalWordEntry(
      wordId: map['wordId'] as String,
      targetLanguage: map['targetLanguage'] as String,
      word: map['word'] as String,
      cefrLevel: map['cefrLevel'] as String,
      category: map['category'] as String,
      difficulty: map['difficulty'] as int? ?? 1,
    );
  }
}

/// Universal word bank - organized by target language and CEFR level
class UniversalWordBank {
  // English word bank (target language: English)
  static final List<UniversalWordEntry> englishA1 = [
    const UniversalWordEntry(
        wordId: 'word_i',
        targetLanguage: 'en',
        word: 'I',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_you',
        targetLanguage: 'en',
        word: 'you',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_he',
        targetLanguage: 'en',
        word: 'he',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_she',
        targetLanguage: 'en',
        word: 'she',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_it',
        targetLanguage: 'en',
        word: 'it',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_we',
        targetLanguage: 'en',
        word: 'we',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_they',
        targetLanguage: 'en',
        word: 'they',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_be',
        targetLanguage: 'en',
        word: 'be',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_have',
        targetLanguage: 'en',
        word: 'have',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_do',
        targetLanguage: 'en',
        word: 'do',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_go',
        targetLanguage: 'en',
        word: 'go',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_come',
        targetLanguage: 'en',
        word: 'come',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_see',
        targetLanguage: 'en',
        word: 'see',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_know',
        targetLanguage: 'en',
        word: 'know',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_get',
        targetLanguage: 'en',
        word: 'get',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_give',
        targetLanguage: 'en',
        word: 'give',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_take',
        targetLanguage: 'en',
        word: 'take',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_house',
        targetLanguage: 'en',
        word: 'house',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_car',
        targetLanguage: 'en',
        word: 'car',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_dog',
        targetLanguage: 'en',
        word: 'dog',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_cat',
        targetLanguage: 'en',
        word: 'cat',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_man',
        targetLanguage: 'en',
        word: 'man',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_woman',
        targetLanguage: 'en',
        word: 'woman',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_child',
        targetLanguage: 'en',
        word: 'child',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_book',
        targetLanguage: 'en',
        word: 'book',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_water',
        targetLanguage: 'en',
        word: 'water',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_food',
        targetLanguage: 'en',
        word: 'food',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_good',
        targetLanguage: 'en',
        word: 'good',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_bad',
        targetLanguage: 'en',
        word: 'bad',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_big',
        targetLanguage: 'en',
        word: 'big',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_small',
        targetLanguage: 'en',
        word: 'small',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_new',
        targetLanguage: 'en',
        word: 'new',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_old',
        targetLanguage: 'en',
        word: 'old',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_red',
        targetLanguage: 'en',
        word: 'red',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_blue',
        targetLanguage: 'en',
        word: 'blue',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_green',
        targetLanguage: 'en',
        word: 'green',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_yellow',
        targetLanguage: 'en',
        word: 'yellow',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_black',
        targetLanguage: 'en',
        word: 'black',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_white',
        targetLanguage: 'en',
        word: 'white',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_one',
        targetLanguage: 'en',
        word: 'one',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_two',
        targetLanguage: 'en',
        word: 'two',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_three',
        targetLanguage: 'en',
        word: 'three',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_four',
        targetLanguage: 'en',
        word: 'four',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_five',
        targetLanguage: 'en',
        word: 'five',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_time',
        targetLanguage: 'en',
        word: 'time',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_day',
        targetLanguage: 'en',
        word: 'day',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_night',
        targetLanguage: 'en',
        word: 'night',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_year',
        targetLanguage: 'en',
        word: 'year',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_today',
        targetLanguage: 'en',
        word: 'today',
        cefrLevel: 'A1',
        category: 'adverb'),
    const UniversalWordEntry(
        wordId: 'word_family',
        targetLanguage: 'en',
        word: 'family',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_mother',
        targetLanguage: 'en',
        word: 'mother',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_father',
        targetLanguage: 'en',
        word: 'father',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_son',
        targetLanguage: 'en',
        word: 'son',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_daughter',
        targetLanguage: 'en',
        word: 'daughter',
        cefrLevel: 'A1',
        category: 'noun'),
  ];

  // German word bank (target language: German)
  static final List<UniversalWordEntry> germanA1 = [
    const UniversalWordEntry(
        wordId: 'word_i',
        targetLanguage: 'de',
        word: 'ich',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_you',
        targetLanguage: 'de',
        word: 'du',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_he',
        targetLanguage: 'de',
        word: 'er',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_she',
        targetLanguage: 'de',
        word: 'sie',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_it',
        targetLanguage: 'de',
        word: 'es',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_we',
        targetLanguage: 'de',
        word: 'wir',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_they',
        targetLanguage: 'de',
        word: 'sie',
        cefrLevel: 'A1',
        category: 'pronoun'),
    const UniversalWordEntry(
        wordId: 'word_be',
        targetLanguage: 'de',
        word: 'sein',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_have',
        targetLanguage: 'de',
        word: 'haben',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_do',
        targetLanguage: 'de',
        word: 'machen',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_go',
        targetLanguage: 'de',
        word: 'gehen',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_come',
        targetLanguage: 'de',
        word: 'kommen',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_see',
        targetLanguage: 'de',
        word: 'sehen',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_know',
        targetLanguage: 'de',
        word: 'wissen',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_get',
        targetLanguage: 'de',
        word: 'bekommen',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_give',
        targetLanguage: 'de',
        word: 'geben',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_take',
        targetLanguage: 'de',
        word: 'nehmen',
        cefrLevel: 'A1',
        category: 'verb'),
    const UniversalWordEntry(
        wordId: 'word_house',
        targetLanguage: 'de',
        word: 'haus',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_car',
        targetLanguage: 'de',
        word: 'auto',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_dog',
        targetLanguage: 'de',
        word: 'hund',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_cat',
        targetLanguage: 'de',
        word: 'katze',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_man',
        targetLanguage: 'de',
        word: 'mann',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_woman',
        targetLanguage: 'de',
        word: 'frau',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_child',
        targetLanguage: 'de',
        word: 'kind',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_book',
        targetLanguage: 'de',
        word: 'buch',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_water',
        targetLanguage: 'de',
        word: 'wasser',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_food',
        targetLanguage: 'de',
        word: 'essen',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_good',
        targetLanguage: 'de',
        word: 'gut',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_bad',
        targetLanguage: 'de',
        word: 'schlecht',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_big',
        targetLanguage: 'de',
        word: 'groß',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_small',
        targetLanguage: 'de',
        word: 'klein',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_new',
        targetLanguage: 'de',
        word: 'neu',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_old',
        targetLanguage: 'de',
        word: 'alt',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_red',
        targetLanguage: 'de',
        word: 'rot',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_blue',
        targetLanguage: 'de',
        word: 'blau',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_green',
        targetLanguage: 'de',
        word: 'grün',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_yellow',
        targetLanguage: 'de',
        word: 'gelb',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_black',
        targetLanguage: 'de',
        word: 'schwarz',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_white',
        targetLanguage: 'de',
        word: 'weiß',
        cefrLevel: 'A1',
        category: 'adjective'),
    const UniversalWordEntry(
        wordId: 'word_one',
        targetLanguage: 'de',
        word: 'eins',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_two',
        targetLanguage: 'de',
        word: 'zwei',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_three',
        targetLanguage: 'de',
        word: 'drei',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_four',
        targetLanguage: 'de',
        word: 'vier',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_five',
        targetLanguage: 'de',
        word: 'fünf',
        cefrLevel: 'A1',
        category: 'number'),
    const UniversalWordEntry(
        wordId: 'word_time',
        targetLanguage: 'de',
        word: 'zeit',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_day',
        targetLanguage: 'de',
        word: 'tag',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_night',
        targetLanguage: 'de',
        word: 'nacht',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_year',
        targetLanguage: 'de',
        word: 'jahr',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_today',
        targetLanguage: 'de',
        word: 'heute',
        cefrLevel: 'A1',
        category: 'adverb'),
    const UniversalWordEntry(
        wordId: 'word_family',
        targetLanguage: 'de',
        word: 'familie',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_mother',
        targetLanguage: 'de',
        word: 'mutter',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_father',
        targetLanguage: 'de',
        word: 'vater',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_son',
        targetLanguage: 'de',
        word: 'sohn',
        cefrLevel: 'A1',
        category: 'noun'),
    const UniversalWordEntry(
        wordId: 'word_daughter',
        targetLanguage: 'de',
        word: 'tochter',
        cefrLevel: 'A1',
        category: 'noun'),
  ];

  /// Get word bank for specific target language and CEFR level
  static List<UniversalWordEntry> getWordBank({
    required SupportedLanguage targetLanguage,
    required String cefrLevel,
  }) {
    switch (targetLanguage) {
      case SupportedLanguage.english:
        return _getEnglishWordBank(cefrLevel);
      case SupportedLanguage.german:
        return _getGermanWordBank(cefrLevel);
      default:
        return _getEnglishWordBank(cefrLevel); // Fallback
    }
  }

  /// Get English word bank for CEFR level
  static List<UniversalWordEntry> _getEnglishWordBank(String cefrLevel) {
    switch (cefrLevel) {
      case 'A1':
        return englishA1;
      case 'A2':
        return [...englishA1]; // Add A2 words when created
      case 'B1':
        return [...englishA1]; // Add B1 words when created
      case 'B2':
        return [...englishA1]; // Add B2 words when created
      case 'C1':
        return [...englishA1]; // Add C1 words when created
      case 'C2':
        return [...englishA1]; // Add C2 words when created
      case 'MIXED':
        return [...englishA1]; // Mix all levels when created
      default:
        return englishA1;
    }
  }

  /// Get German word bank for CEFR level
  static List<UniversalWordEntry> _getGermanWordBank(String cefrLevel) {
    switch (cefrLevel) {
      case 'A1':
        return germanA1;
      case 'A2':
        return [...germanA1]; // Add A2 words when created
      case 'B1':
        return [...germanA1]; // Add B1 words when created
      case 'B2':
        return [...germanA1]; // Add B2 words when created
      case 'C1':
        return [...germanA1]; // Add C1 words when created
      case 'C2':
        return [...germanA1]; // Add C2 words when created
      case 'MIXED':
        return [...germanA1]; // Mix all levels when created
      default:
        return germanA1;
    }
  }

  /// Get source words for level generation (4+ letters)
  static List<String> getSourceWordsForLevel({
    required SupportedLanguage targetLanguage,
    required String cefrLevel,
  }) {
    final wordBank = getWordBank(
      targetLanguage: targetLanguage,
      cefrLevel: cefrLevel,
    );

    return wordBank
        .map((entry) => entry.word)
        .where((word) => word.length >= 4) // Minimum 4 letters for source words
        .toList();
  }

  /// Generate hints for target words in native language
  static String generateHints({
    required List<String> targetWords,
    required SupportedLanguage targetLanguage,
    required SupportedLanguage nativeLanguage,
    required String cefrLevel,
  }) {
    final wordBank = getWordBank(
      targetLanguage: targetLanguage,
      cefrLevel: cefrLevel,
    );

    final hints = targetWords.map((word) {
      // Find the word entry
      final wordEntry = wordBank.firstWhere(
        (entry) => entry.word.toLowerCase() == word.toLowerCase(),
        orElse: () => UniversalWordEntry(
          wordId: 'unknown',
          targetLanguage: targetLanguage.code,
          word: word.toLowerCase(),
          cefrLevel: cefrLevel,
          category: 'unknown',
        ),
      );

      // Get translation in native language
      return wordEntry.getTranslation(nativeLanguage.code);
    }).join(' | ');

    return hints;
  }

  /// Get all words for validation (target language words)
  static List<String> getAllWordsForValidation({
    required SupportedLanguage targetLanguage,
    required String cefrLevel,
  }) {
    final wordBank = getWordBank(
      targetLanguage: targetLanguage,
      cefrLevel: cefrLevel,
    );

    return wordBank.map((entry) => entry.word).toList();
  }
}
