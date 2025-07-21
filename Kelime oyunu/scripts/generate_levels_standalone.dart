import 'dart:io';
import 'dart:convert';
import 'dart:math';

// Import word banks directly
import 'package:word_chef_flutter/data/universal_word_bank.dart';
import 'package:word_chef_flutter/data/universal_translations.dart';
import 'package:word_chef_flutter/providers/language_provider.dart';
import 'package:word_chef_flutter/data/word_bank_a1.dart';
import 'package:word_chef_flutter/data/word_bank_a2.dart';
import 'package:word_chef_flutter/data/word_bank_b1.dart';
import 'package:word_chef_flutter/data/word_bank_b2.dart';
import 'package:word_chef_flutter/data/word_bank_c1.dart';
import 'package:word_chef_flutter/data/word_bank_c2.dart';

/// Standalone WordValidator - exact copy of the original logic
class StandaloneWordValidator {
  /// Checks if a target word can be formed from the source word letters
  static bool canFormWord(String sourceWord, String targetWord) {
    final sourceLetters = sourceWord.toLowerCase().split('');
    final targetLetters = targetWord.toLowerCase().split('');

    // Count frequency of each letter in source word
    final sourceCount = <String, int>{};
    for (String letter in sourceLetters) {
      sourceCount[letter] = (sourceCount[letter] ?? 0) + 1;
    }

    // Check if target word can be formed
    final targetCount = <String, int>{};
    for (String letter in targetLetters) {
      targetCount[letter] = (targetCount[letter] ?? 0) + 1;
    }

    // Verify each letter in target exists in sufficient quantity in source
    for (String letter in targetCount.keys) {
      if ((sourceCount[letter] ?? 0) < targetCount[letter]!) {
        return false;
      }
    }

    return true;
  }

  /// Finds all possible words that can be formed from source letters
  static List<String> findPossibleWords(String sourceWord, List<String> wordBank) {
    return wordBank
        .where((word) => word.length >= 2 && canFormWord(sourceWord, word))
        .toList();
  }

  /// Validates a complete level to ensure all target words are possible
  static bool validateLevel(String sourceWord, List<String> targetWords) {
    return targetWords.every((word) => canFormWord(sourceWord, word));
  }
}

/// Standalone level generator - enhanced with better word variety control
class StandaloneLevelGenerator {
  // Track recently used source words (never reuse)
  static final Set<String> _usedSourceWords = {};
  
  // Track recently used target words (30-level sliding window)
  static final List<String> _usedTargetWords = [];
  static const int _targetWordAvoidanceWindow = 30;
  
  // Legacy compatibility
  static final List<String> _usedWords = [];
  static const int _avoidanceWindow = 15;

  /// Common letters that often create new words when added
  static const List<String> _expansionLetters = [
    's', 'e', 'd', 'r', 'n', 't', 'l', 'i', 'o', 'a',
    'u', 'h', 'g', 'f', 'c', 'm', 'p', 'b', 'w', 'y'
  ];

  /// Helper method to get all source words from universal word banks for a CEFR level and target language
  static List<String> _getSourceWordsForLevel(String cefrLevel, SupportedLanguage targetLanguage) {
    try {
      // Try universal system first
      return UniversalWordBank.getSourceWordsForLevel(
        targetLanguage: targetLanguage,
        cefrLevel: cefrLevel,
      );
    } catch (e) {
      // Fallback to legacy English system
      List<Map<String, dynamic>> wordBank = [];

      // Build the appropriate word bank based on CEFR level (legacy English only)
      switch (cefrLevel) {
        case 'A1':
          wordBank = wordBankA1;
          break;
        case 'A2':
          wordBank = [...wordBankA1, ...wordBankA2];
          break;
        case 'B1':
          wordBank = [...wordBankA1, ...wordBankA2, ...wordBankB1];
          break;
        case 'B2':
          wordBank = [...wordBankA1, ...wordBankA2, ...wordBankB1, ...wordBankB2];
          break;
        case 'C1':
          wordBank = [
            ...wordBankA1,
            ...wordBankA2,
            ...wordBankB1,
            ...wordBankB2,
            ...wordBankC1
          ];
          break;
        case 'C2':
          wordBank = [
            ...wordBankA1,
            ...wordBankA2,
            ...wordBankB1,
            ...wordBankB2,
            ...wordBankC1,
            ...wordBankC2
          ];
          break;
        case 'MIXED':
          wordBank = [
            ...wordBankA1,
            ...wordBankA2,
            ...wordBankB1,
            ...wordBankB2,
            ...wordBankC1,
            ...wordBankC2
          ];
          break;
        default:
          wordBank = wordBankA1;
      }

      // Extract all words and filter for good source words (4+ letters for better gameplay)
      return wordBank
          .map((w) => w['word'] as String)
          .where((word) => word.length >= 4) // Minimum 4 letters for source words
          .toList();
    }
  }

