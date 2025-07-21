import 'lib/services/multilingual_word_bank.dart';
import 'lib/providers/language_provider.dart';

void main() {
  print('🔍 Debugging German Source Words Issue...\n');
  
  // Test 1: Check word bank
  print('1️⃣ Testing German Word Bank:');
  final wordBank = MultilingualWordBank.getWordBank(
    targetLanguage: SupportedLanguage.german,
    cefrLevel: 'A1',
    nativeLanguage: SupportedLanguage.english,
  );
  
  print('Word bank size: ${wordBank.length}');
  if (wordBank.isNotEmpty) {
    print('First 5 words:');
    for (int i = 0; i < 5 && i < wordBank.length; i++) {
      final word = wordBank[i];
      print('  ${word['word']} (${(word['word'] as String).length} letters) -> ${word['translation']}');
    }
  } else {
    print('❌ Word bank is EMPTY!');
  }
  
  // Test 2: Check source words
  print('\n2️⃣ Testing Source Words (4+ letters):');
  final sourceWords = MultilingualWordBank.getSourceWordsForLevel(
    targetLanguage: SupportedLanguage.german,
    cefrLevel: 'A1',
  );
  
  print('Source words count: ${sourceWords.length}');
  if (sourceWords.isNotEmpty) {
    print('First 10 source words: ${sourceWords.take(10).join(', ')}');
  } else {
    print('❌ Source words list is EMPTY!');
  }
  
  // Test 3: Check all words and their lengths
  print('\n3️⃣ Analyzing Word Lengths:');
  final allWords = wordBank.map((w) => w['word'] as String).toList();
  final wordsByLength = <int, List<String>>{};
  
  for (final word in allWords) {
    final length = word.length;
    wordsByLength[length] ??= [];
    wordsByLength[length]!.add(word);
  }
  
  for (final length in wordsByLength.keys.toList()..sort()) {
    final words = wordsByLength[length]!;
    print('  ${length} letters: ${words.length} words (${words.take(5).join(', ')}${words.length > 5 ? '...' : ''})');
  }
  
  // Test 4: Check 4+ letter words specifically
  print('\n4️⃣ Words with 4+ letters:');
  final longWords = allWords.where((word) => word.length >= 4).toList();
  print('Count: ${longWords.length}');
  print('Examples: ${longWords.take(10).join(', ')}');
  
  if (sourceWords.isEmpty) {
    print('\n❌ PROBLEM IDENTIFIED: Source words list is empty!');
    print('This is why the level generator falls back to EINFACH.');
  } else {
    print('\n✅ Source words are available. The issue might be elsewhere.');
  }
}