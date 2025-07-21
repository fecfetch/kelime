/// Universal word entry with multi-language translation support
class UniversalWordEntry {
  final String wordId;
  final String word;
  final String cefrLevel;
  final String category;
  final Map<String, String> translations;
  final int difficulty;

  const UniversalWordEntry({
    required this.wordId,
    required this.word,
    required this.cefrLevel,
    required this.category,
    required this.translations,
    this.difficulty = 1,
  });

  /// Get translation in specified language
  String getTranslation(String languageCode) {
    return translations[languageCode] ?? translations['en'] ?? word;
  }

  /// Check if translation exists for language
  bool hasTranslation(String languageCode) {
    return translations.containsKey(languageCode);
  }

  /// Convert to legacy format for compatibility
  Map<String, dynamic> toLegacyFormat(String nativeLanguageCode) {
    return {
      'word': word,
      'translation': getTranslation(nativeLanguageCode),
      'wordId': wordId,
      'category': category,
      'difficulty': difficulty,
    };
  }
}