  /// Load recently used words (in-memory replacement for SharedPreferences)
  static List<String> _loadUsedWords() {
    return _usedWords;
  }

  /// Save recently used words (in-memory replacement for SharedPreferences)
  static void _saveUsedWords(List<String> usedWords) {
    _usedWords.clear();
    // Keep only the last N words to prevent unlimited growth
    final wordsToSave = usedWords.length > _avoidanceWindow
        ? usedWords.sublist(usedWords.length - _avoidanceWindow)
        : usedWords;
    _usedWords.addAll(wordsToSave);
  }

  /// Add a word to the used words list
  static void _addUsedWord(String word) {
    final usedWords = _loadUsedWords();
    usedWords.add(word);
    _saveUsedWords(usedWords);
  }

  /// Add target words to the avoidance list
  static void _addUsedTargetWords(List<String> targetWords) {
    for (final word in targetWords) {
      _usedTargetWords.add(word.toLowerCase());
    }
    
    // Keep only the last N target words to prevent unlimited growth
    if (_usedTargetWords.length > _targetWordAvoidanceWindow) {
      _usedTargetWords.removeRange(0, _usedTargetWords.length - _targetWordAvoidanceWindow);
    }
  }

  /// Generate a new source word by expanding an existing word or reusing from higher levels
  static String _generateNewSourceWord(List<Map<String, dynamic>> wordBank, String cefrLevel) {
    // First, try to find any unused word from the current word bank
    final allWords = wordBank
        .map((w) => w['word'] as String)
        .where((word) => !_usedSourceWords.contains(word))
        .where((word) => word.length >= 3) // Allow shorter words when desperate
        .toList();
    
    if (allWords.isNotEmpty) {
      // Prioritize words that can form multiple target words
      final wordScores = <String, int>{};
      final allWordsInBank = wordBank.map((w) => w['word'] as String).toList();
      
      for (final word in allWords) {
        final possibleWords = StandaloneWordValidator.findPossibleWords(word, allWordsInBank);
        wordScores[word] = possibleWords.length;
      }
      
      // Sort by score and pick from top candidates
      final sortedWords = allWords..sort((a, b) => (wordScores[b] ?? 0).compareTo(wordScores[a] ?? 0));
      final topCandidates = sortedWords.take((sortedWords.length * 0.5).ceil().clamp(1, 10)).toList();
      
      return topCandidates[Random().nextInt(topCandidates.length)];
    }
    
    // If we've exhausted the current level, borrow from higher levels
    List<Map<String, dynamic>> expandedWordBank = [];
    
    switch (cefrLevel) {
      case 'A1':
        // Borrow from A2
        expandedWordBank = [...wordBankA1, ...wordBankA2];
        break;
      case 'A2':
        // Borrow from B1
        expandedWordBank = [...wordBankA1, ...wordBankA2, ...wordBankB1];
        break;
      default:
        // For higher levels, we should have enough words
        expandedWordBank = wordBank;
    }
    
    final expandedWords = expandedWordBank
        .map((w) => w['word'] as String)
        .where((word) => !_usedSourceWords.contains(word))
        .where((word) => word.length >= 3)
        .toList();
    
    if (expandedWords.isNotEmpty) {
      return expandedWords[Random().nextInt(expandedWords.length)];
    }
    
    // Last resort: reuse a word (reset some used words)
    print('    ⚠️  Resetting some used source words to continue generation');
    final someUsedWords = _usedSourceWords.take(_usedSourceWords.length ~/ 2).toList();
    for (final word in someUsedWords) {
      _usedSourceWords.remove(word);
    }
    
    final fallbackWords = wordBank.map((w) => w['word'] as String).toList();
    return fallbackWords[Random().nextInt(fallbackWords.length)];
  }

