import 'lib/services/level_generator.dart';
import 'lib/providers/language_provider.dart';
import 'lib/data/universal_word_bank.dart';
import 'lib/data/universal_translations.dart';

void main() async {
  print('🧪 Testing Universal Word Bank System...');
  
  // Test 1: Universal translations
  print('\n📚 Testing Universal Translations...');
  print('English "house" in German: ${UniversalTranslations.getTranslation('word_house', 'de')}');
  print('German "haus" in English: ${UniversalTranslations.getTranslation('word_house', 'en')}');
  print('German "haus" in Turkish: ${UniversalTranslations.getTranslation('word_house', 'tr')}');
  print('German "haus" in French: ${UniversalTranslations.getTranslation('word_house', 'fr')}');
  
  // Test 2: Universal word bank
  print('\n📖 Testing Universal Word Bank...');
  final germanA1 = UniversalWordBank.getWordBank(
    targetLanguage: SupportedLanguage.german,
    cefrLevel: 'A1',
  );
  print('German A1 word count: ${germanA1.length}');
  print('First 5 German words: ${germanA1.take(5).map((e) => e.word).join(', ')}');
  
  final englishA1 = UniversalWordBank.getWordBank(
    targetLanguage: SupportedLanguage.english,
    cefrLevel: 'A1',
  );
  print('English A1 word count: ${englishA1.length}');
  print('First 5 English words: ${englishA1.take(5).map((e) => e.word).join(', ')}');
  
  // Test 3: Hint generation with proper native language
  print('\n💡 Testing Hint Generation...');
  final testWords = ['haus', 'auto', 'hund'];
  final hintsInEnglish = UniversalWordBank.generateHints(
    targetWords: testWords,
    targetLanguage: SupportedLanguage.german,
    nativeLanguage: SupportedLanguage.english,
    cefrLevel: 'A1',
  );
  print('German words with English hints: $hintsInEnglish');
  
  final hintsInTurkish = UniversalWordBank.generateHints(
    targetWords: testWords,
    targetLanguage: SupportedLanguage.german,
    nativeLanguage: SupportedLanguage.turkish,
    cefrLevel: 'A1',
  );
  print('German words with Turkish hints: $hintsInTurkish');
  
  // Test 4: Level generation with universal system
  print('\n🎮 Testing Level Generation with Universal System...');
  
  // English → German
  final germanLevel = await LevelGenerator.generateLevel(
    0, 0, 0,
    nativeLanguage: SupportedLanguage.english,
    targetLanguage: SupportedLanguage.german,
  );
  
  if (germanLevel != null) {
    print('✅ English → German level generated!');
    print('Source: ${germanLevel.sourceWord}');
    print('Targets: ${germanLevel.targetWords.join(', ')}');
    print('Hints (English): ${germanLevel.hints}');
    print('Valid words: ${germanLevel.validWords.length}');
  } else {
    print('❌ Failed to generate English → German level');
  }
  
  // Turkish → German (should work with universal system)
  final turkishGermanLevel = await LevelGenerator.generateLevel(
    0, 0, 0,
    nativeLanguage: SupportedLanguage.turkish,
    targetLanguage: SupportedLanguage.german,
  );
  
  if (turkishGermanLevel != null) {
    print('\n✅ Turkish → German level generated!');
    print('Source: ${turkishGermanLevel.sourceWord}');
    print('Targets: ${turkishGermanLevel.targetWords.join(', ')}');
    print('Hints (Turkish): ${turkishGermanLevel.hints}');
  } else {
    print('\n❌ Failed to generate Turkish → German level');
  }
  
  // French → English (should work with universal system)
  final frenchEnglishLevel = await LevelGenerator.generateLevel(
    0, 0, 0,
    nativeLanguage: SupportedLanguage.french,
    targetLanguage: SupportedLanguage.english,
  );
  
  if (frenchEnglishLevel != null) {
    print('\n✅ French → English level generated!');
    print('Source: ${frenchEnglishLevel.sourceWord}');
    print('Targets: ${frenchEnglishLevel.targetWords.join(', ')}');
    print('Hints (French): ${frenchEnglishLevel.hints}');
  } else {
    print('\n❌ Failed to generate French → English level');
  }
  
  // Test 5: Compare with legacy Turkish → English
  print('\n🔄 Comparing with Legacy Turkish → English...');
  final legacyLevel = await LevelGenerator.generateLevel(
    0, 0, 0,
    nativeLanguage: SupportedLanguage.turkish,
    targetLanguage: SupportedLanguage.english,
  );
  
  if (legacyLevel != null) {
    print('✅ Legacy Turkish → English still works!');
    print('Source: ${legacyLevel.sourceWord}');
    print('Targets: ${legacyLevel.targetWords.join(', ')}');
    print('Hints (Turkish): ${legacyLevel.hints}');
  } else {
    print('❌ Legacy system broken');
  }
  
  print('\n🎉 Universal system testing complete!');
}