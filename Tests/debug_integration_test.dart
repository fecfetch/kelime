// Test the actual integration without Flutter dependencies

// Copy the exact enum from the real code
enum SupportedLanguage {
  english('en', 'English'),
  german('de', 'Deutsch'),
  french('fr', 'Français'),
  spanish('es', 'Español'),
  turkish('tr', 'Türkçe'),
  portuguese('pt', 'Português'),
  italian('it', 'Italiano');

  const SupportedLanguage(this.code, this.nativeName);

  final String code;
  final String nativeName;

  static SupportedLanguage fromCode(String code) {
    return SupportedLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => SupportedLanguage.english,
    );
  }
}

// Simulate the exact _getGermanWordBankLegacy method
List<Map<String, dynamic>> getGermanWordBankLegacy(String cefrLevel,
    [SupportedLanguage? nativeLanguage]) {
  // Default to English if no native language specified
  nativeLanguage ??= SupportedLanguage.english;

  // Comprehensive German word bank with translations based on native language
  final baseWords = [
    // Basic pronouns and articles (short words for word formation)
    {'word': 'ich', 'translation': 'I'},
    {'word': 'du', 'translation': 'you'},
    {'word': 'er', 'translation': 'he'},
    {'word': 'sie', 'translation': 'she'},
    {'word': 'es', 'translation': 'it'},
    {'word': 'wir', 'translation': 'we'},
    {'word': 'ihr', 'translation': 'you (plural)'},
    {'word': 'der', 'translation': 'the (masculine)'},
    {'word': 'die', 'translation': 'the (feminine)'},
    {'word': 'das', 'translation': 'the (neuter)'},
    {'word': 'ein', 'translation': 'a/an'},
    {'word': 'eine', 'translation': 'a/an (feminine)'},
    {'word': 'und', 'translation': 'and'},
    {'word': 'oder', 'translation': 'or'},
    {'word': 'aber', 'translation': 'but'},
    {'word': 'nicht', 'translation': 'not'},
    {'word': 'ja', 'translation': 'yes'},
    {'word': 'nein', 'translation': 'no'},

    // Basic nouns (4+ letters for good source words)
    {'word': 'haus', 'translation': 'house'},
    {'word': 'auto', 'translation': 'car'},
    {'word': 'hund', 'translation': 'dog'},
    {'word': 'katze', 'translation': 'cat'},
    {'word': 'kind', 'translation': 'child'},
    {'word': 'mann', 'translation': 'man'},
    {'word': 'frau', 'translation': 'woman'},
    {'word': 'buch', 'translation': 'book'},
    {'word': 'tisch', 'translation': 'table'},
    {'word': 'stuhl', 'translation': 'chair'},
    {'word': 'bett', 'translation': 'bed'},
    {'word': 'fenster', 'translation': 'window'},
    {'word': 'wasser', 'translation': 'water'},
    {'word': 'brot', 'translation': 'bread'},
    {'word': 'milch', 'translation': 'milk'},
    {'word': 'käse', 'translation': 'cheese'},
    {'word': 'fleisch', 'translation': 'meat'},
    {'word': 'fisch', 'translation': 'fish'},
    {'word': 'apfel', 'translation': 'apple'},
    {'word': 'bier', 'translation': 'beer'},
    {'word': 'wein', 'translation': 'wine'},
    {'word': 'kaffee', 'translation': 'coffee'},

    // Basic verbs
    {'word': 'sein', 'translation': 'to be'},
    {'word': 'haben', 'translation': 'to have'},
    {'word': 'gehen', 'translation': 'to go'},
    {'word': 'kommen', 'translation': 'to come'},
    {'word': 'sehen', 'translation': 'to see'},
    {'word': 'hören', 'translation': 'to hear'},
    {'word': 'essen', 'translation': 'to eat'},
    {'word': 'trinken', 'translation': 'to drink'},
    {'word': 'schlafen', 'translation': 'to sleep'},
    {'word': 'arbeiten', 'translation': 'to work'},
    {'word': 'lernen', 'translation': 'to learn'},
    {'word': 'sprechen', 'translation': 'to speak'},
    {'word': 'lesen', 'translation': 'to read'},
    {'word': 'schreiben', 'translation': 'to write'},
    {'word': 'kaufen', 'translation': 'to buy'},
    {'word': 'fahren', 'translation': 'to drive'},
    {'word': 'laufen', 'translation': 'to run'},
    {'word': 'sitzen', 'translation': 'to sit'},
    {'word': 'stehen', 'translation': 'to stand'},
  ];

  return baseWords;
}