  /// Select a source word that hasn't been used before
  static String _selectSourceWord(List<String> sourceWords, String cefrLevel, List<Map<String, dynamic>> wordBank) {
    // Filter out permanently used source words
    final availableWords = sourceWords.where((word) => !_usedSourceWords.contains(word)).toList();

    if (availableWords.isNotEmpty) {
      // Prioritize words that can form more target words for better gameplay
      final wordScores = <String, int>{};
      final allWords = wordBank.map((w) => w['word'] as String).toList();

      // Score each available word by how many target words it can form
      for (final word in availableWords) {
        final possibleWords = StandaloneWordValidator.findPossibleWords(word, allWords);
        wordScores[word] = possibleWords.length;
      }

      // Sort by score (descending) and pick from top candidates
      final sortedWords = availableWords
        ..sort((a, b) => (wordScores[b] ?? 0).compareTo(wordScores[a] ?? 0));

      // Pick randomly from top 30% of words to maintain variety while ensuring good gameplay
      final topCandidates = sortedWords
          .take((sortedWords.length * 0.3).ceil().clamp(1, 5))
          .toList();
      return topCandidates[Random().nextInt(topCandidates.length)];
    } else {
      // Generate a new source word when we run out
      print('    🔄 Generating new source word (exhausted available words)');
      return _generateNewSourceWord(wordBank, cefrLevel);
    }
  }

  /// Expand source word by adding strategic letters to create more target words
  static String _expandSourceWord(String sourceWord, List<Map<String, dynamic>> wordBank, int minTargets) {
    final allWords = wordBank.map((w) => w['word'] as String).toList();

    // Try the original word first
    final originalPossible = StandaloneWordValidator.findPossibleWords(sourceWord, allWords);
    if (originalPossible.length >= minTargets) {
      return sourceWord;
    }

    // Try adding each expansion letter and see which gives the best results
    String bestExpansion = sourceWord;
    int bestScore = originalPossible.length;

    // More aggressive expansion - try more letters and positions
    for (final letter in _expansionLetters) {
      // Try adding the letter at different positions
      for (int pos = 0; pos <= sourceWord.length; pos++) {
        final expandedWord = sourceWord.substring(0, pos) + letter + sourceWord.substring(pos);

        // Allow longer words for higher levels (up to 10 letters)
        if (expandedWord.length > 10) continue;

        final possibleWords = StandaloneWordValidator.findPossibleWords(expandedWord, allWords);

        // More generous scoring system
        int score = possibleWords.length * 2; // Double weight for word count

        // Bonus for including the original source word
        if (possibleWords.contains(sourceWord)) {
          score += 3;
        }

        // Bonus for having a good variety of word lengths
        final wordLengths = possibleWords.map((w) => w.length).toSet();
        score += wordLengths.length * 2;

        // Bonus for shorter words (easier to find)
        final shortWords = possibleWords.where((w) => w.length <= 4).length;
        score += shortWords;

        if (score > bestScore) {
          bestScore = score;
          bestExpansion = expandedWord;
        }
      }
    }

    // If still not enough words, try adding two letters more aggressively
    if (StandaloneWordValidator.findPossibleWords(bestExpansion, allWords).length < minTargets) {
      for (final letter1 in _expansionLetters.take(15)) { // Increased from 10 to 15
        for (final letter2 in _expansionLetters.take(10)) { // Increased from 5 to 10
          if (letter1 == letter2) continue;

          // Try different positions for double expansion
          final positions = [
            sourceWord + letter1 + letter2,
            letter1 + sourceWord + letter2,
            letter1 + letter2 + sourceWord,
            sourceWord.substring(0, sourceWord.length ~/ 2) +
                letter1 +
                letter2 +
                sourceWord.substring(sourceWord.length ~/ 2),
          ];

          for (final doubleExpanded in positions) {
            if (doubleExpanded.length > 10) continue;

            final possibleWords = StandaloneWordValidator.findPossibleWords(doubleExpanded, allWords);
            if (possibleWords.length >= minTargets) {
              return doubleExpanded;
            }
          }
        }
      }
    }

    return bestExpansion;
  }

