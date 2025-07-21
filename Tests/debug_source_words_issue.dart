// Debug the source words issue without Flutter dependencies

enum SupportedLanguage {
  english('en', 'English'),
  german('de', 'Deutsch'),
  turkish('tr', 'Türkçe');

  const SupportedLanguage(this.code, this.nativeName);
  
  final String code;
  final String nativeName;
}

// Simulate the German word bank from multilingual_word_bank.dart
List<Map<String, dynamic>> getGermanWordBank() {
  return [
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
}

// Simulate the getSourceWordsForLevel method
List<String> getSourceWordsForLevel() {
  final wordBank = getGermanWordBank();
  
  return wordBank
      .map((w) => w['word'] as String)
      .where((word) => word.length >= 4) // Minimum 4 letters for source words
      .toList();
}

void main() {
  print('🔍 Debugging Source Words Issue...\n');
  
  // Test 1: Check German word bank
  print('1️⃣ German Word Bank:');
  final wordBank = getGermanWordBank();
  print('Total words: ${wordBank.length}');
  
  // Test 2: Check word lengths
  print('\n2️⃣ Word Length Analysis:');
  final wordsByLength = <int, List<String>>{};
  
  for (final wordData in wordBank) {
    final word = wordData['word'] as String;
    final length = word.length;
    wordsByLength[length] ??= [];
    wordsByLength[length]!.add(word);
  }
  
  for (final length in wordsByLength.keys.toList()..sort()) {
    final words = wordsByLength[length]!;
    print('  ${length} letters: ${words.length} words (${words.take(5).join(', ')}${words.length > 5 ? '...' : ''})');
  }
  
  // Test 3: Check source words (4+ letters)
  print('\n3️⃣ Source Words (4+ letters):');
  final sourceWords = getSourceWordsForLevel();
  print('Source words count: ${sourceWords.length}');
  
  if (sourceWords.isEmpty) {
    print('❌ PROBLEM: Source words list is EMPTY!');
    print('This explains why the level generator falls back to EINFACH.');
  } else {
    print('✅ Source words found:');
    print('First 10: ${sourceWords.take(10).join(', ')}');
    print('All source words: ${sourceWords.join(', ')}');
  }
  
  // Test 4: Check specific words
  print('\n4️⃣ Checking Specific Words:');
  final testWords = ['haus', 'auto', 'hund', 'katze', 'wasser', 'buch'];
  for (final word in testWords) {
    final length = word.length;
    final isSourceWord = length >= 4;
    print('  $word: ${length} letters -> ${isSourceWord ? '✅ Valid source word' : '❌ Too short'}');
  }
  
  print('\n🎯 Conclusion:');
  if (sourceWords.isEmpty) {
    print('The issue is that NO German words are 4+ letters long in the word bank.');
    print('This causes sourceWords.isEmpty to be true, triggering the EINFACH fallback.');
  } else {
    print('Source words are available. The issue must be elsewhere in the integration.');
  }
}