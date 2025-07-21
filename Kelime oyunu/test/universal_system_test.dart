import 'package:flutter_test/flutter_test.dart';
import 'package:word_chef_flutter/data/universal_word_data.dart';
import 'package:word_chef_flutter/providers/language_provider.dart';

void main() {
  group('Universal Language System Tests', () {
    test('English A1 words should be loaded correctly', () {
      final wordBank = UniversalWordData.getWordBank(
        targetLanguage: SupportedLanguage.english,
        cefrLevel: 'A1',
      );
      
      expect(wordBank.isNotEmpty, true);
      expect(wordBank.any((entry) => entry.word == 'house'), true);
      expect(wordBank.any((entry) => entry.word == 'time'), true);
    });

    test('German A1 words should be loaded correctly', () {
      final wordBank = UniversalWordData.getWordBank(
        targetLanguage: SupportedLanguage.german,
        cefrLevel: 'A1',
      );
      
      expect(wordBank.isNotEmpty, true);
      expect(wordBank.any((entry) => entry.word == 'haus'), true);
      expect(wordBank.any((entry) => entry.word == 'zeit'), true);
    });

    test('Turkish A1 words should be loaded correctly', () {
      final wordBank = UniversalWordData.getWordBank(
        targetLanguage: SupportedLanguage.turkish,
        cefrLevel: 'A1',
      );
      
      expect(wordBank.isNotEmpty, true);
      expect(wordBank.any((entry) => entry.word == 'ev'), true);
      expect(wordBank.any((entry) => entry.word == 'zaman'), true);
    });

    test('Source words should be filtered correctly (4+ letters)', () {
      final sourceWords = UniversalWordData.getSourceWords(
        targetLanguage: SupportedLanguage.english,
        cefrLevel: 'A1',
      );
      
      expect(sourceWords.isNotEmpty, true);
      expect(sourceWords.every((word) => word.length >= 4), true);
      expect(sourceWords.contains('house'), true);
      expect(sourceWords.contains('time'), true);
    });

    test('Translations should work correctly', () {
      final wordBank = UniversalWordData.getWordBank(
        targetLanguage: SupportedLanguage.german,
        cefrLevel: 'A1',
      );
      
      final hausEntry = wordBank.firstWhere((entry) => entry.word == 'haus');
      expect(hausEntry.getTranslation('en'), 'house');
      expect(hausEntry.getTranslation('tr'), 'ev');
    });

    test('Hints should be generated in correct language', () {
      final hints = UniversalWordData.generateHints(
        targetWords: ['HAUS', 'ZEIT'],
        targetLanguage: SupportedLanguage.german,
        nativeLanguage: SupportedLanguage.english,
        cefrLevel: 'A1',
      );
      
      expect(hints.contains('house'), true);
      expect(hints.contains('time'), true);
      expect(hints.contains('|'), true);
    });

    test('Language combination support should work correctly', () {
      // Supported combinations
      expect(UniversalWordData.isLanguageCombinationSupported(
        SupportedLanguage.english, SupportedLanguage.german), true);
      expect(UniversalWordData.isLanguageCombinationSupported(
        SupportedLanguage.german, SupportedLanguage.english), true);
      expect(UniversalWordData.isLanguageCombinationSupported(
        SupportedLanguage.turkish, SupportedLanguage.english), true);
      
      // Unsupported combinations
      expect(UniversalWordData.isLanguageCombinationSupported(
        SupportedLanguage.french, SupportedLanguage.german), false);
    });

    test('Legacy format conversion should work', () {
      final legacyFormat = UniversalWordData.toLegacyFormat(
        targetLanguage: SupportedLanguage.german,
        cefrLevel: 'A1',
        nativeLanguage: SupportedLanguage.english,
      );
      
      expect(legacyFormat.isNotEmpty, true);
      expect(legacyFormat.first.containsKey('word'), true);
      expect(legacyFormat.first.containsKey('translation'), true);
      
      final hausWord = legacyFormat.firstWhere((w) => w['word'] == 'haus');
      expect(hausWord['translation'], 'house');
    });
  });
}