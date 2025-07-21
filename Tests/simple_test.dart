// Simple test without Flutter dependencies
import 'dart:io';

// Mock classes to avoid Flutter dependencies
class GameLevel {
  final String hints;
  final String sourceWord;
  final List<String> targetWords;
  final List<String> validWords;

  GameLevel({
    required this.hints,
    required this.sourceWord,
    required this.targetWords,
    required this.validWords,
  });
}

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
  print('🔍 Testing Level Generation Logic...');
  
  // Test word formation
  print('\n--- Testing Word Formation ---');
  final testCases = [
    ['KNOWLEDGE', 'KNOW'],
    ['KNOWLEDGE', 'EDGE'],
    ['KNOWLEDGE', 'LODGE'],
    ['KNOWLEDGE', 'GOLDEN'],
    ['KNOWLEDGE', 'DONKEY'], // Should fail - no Y in KNOWLEDGE
  ];
  
  for (final testCase in testCases) {
    final source = testCase[0];
    final target = testCase[1];
    final canForm = WordValidator.canFormWord(source, target);
    print('  $target from $source: $canForm');
  }
  
  // Test with sample word bank
  print('\n--- Testing Word Finding ---');
  final sampleWordBank = [
    'know', 'edge', 'lodge', 'dog', 'go', 'leg', 'old', 'gold', 'done', 'node',
    'long', 'gone', 'lone', 'love', 'dove', 'glove', 'knowledge', 'donkey'
  ];
  
  const sourceWord = 'KNOWLEDGE';
  final possibleWords = WordValidator.findPossibleWords(sourceWord, sampleWordBank);
  
  print('Source word: $sourceWord');
  print('Word bank size: ${sampleWordBank.length}');
  print('Possible words found: ${possibleWords.length}');
  print('Possible words: ${possibleWords.join(', ')}');
  
  // Test the enhanced selection logic
  print('\n--- Testing Enhanced Selection Logic ---');
  const sourceLength = sourceWord.length;
  const maxTargetWords = 8;
  
  print('Source length: $sourceLength');
  print('Should include all long words: ${sourceLength > 6}');
  
  if (sourceLength > 6) {
    final minWordLength = sourceLength - 3;
    print('Minimum word length for inclusion: $minWordLength');
    
    final eligibleWords = possibleWords.where((w) => w.length >= minWordLength).toList();
    print('Eligible words (>= $minWordLength letters): ${eligibleWords.length}');
    print('Eligible words: ${eligibleWords.join(', ')}');
    
    // Sort by length (longer first)
    eligibleWords.sort((a, b) => b.length.compareTo(a.length));
    print('Sorted eligible words: ${eligibleWords.join(', ')}');
    
    final targetWords = <String>[];
    
    // Add eligible words up to max
    for (final word in eligibleWords) {
      if (targetWords.length >= maxTargetWords) break;
      targetWords.add(word.toUpperCase());
    }
    
    // Add shorter words if needed
    if (targetWords.length < maxTargetWords) {
      final shorterWords = possibleWords.where((w) => w.length < minWordLength).toList();
      print('Shorter words available: ${shorterWords.length}');
      print('Shorter words: ${shorterWords.join(', ')}');
      
      for (final word in shorterWords) {
        if (targetWords.length >= maxTargetWords) break;
        if (!targetWords.contains(word.toUpperCase())) {
          targetWords.add(word.toUpperCase());
        }
      }
    }
    
    print('Final target words: ${targetWords.length}');
    print('Target words: ${targetWords.join(', ')}');
  }
  
  print('\n✅ Test completed!');
}