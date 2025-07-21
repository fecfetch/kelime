import 'lib/services/multilingual_word_bank.dart';
import 'lib/providers/language_provider.dart';

void main() {
  print('Testing German word bank...');
  
  // Test German word bank
  final germanWords = MultilingualWordBank.getWordBank(
    targetLanguage: SupportedLanguage.german,
    cefrLevel: 'A1',
    nativeLanguage: SupportedLanguage.english,
  );
  
  print('German word bank size: ${germanWords.length}');
  print('First 10 German words:');
  for (int i = 0; i < 10 && i < germanWords.length; i++) {
    final word = germanWords[i];
    print('  ${word['word']} -> ${word['translation']}');
  }
  
  // Test source words
  final sourceWords = MultilingualWordBank.getSourceWordsForLevel(
    targetLanguage: SupportedLanguage.german,
    cefrLevel: 'A1',
  );
  
  print('\nSource words (4+ letters): ${sourceWords.length}');
  print('First 10 source words: ${sourceWords.take(10).join(', ')}');
  
  // Test hint generation
  final testTargetWords = ['HAUS', 'AUTO', 'HUND'];
  final hints = MultilingualWordBank.generateHints(
    targetWords: testTargetWords,
    targetLanguage: SupportedLanguage.german,
    nativeLanguage: SupportedLanguage.english,
    cefrLevel: 'A1',
  );
  
  print('\nHint generation test:');
  print('Target words: ${testTargetWords.join(', ')}');
  print('Generated hints: $hints');
  
  print('\nTest completed successfully!');
}