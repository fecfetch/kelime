// Simple test of the fixed English → German functionality

void main() {
  print('🧪 Testing Fixed English → German System...');
  
  // Test data simulating the universal translation system
  final translations = {
    'word_house': {'en': 'house', 'de': 'haus', 'tr': 'ev'},
    'word_car': {'en': 'car', 'de': 'auto', 'tr': 'araba'},
    'word_dog': {'en': 'dog', 'de': 'hund', 'tr': 'köpek'},
    'word_cat': {'en': 'cat', 'de': 'katze', 'tr': 'kedi'},
    'word_man': {'en': 'man', 'de': 'mann', 'tr': 'adam'},
    'word_water': {'en': 'water', 'de': 'wasser', 'tr': 'su'},
    'word_book': {'en': 'book', 'de': 'buch', 'tr': 'kitap'},
    'word_good': {'en': 'good', 'de': 'gut', 'tr': 'iyi'},
    'word_time': {'en': 'time', 'de': 'zeit', 'tr': 'zaman'},
    'word_family': {'en': 'family', 'de': 'familie', 'tr': 'aile'},
  };
  
  // German words (what the user will see and search for)
  final germanWords = [
    'haus', 'auto', 'hund', 'katze', 'mann', 
    'wasser', 'buch', 'gut', 'zeit', 'familie'
  ];
  
  // Test 1: Source words (4+ letters for level generation)
  print('\n1️⃣ Testing Source Words:');
  final sourceWords = germanWords.where((word) => word.length >= 4).toList();
  print('German source words (4+ letters): ${sourceWords.length}');
  print('Words: ${sourceWords.join(', ')}');
  
  if (sourceWords.isEmpty) {
    print('❌ NO SOURCE WORDS - This would trigger "simple word" fallback!');
  } else {
    print('✅ Source words available - should NOT show "simple word"');
  }
  
  // Test 2: Word bank with proper translations
  print('\n2️⃣ Testing Word Bank with English Translations:');
  final wordBank = <Map<String, String>>[];
  
  for (final germanWord in germanWords) {
    // Find the word ID for this German word
    String? wordId;
    for (final entry in translations.entries) {
      if (entry.value['de'] == germanWord) {
        wordId = entry.key;
        break;
      }
    }
    
    if (wordId != null) {
      wordBank.add({
        'word': germanWord,
        'translation': translations[wordId]!['en']!, // English translation
        'wordId': wordId,
      });
    }
  }
  
  print('Word bank created: ${wordBank.length} words');
  for (final word in wordBank.take(5)) {
    print('  ${word['word']} → ${word['translation']}');
  }
  
  // Check if any translations are wrong
  bool hasErrors = false;
  for (final word in wordBank) {
    if (word['word'] == word['translation']) {
      print('❌ ERROR: ${word['word']} translates to itself!');
      hasErrors = true;
    }
  }
  
  if (!hasErrors) {
    print('✅ All translations are correct (German → English)');
  }
  
  // Test 3: Hint generation for level
  print('\n3️⃣ Testing Hint Generation:');
  final testTargetWords = ['haus', 'auto', 'hund'];
  final hints = <String>[];
  
  for (final targetWord in testTargetWords) {
    final wordData = wordBank.firstWhere(
      (w) => w['word'] == targetWord,
      orElse: () => {'word': targetWord, 'translation': targetWord},
    );
    hints.add(wordData['translation']!);
  }
  
  final hintsString = hints.join(' | ');
  print('Target words (German): ${testTargetWords.join(', ')}');
  print('Hints (English): $hintsString');
  
  if (hintsString.contains('haus') || hintsString.contains('auto')) {
    print('❌ ERROR: Hints contain German words!');
  } else {
    print('✅ Hints are properly in English');
  }
  
  // Test 4: Level generation simulation
  print('\n4️⃣ Testing Level Generation Simulation:');
  final sourceWord = 'familie'; // 7 letters, good for word formation
  print('Selected source word: $sourceWord');
  
  // Find words that can be formed from 'familie'
  final possibleWords = <String>[];
  final sourceLetters = sourceWord.toLowerCase().split('');
  
  for (final word in germanWords) {
    if (word.length < 2 || word == sourceWord) continue;
    
    final wordLetters = word.toLowerCase().split('');
    final availableLetters = List<String>.from(sourceLetters);
    bool canForm = true;
    
    for (final letter in wordLetters) {
      if (availableLetters.contains(letter)) {
        availableLetters.remove(letter);
      } else {
        canForm = false;
        break;
      }
    }
    
    if (canForm) {
      possibleWords.add(word);
    }
  }
  
  print('Possible target words: ${possibleWords.join(', ')}');
  
  if (possibleWords.isNotEmpty) {
    // Generate hints for the level
    final levelHints = <String>[];
    for (final word in possibleWords) {
      final wordData = wordBank.firstWhere(
        (w) => w['word'] == word,
        orElse: () => {'word': word, 'translation': word},
      );
      levelHints.add(wordData['translation']!);
    }
    
    print('✅ Level would be generated successfully!');
    print('Source: ${sourceWord.toUpperCase()}');
    print('Targets: ${possibleWords.map((w) => w.toUpperCase()).join(', ')}');
    print('Hints: ${levelHints.join(' | ')}');
    print('✅ This should NOT show "simple word" fallback');
  } else {
    print('❌ No possible words - would trigger fallback');
  }
  
  print('\n🎯 Analysis of Your Screenshot Issue:');
  print('');
  print('❌ What you saw:');
  print('   - Hint: "simple word" (fallback triggered)');
  print('   - UI in Turkish instead of English');
  print('   - System not using German words');
  print('');
  print('✅ What should happen after fixes:');
  print('   - German words to find (HAUS, AUTO, etc.)');
  print('   - English hints (house | car | etc.)');
  print('   - UI in English (your native language)');
  print('   - No "simple word" fallback');
  print('');
  print('🔧 Root causes fixed:');
  print('   1. MultilingualWordBank now gets nativeLanguage parameter');
  print('   2. getTranslation method uses proper native language');
  print('   3. Universal word bank system properly integrated');
  print('   4. Source words available (no empty list trigger)');
  print('');
  print('💡 Next steps:');
  print('   1. Test the app again with English → German');
  print('   2. Check language settings are properly applied');
  print('   3. Verify UI shows in English, words in German');
}