// Simulate the getWordBank method
List<Map<String, dynamic>> getWordBank({
  required SupportedLanguage targetLanguage,
  required String cefrLevel,
  SupportedLanguage? nativeLanguage,
}) {
  // Use legacy system directly for now (universal system needs more work)
  switch (targetLanguage) {
    case SupportedLanguage.german:
      return getGermanWordBankLegacy(cefrLevel, nativeLanguage);
    case SupportedLanguage.english:
      return []; // Not implemented for this test
    default:
      return []; // Not implemented for this test
  }
}

// Simulate the getSourceWordsForLevel method
List<String> getSourceWordsForLevel({
  required SupportedLanguage targetLanguage,
  required String cefrLevel,
}) {
  final wordBank = getWordBank(
    targetLanguage: targetLanguage,
    cefrLevel: cefrLevel,
    nativeLanguage:
        SupportedLanguage.english, // Default for source word selection
  );

  return wordBank
      .map((w) => w['word'] as String)
      .where((word) => word.length >= 4) // Minimum 4 letters for source words
      .toList();
}

void main() {
  print('🔍 Testing Actual Integration...\n');

  // Test the exact same call that the level generator makes
  print('1️⃣ Testing getWordBank call:');
  final wordBank = getWordBank(
    targetLanguage: SupportedLanguage.german,
    cefrLevel: 'A1',
    nativeLanguage: SupportedLanguage.english,
  );

  print('Word bank size: ${wordBank.length}');
  if (wordBank.isEmpty) {
    print('❌ PROBLEM: getWordBank returned EMPTY list!');
  } else {
    print('✅ getWordBank returned ${wordBank.length} words');
    print(
        'First 5 words: ${wordBank.take(5).map((w) => w['word']).join(', ')}');
  }

  // Test the exact same call that the level generator makes for source words
  print('\n2️⃣ Testing getSourceWordsForLevel call:');
  final sourceWords = getSourceWordsForLevel(
    targetLanguage: SupportedLanguage.german,
    cefrLevel: 'A1',
  );

  print('Source words count: ${sourceWords.length}');
  if (sourceWords.isEmpty) {
    print('❌ PROBLEM: getSourceWordsForLevel returned EMPTY list!');
    print('This is why the level generator falls back to EINFACH.');
  } else {
    print('✅ getSourceWordsForLevel returned ${sourceWords.length} words');
    print('First 10 source words: ${sourceWords.take(10).join(', ')}');
  }

  // Test the filtering logic
  print('\n3️⃣ Testing filtering logic:');
  final allWords = wordBank.map((w) => w['word'] as String).toList();
  final filteredWords = allWords.where((word) => word.length >= 4).toList();

  print('All words: ${allWords.length}');
  print('Words with 4+ letters: ${filteredWords.length}');
  print('Filtered words: ${filteredWords.take(10).join(', ')}');

  print('\n🎯 Diagnosis:');
  if (wordBank.isEmpty) {
    print('The issue is in getWordBank() - it\'s returning an empty list.');
    print('Check the switch statement and _getGermanWordBankLegacy method.');
  } else if (sourceWords.isEmpty) {
    print('The issue is in the filtering logic - no words are 4+ letters.');
    print('But this shouldn\'t happen based on our word bank.');
  } else {
    print('The integration is working correctly!');
    print('The issue must be elsewhere - possibly in the actual Flutter app.');
  }
}
