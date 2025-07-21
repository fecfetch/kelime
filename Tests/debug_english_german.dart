// Debug script to test English → German level generation

import 'lib/providers/language_provider.dart';
import 'lib/services/multilingual_word_bank.dart';
import 'lib/data/universal_word_bank.dart';

void main() {
  print('🔍 Debugging English → German Level Generation...');
  
  // Test 1: Check if universal word bank has German words
  print('\n1️⃣ Testing Universal Word Bank:');
  try {
    final germanWords = UniversalWordBank.getWordBank(
      targetLanguage: SupportedLanguage.german,
      cefrLevel: 'A1',
    );
    print('✅ German A1 words found: ${germanWords.length}');
    print('   First 5 words: ${germanWords.take(5).map((e) => e.word).join(', ')}');
    
    // Test translation
    final firstWord = germanWords.first;
    print('   "${firstWord.word}" in English: ${firstWord.getTranslation('en')}');
    print('   "${firstWord.word}" in Turkish: ${firstWord.getTranslation('tr')}');
  } catch (e) {
    print('❌ Universal word bank failed: $e');
  }
  
  // Test 2: Check multilingual word bank
  print('\n2️⃣ Testing Multilingual Word Bank:');
  try {
    final wordBank = MultilingualWordBank.getWordBank(
      targetLanguage: SupportedLanguage.german,
      cefrLevel: 'A1',
      nativeLanguage: SupportedLanguage.english,
    );
    print('✅ Multilingual word bank works: ${wordBank.length} words');
    print('   First word: ${wordBank.first['word']} → ${wordBank.first['translation']}');
    
    // Check if it has wordId (universal system) or not (legacy)
    if (wordBank.first.containsKey('wordId')) {
      print('   ✅ Using universal system (has wordId)');
    } else {
      print('   ⚠️ Using legacy system (no wordId)');
    }
  } catch (e) {
    print('❌ Multilingual word bank failed: $e');
  }
  
  // Test 3: Check source words
  print('\n3️⃣ Testing Source Words:');
  try {
    final sourceWords = MultilingualWordBank.getSourceWordsForLevel(
      targetLanguage: SupportedLanguage.german,
      cefrLevel: 'A1',
    );
    print('✅ Source words found: ${sourceWords.length}');
    print('   Source words (4+ letters): ${sourceWords.take(10).join(', ')}');
    
    if (sourceWords.isEmpty) {
      print('❌ NO SOURCE WORDS - This will trigger fallback!');
    }
  } catch (e) {
    print('❌ Source words failed: $e');
  }
  
  // Test 4: Check hint generation
  print('\n4️⃣ Testing Hint Generation:');
  try {
    final testWords = ['haus', 'auto', 'hund'];
    final hints = MultilingualWordBank.generateHints(
      targetWords: testWords,
      targetLanguage: SupportedLanguage.german,
      nativeLanguage: SupportedLanguage.english,
      cefrLevel: 'A1',
    );
    print('✅ Hints generated: $hints');
    
    if (hints.contains('haus') || hints.contains('auto')) {
      print('❌ Hints contain German words - translation failed!');
    } else {
      print('✅ Hints are properly translated to English');
    }
  } catch (e) {
    print('❌ Hint generation failed: $e');
  }
  
  // Test 5: Check language combination support
  print('\n5️⃣ Testing Language Combination Support:');
  final isSupported = MultilingualWordBank.isLanguageCombinationSupported(
    nativeLanguage: SupportedLanguage.english,
    targetLanguage: SupportedLanguage.german,
  );
  print('English → German supported: $isSupported');
  
  final availableTargets = MultilingualWordBank.getAvailableTargetLanguages(
    SupportedLanguage.english,
  );
  print('Available targets for English: ${availableTargets.map((l) => l.nativeName).join(', ')}');
  
  print('\n🎯 Summary:');
  print('If source words are empty, the level generator will use _generateSimpleLevel');
  print('If hints contain German words, the translation system is broken');
  print('The screenshot shows "simple word" which means fallback was triggered');
}