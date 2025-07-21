// Debug test with actual word banks
import 'lib/data/word_bank_a1.dart';
import 'lib/data/word_bank_a2.dart';
import 'lib/data/word_bank_b1.dart';

// Simple word validation
class WordValidator {
  static bool canFormWord(String sourceWord, String targetWord) {
    final sourceLetters = sourceWord.toLowerCase().split('');
    final targetLetters = targetWord.toLowerCase().split('');
    
    final sourceCount = <String, int>{};
    for (final letter in sourceLetters) {
      sourceCount[letter] = (sourceCount[letter] ?? 0) + 1;
    }
    
    for (final letter in targetLetters) {
      if ((sourceCount[letter] ?? 0) <= 0) {
        return false;
      }
      sourceCount[letter] = sourceCount[letter]! - 1;
    }
    
    return true;
  }
  
  static List<String> findPossibleWords(String sourceWord, List<String> wordBank) {
    return wordBank.where((word) => canFormWord(sourceWord, word)).toList();
  }
}

void main() {
  print('🔍 DEBUG: Testing with Real Word Banks...');
  
  // Build combined word bank (like B1 level)
  List<Map<String, dynamic>> wordBank = [];
  wordBank.addAll(wordBankA1);
  wordBank.addAll(wordBankA2);
  wordBank.addAll(wordBankB1);
  
  final allWords = wordBank.map((w) => w['word'] as String).toList();
  print('Total words in combined A1+A2+B1 bank: ${allWords.length}');
  
  // Test with some longer source words
  final testSourceWords = [
    'KNOWLEDGE',
    'STRENGTH', 
    'BEAUTIFUL',
    'IMPORTANT',
    'DIFFERENT',
    'EDUCATION',
    'COMMUNITY',
    'TECHNOLOGY'
  ];
  
  for (final sourceWord in testSourceWords) {
    print('\n--- Testing Source Word: $sourceWord (${sourceWord.length} letters) ---');
    
    final possibleWords = WordValidator.findPossibleWords(sourceWord, allWords);
    print('Total possible words: ${possibleWords.length}');
    
    if (possibleWords.length <= 20) {
      print('All possible words: ${possibleWords.join(', ')}');
    } else {
      print('First 20 possible words: ${possibleWords.take(20).join(', ')}...');
    }
    
    // Apply the enhanced selection logic
    final sourceLength = sourceWord.length;
    const maxTargetWords = 8;
    
    if (sourceLength > 6) {
      final minWordLength = sourceLength - 3;
      print('Minimum word length for inclusion: $minWordLength');
      
      final eligibleWords = possibleWords.where((w) => w.length >= minWordLength).toList();
      print('Eligible long words (>= $minWordLength letters): ${eligibleWords.length}');
      if (eligibleWords.isNotEmpty) {
        print('Eligible words: ${eligibleWords.join(', ')}');
      }
      
      // Sort by length (longer first)
      final otherWords = possibleWords.where((w) => w != sourceWord.toLowerCase()).toList();
      otherWords.sort((a, b) => b.length.compareTo(a.length));
      
      final targetWords = <String>[];
      
      // Add long words first
      for (final word in otherWords) {
        if (targetWords.length >= maxTargetWords) break;
        if (word.length >= minWordLength) {
          targetWords.add(word.toUpperCase());
        }
      }
      
      print('Added ${targetWords.length} long words');
      
      // Add shorter words if needed
      if (targetWords.length < maxTargetWords) {
        for (final word in otherWords) {
          if (targetWords.length >= maxTargetWords) break;
          if (word.length < minWordLength && !targetWords.contains(word.toUpperCase())) {
            targetWords.add(word.toUpperCase());
          }
        }
      }
      
      print('Final target words (${targetWords.length}): ${targetWords.join(', ')}');
      
      if (targetWords.length < 4) {
        print('⚠️  WARNING: Only ${targetWords.length} target words found - might be insufficient!');
      } else {
        print('✅ Good: ${targetWords.length} target words found');
      }
    }
  }
  
  print('\n🔍 DEBUG: Checking word bank coverage...');
  
  // Check what types of words we have
  final wordLengths = <int, int>{};
  for (final word in allWords) {
    final length = word.length;
    wordLengths[length] = (wordLengths[length] ?? 0) + 1;
  }
  
  print('Word distribution by length:');
  for (final entry in wordLengths.entries) {
    print('  ${entry.key} letters: ${entry.value} words');
  }
  
  print('\n✅ Debug test completed!');
}