  /// Generate a level for specific world/subworld/level with language support
  static Map<String, dynamic>? generateLevel(
    int world, 
    int subWorld, 
    int level, {
    SupportedLanguage targetLanguage = SupportedLanguage.english,
    SupportedLanguage nativeLanguage = SupportedLanguage.turkish,
  }) {
    try {
      // Determine CEFR level based on world
      String cefrLevel;
      switch (world) {
        case 0:
          cefrLevel = 'A1';
          break;
        case 1:
          cefrLevel = 'A2';
          break;
        case 2:
          cefrLevel = 'B1';
          break;
        case 3:
          cefrLevel = 'B2';
          break;
        case 4:
          cefrLevel = 'C1';
          break;
        case 5:
          cefrLevel = 'C2';
          break;
        case 6:
          cefrLevel = 'MIXED';
          break;
        default:
          cefrLevel = 'A1';
      }

      final sourceWords = _getSourceWordsForLevel(cefrLevel, targetLanguage);
      if (sourceWords.isEmpty) {
        // Fallback to A1 if no words found
        return _generateSimpleLevel(targetLanguage, nativeLanguage);
      }

      // Get word bank using universal system
      List<Map<String, dynamic>> wordBank = [];
      
      try {
        // Try universal system first
        final universalWordBank = UniversalWordBank.getWordBank(
          targetLanguage: targetLanguage,
          cefrLevel: cefrLevel,
        );
        
        // Convert universal format to legacy format for compatibility
        wordBank = universalWordBank.map((entry) => {
          'word': entry.word,
          'translation': entry.getTranslation(nativeLanguage.code),
          'wordId': entry.wordId,
          'category': entry.category,
        }).toList();
      } catch (e) {
        // Fallback to legacy English system
        wordBank.addAll(wordBankA1);

        // Add appropriate level words based on CEFR level (legacy English only)
        switch (cefrLevel) {
          case 'A2':
          case 'B1':
          case 'B2':
          case 'C1':
          case 'C2':
            wordBank.addAll(wordBankA2);
            if (cefrLevel == 'B1' ||
                cefrLevel == 'B2' ||
                cefrLevel == 'C1' ||
                cefrLevel == 'C2') {
              wordBank.addAll(wordBankB1);
            }
            if (cefrLevel == 'B2' || cefrLevel == 'C1' || cefrLevel == 'C2') {
              wordBank.addAll(wordBankB2);
            }
            if (cefrLevel == 'C1' || cefrLevel == 'C2') {
              wordBank.addAll(wordBankC1);
            }
            if (cefrLevel == 'C2') {
              wordBank.addAll(wordBankC2);
            }
            break;
          case 'MIXED':
            wordBank.addAll(wordBankA2);
            wordBank.addAll(wordBankB1);
            wordBank.addAll(wordBankB2);
            wordBank.addAll(wordBankC1);
            wordBank.addAll(wordBankC2);
            break;
        }
      }

      // Select a source word that hasn't been used before
      final baseSourceWord = _selectSourceWord(sourceWords, cefrLevel, wordBank);

      // Determine minimum target words needed - more generous for longer words
      final minTargets = (level < 5)
          ? 3
          : (level < 10)
              ? 4
              : 5;

      // Expand the source word if needed to ensure enough target words
      final expandedSourceWord = _expandSourceWord(baseSourceWord, wordBank, minTargets);

      // Track the base word as used permanently (never reuse source words)
      _usedSourceWords.add(baseSourceWord);
      _usedSourceWords.add(expandedSourceWord); // Also track expanded version
      _addUsedWord(baseSourceWord); // Legacy compatibility

      // Find all possible target words from the expanded source word
      final allWords = wordBank.map((w) => w['word'] as String).toList();
      final possibleWords = StandaloneWordValidator.findPossibleWords(expandedSourceWord, allWords);

      if (possibleWords.isEmpty) {
        // If no words can be formed, return a simple fallback level
        return _generateSimpleLevel(targetLanguage, nativeLanguage);
      }

      // Select target words with smart prioritization
      final targetWords = <String>[];

      // Prioritize including the original base word if possible
      if (possibleWords.contains(baseSourceWord)) {
        targetWords.add(baseSourceWord.toUpperCase());
      }

      // Add other words with smart prioritization, filtering out recently used target words
      final otherWords = possibleWords
          .where((w) => w != baseSourceWord)
          .where((w) => !_usedTargetWords.contains(w.toLowerCase())) // Avoid recently used target words
          .toList();

      // Smart sorting: prioritize longer words first for better gameplay progression
      otherWords.sort((a, b) {
        // First priority: length (longer words first for better challenge progression)
        final lengthCompare = b.length.compareTo(a.length); // Reversed for longer first
        if (lengthCompare != 0) return lengthCompare;

        // Second priority: common words (from A1/A2 levels) for familiarity
        final aIsCommon = wordBankA1.any((w) => w['word'] == a) ||
            wordBankA2.any((w) => w['word'] == a);
        final bIsCommon = wordBankA1.any((w) => w['word'] == b) ||
            wordBankA2.any((w) => w['word'] == b);

        if (aIsCommon && !bIsCommon) return -1;
        if (!aIsCommon && bIsCommon) return 1;

        // Third priority: random for variety
        return Random().nextBool() ? -1 : 1;
      });

      // Enhanced target word selection for better gameplay
      final sourceLength = expandedSourceWord.length;
      const maxTargetWords = 8; // Maximum target words per level

      // For words longer than 6 letters (not including 6), include all words that are at least n-3 letters long
      // For shorter source words (6 or less), use the original minTargets limit
      final shouldIncludeAllLongWords = sourceLength > 6;

      final addedWords = <String>[];
      
      if (shouldIncludeAllLongWords) {
        // For words longer than 6 letters: include ALL words that are at least n-3 letters long
        final minWordLength = sourceLength - 3;
        
        for (final word in otherWords) {
          // Stop if we've reached the maximum target words
          if (targetWords.length >= maxTargetWords) break;
          
          if (word.length >= minWordLength) {
            addedWords.add(word);
            targetWords.add(word.toUpperCase());
          }
        }
        
        // If we still don't have enough, add shorter words too (up to max)
        if (targetWords.length < maxTargetWords) {
          for (final word in otherWords) {
            if (targetWords.contains(word.toUpperCase())) continue;
            if (targetWords.length >= maxTargetWords) break;
            
            // Add any remaining words that weren't included yet
            if (word.length < minWordLength) {
              addedWords.add(word);
              targetWords.add(word.toUpperCase());
            }
          }
        }
      } else {
        // For shorter source words (6 or less), use the original logic but be more generous
        for (final word in otherWords) {
          if (targetWords.length >= maxTargetWords) break;
          if (addedWords.length >= minTargets - targetWords.length && addedWords.length >= 4) break;

          // Less restrictive length variety - allow more words of similar length
          final sameLength = addedWords.where((w) => w.length == word.length).length;
          if (sameLength >= 3 && addedWords.length >= 3) continue;

          addedWords.add(word);
          targetWords.add(word.toUpperCase());
        }
        
        // Add more words if we still don't have enough (up to max)
        if (targetWords.length < minTargets) {
          for (final word in otherWords) {
            if (targetWords.contains(word.toUpperCase())) continue;
            if (targetWords.length >= maxTargetWords) break;
            if (targetWords.length >= minTargets + 2) break;

            targetWords.add(word.toUpperCase());
          }
        }
      }

      // Ensure we have at least 1 target word (fallback to source word only if needed)
      if (targetWords.isEmpty) {
        targetWords.add(expandedSourceWord.toUpperCase());
      }

      // Track used target words to avoid repetition in next 30 levels
      _addUsedTargetWords(targetWords);

      // Generate Turkish hints
      final hints = targetWords.map((word) {
        final wordData = wordBank.firstWhere(
          (w) => (w['word'] as String).toUpperCase() == word,
          orElse: () => {'word': word.toLowerCase(), 'translation': word.toLowerCase()},
        );
        return wordData['translation'] as String;
      }).join(' | ');

      return {
        'world': world,
        'subWorld': subWorld,
        'level': level,
        'hints': hints,
        'sourceWord': expandedSourceWord,
        'targetWords': targetWords,
        'validWords': possibleWords.map((w) => w.toLowerCase()).toList(),
        'generatedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // If anything goes wrong, return a simple fallback level
      return _generateSimpleLevel(targetLanguage, nativeLanguage);
    }
  }

  /// Generate simple fallback level
  static Map<String, dynamic> _generateSimpleLevel(
    SupportedLanguage targetLanguage, 
    SupportedLanguage nativeLanguage
  ) {
    // Generate appropriate fallback based on target language
    if (targetLanguage == SupportedLanguage.german) {
      return {
        'world': 0,
        'subWorld': 0,
        'level': 0,
        'hints': nativeLanguage == SupportedLanguage.english 
          ? 'simple word' 
          : 'einfaches wort',
        'sourceWord': 'EINFACH',
        'targetWords': ['EINFACH', 'EIN', 'ICH'],
        'validWords': ['einfach', 'ein', 'ich'],
        'generatedAt': DateTime.now().toIso8601String(),
      };
    } else {
      // Default English fallback
      return {
        'world': 0,
        'subWorld': 0,
        'level': 0,
        'hints': nativeLanguage == SupportedLanguage.turkish 
          ? 'basit kelime' 
          : 'simple word',
        'sourceWord': 'SIMPLE',
        'targetWords': ['SIMPLE', 'SIM', 'ME', 'IS'],
        'validWords': ['simple', 'sim', 'me', 'is'],
        'generatedAt': DateTime.now().toIso8601String(),
      };
    }
  }
}

/// Main script execution - now supports multiple language pairs
Future<void> main(List<String> args) async {
  print('🚀 Starting universal level pre-generation...');
  
  // Parse command line arguments for language pairs
  final languagePairs = <Map<String, SupportedLanguage>>[];
  
  if (args.isNotEmpty && args.contains('--languages')) {
    // Parse specific language pairs from command line
    // Format: --languages en:de,tr:en,fr:en
    final langIndex = args.indexOf('--languages');
    if (langIndex + 1 < args.length) {
      final pairStrings = args[langIndex + 1].split(',');
      for (final pairString in pairStrings) {
        final parts = pairString.split(':');
        if (parts.length == 2) {
          try {
            final nativeCode = parts[0];
            final targetCode = parts[1];
            final nativeLang = SupportedLanguage.values.firstWhere((l) => l.code == nativeCode);
            final targetLang = SupportedLanguage.values.firstWhere((l) => l.code == targetCode);
            languagePairs.add({
              'native': nativeLang,
              'target': targetLang,
            });
          } catch (e) {
            print('⚠️ Invalid language pair: $pairString');
          }
        }
      }
    }
  }
  
  // Default language pairs if none specified
  if (languagePairs.isEmpty) {
    languagePairs.addAll([
      {'native': SupportedLanguage.turkish, 'target': SupportedLanguage.english},
      {'native': SupportedLanguage.english, 'target': SupportedLanguage.german},
      {'native': SupportedLanguage.german, 'target': SupportedLanguage.english},
      {'native': SupportedLanguage.french, 'target': SupportedLanguage.english},
      {'native': SupportedLanguage.spanish, 'target': SupportedLanguage.english},
    ]);
  }
  
  print('📋 Generating levels for ${languagePairs.length} language pairs:');
  for (final pair in languagePairs) {
    print('   ${pair['native']!.nativeName} → ${pair['target']!.nativeName}');
  }
  
  // Create new organized directory structure
  final levelsDir = Directory('assets/levels');
  if (!await levelsDir.exists()) {
    await levelsDir.create(recursive: true);
  }
  
  int totalLevels = 0;
  int successfulLevels = 0;
  final Map<String, List<Map<String, dynamic>>> languageLevels = {};
  
  // Generate levels for each language pair
  for (final languagePair in languagePairs) {
    final nativeLanguage = languagePair['native']!;
    final targetLanguage = languagePair['target']!;
    final targetLangCode = targetLanguage.code;
    
    print('\n🌍 Generating ${nativeLanguage.nativeName} → ${targetLanguage.nativeName} levels...');
    
    // Initialize language levels storage
    if (!languageLevels.containsKey(targetLangCode)) {
      languageLevels[targetLangCode] = [];
    }
    
    // Generate levels for each world/CEFR level
    for (int world = 0; world < 7; world++) {
      final cefrLevel = _getCefrLevel(world);
      print('  📚 $cefrLevel levels (World $world)...');
      
      for (int subWorld = 0; subWorld < 5; subWorld++) {
        for (int level = 0; level < 18; level++) {
          totalLevels++;
          
          try {
            final levelData = StandaloneLevelGenerator.generateLevel(
              world, 
              subWorld, 
              level,
              targetLanguage: targetLanguage,
              nativeLanguage: nativeLanguage,
            );
            
            if (levelData != null) {
              // Add language pair info to level data
              levelData['targetLanguage'] = targetLangCode;
              levelData['nativeLanguage'] = nativeLanguage.code;
              levelData['cefrLevel'] = cefrLevel;
              
              // Add to language-specific collection
              languageLevels[targetLangCode]!.add(levelData);
              successfulLevels++;
              
              if (level % 6 == 0) {
                print('    ✅ Level $level generated');
              }
            } else {
              print('    ❌ Failed to generate level $level');
            }
          } catch (e) {
            print('    ❌ Error generating level $level: $e');
          }
        }
      }
    }
  }
  
  // Save levels in new organized structure
  print('\n💾 Saving levels in organized structure...');
  
  for (final entry in languageLevels.entries) {
    final targetLangCode = entry.key;
    final levels = entry.value;
    
    // Group levels by CEFR level
    final Map<String, List<Map<String, dynamic>>> cefrGroups = {};
    for (final level in levels) {
      final cefrLevel = level['cefrLevel'] as String;
      if (!cefrGroups.containsKey(cefrLevel)) {
        cefrGroups[cefrLevel] = [];
      }
      cefrGroups[cefrLevel]!.add(level);
    }
    
    // Create target language directory
    final langDir = Directory('assets/levels/$targetLangCode');
    if (!await langDir.exists()) {
      await langDir.create(recursive: true);
    }
    
    // Save each CEFR level as a separate file
    for (final cefrEntry in cefrGroups.entries) {
      final cefrLevel = cefrEntry.key;
      final cefrLevels = cefrEntry.value;
      
      final cefrFile = File('assets/levels/$targetLangCode/${cefrLevel}_levels.json');
      final cefrData = {
        'language': targetLangCode,
        'cefrLevel': cefrLevel,
        'generatedAt': DateTime.now().toIso8601String(),
        'totalLevels': cefrLevels.length,
        'levels': cefrLevels,
      };
      
      await cefrFile.writeAsString(json.encode(cefrData));
      print('  📁 Saved ${cefrLevels.length} $cefrLevel levels for $targetLangCode');
    }
  }
  
  print('\n🎉 Universal level generation complete!');
  print('📊 Statistics:');
  print('   Language pairs: ${languagePairs.length}');
  print('   Target languages: ${languageLevels.keys.length}');
  print('   Total levels: $totalLevels');
  print('   Successful: $successfulLevels');
  print('   Failed: ${totalLevels - successfulLevels}');
  print('   Success rate: ${(successfulLevels / totalLevels * 100).toStringAsFixed(1)}%');
  
  // Generate master index file
  await _generateMasterIndex(languageLevels);
  
  print('\n✅ All done! Levels saved to assets/levels/ with organized structure');
  print('📂 Structure: assets/levels/{language}/{cefr_level}_levels.json');
}

/// Get CEFR level from world number
String _getCefrLevel(int world) {
  switch (world) {
    case 0: return 'A1';
    case 1: return 'A2';
    case 2: return 'B1';
    case 3: return 'B2';
    case 4: return 'C1';
    case 5: return 'C2';
    case 6: return 'MIXED';
    default: return 'A1';
  }
}

/// Generate master index file for all languages and levels
Future<void> _generateMasterIndex(Map<String, List<Map<String, dynamic>>> languageLevels) async {
  print('\n📋 Generating master index...');
  
  final masterIndex = <String, dynamic>{
    'generatedAt': DateTime.now().toIso8601String(),
    'totalLanguages': languageLevels.keys.length,
    'totalLevels': languageLevels.values.fold(0, (sum, levels) => sum + levels.length),
    'languages': <String, dynamic>{},
  };
  
  for (final entry in languageLevels.entries) {
    final targetLangCode = entry.key;
    final levels = entry.value;
    
    // Group by CEFR level for statistics
    final cefrStats = <String, int>{};
    for (final level in levels) {
      final cefrLevel = level['cefrLevel'] as String;
      cefrStats[cefrLevel] = (cefrStats[cefrLevel] ?? 0) + 1;
    }
    
    masterIndex['languages'][targetLangCode] = {
      'totalLevels': levels.length,
      'cefrLevels': cefrStats,
      'availableFiles': cefrStats.keys.map((cefr) => '${cefr}_levels.json').toList(),
    };
  }
  
  final indexFile = File('assets/levels/index.json');
  await indexFile.writeAsString(json.encode(masterIndex));
  
  print('📋 Master index generated with ${languageLevels.keys.length} languages');
}

/// Generate an index file that lists all available levels
Future<void> _generateIndexFile() async {
  print('\n📋 Generating level index...');
  
  final levelsDir = Directory('assets/levels');
  final files = await levelsDir.list().where((entity) => 
    entity is File && entity.path.endsWith('.json') && !entity.path.endsWith('index.json')
  ).toList();
  
  final index = <String, dynamic>{
    'generatedAt': DateTime.now().toIso8601String(),
    'totalLevels': files.length,
    'levels': <Map<String, dynamic>>[],
  };
  
  for (final file in files) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final parts = fileName.replaceAll('.json', '').split('_');
    
    // Only process files that match the level_X_Y_Z pattern
    if (parts.length >= 4 && parts[0] == 'level') {
      try {
        index['levels'].add({
          'world': int.parse(parts[1]),
          'subWorld': int.parse(parts[2]),
          'level': int.parse(parts[3]),
          'fileName': fileName,
        });
      } catch (e) {
        // Skip files that don't have valid numeric parts
        print('Skipping file with invalid format: $fileName');
      }
    }
  }
  
  // Sort levels
  (index['levels'] as List).sort((a, b) {
    final worldCompare = (a['world'] as int).compareTo(b['world'] as int);
    if (worldCompare != 0) return worldCompare;
    
    final subWorldCompare = (a['subWorld'] as int).compareTo(b['subWorld'] as int);
    if (subWorldCompare != 0) return subWorldCompare;
    
    return (a['level'] as int).compareTo(b['level'] as int);
  });
  
  final indexFile = File('assets/levels/index.json');
  await indexFile.writeAsString(json.encode(index));
  
  print('📋 Index file generated with ${files.length} levels');
}