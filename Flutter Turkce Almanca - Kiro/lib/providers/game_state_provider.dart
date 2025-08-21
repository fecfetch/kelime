import 'package:flutter/foundation.dart';
import '../models/game_level.dart';

class GameStateProvider extends ChangeNotifier {
  int _currentWorld = 0;
  int _currentSubWorld = 0;
  int _currentLevel = 0;
  String _currentSubWorldName = "Subworld name";
  
  GameLevel? _currentGameLevel;
  final List<String> _foundWords = [];
  List<String> _currentWord = [];
  bool _isGameComplete = false;
  
  // Hard mode setting
  bool _isHardMode = false;
  
  // Hint system - track revealed letters for each word
  final Map<String, Set<int>> _revealedLetters = {};
  
  // Getters
  int get currentWorld => _currentWorld;
  int get currentSubWorld => _currentSubWorld;
  int get currentLevel => _currentLevel;
  String get currentSubWorldName => _currentSubWorldName;
  GameLevel? get currentGameLevel => _currentGameLevel;
  List<String> get foundWords => _foundWords;
  List<String> get currentWord => _currentWord;
  bool get isGameComplete => _isGameComplete;
  bool get isHardMode => _isHardMode;
  
  // Setters
  void setCurrentLevel(int world, int subWorld, int level) {
    _currentWorld = world;
    _currentSubWorld = subWorld;
    _currentLevel = level;
    _currentSubWorldName = "World $world - Sub $subWorld";
    notifyListeners();
  }
  
  void setGameLevel(GameLevel level) {
    _currentGameLevel = level;
    _foundWords.clear();
    _currentWord.clear();
    _isGameComplete = false;
    notifyListeners();
  }
  
  void addFoundWord(String word) {
    if (!_foundWords.contains(word)) {
      _foundWords.add(word);
      _checkGameComplete();
      notifyListeners();
    }
  }
  
  void setCurrentWord(List<String> letters) {
    _currentWord = letters;
    notifyListeners();
  }
  
  void clearCurrentWord() {
    _currentWord.clear();
    notifyListeners();
  }
  
  String getCurrentWordString() {
    return _currentWord.join('');
  }
  
  void _checkGameComplete() {
    if (_currentGameLevel != null) {
      _isGameComplete = _currentGameLevel!.targetWords.every(
        (word) => _foundWords.contains(word.toUpperCase())
      );
    }
  }
  
  bool isWordFound(String word) {
    return _foundWords.contains(word.toUpperCase());
  }
  
  void resetGame() {
    _foundWords.clear();
    _currentWord.clear();
    _isGameComplete = false;
    _revealedLetters.clear();
    notifyListeners();
  }
  
  // Hard mode methods
  void toggleHardMode() {
    _isHardMode = !_isHardMode;
    notifyListeners();
  }
  
  void setHardMode(bool value) {
    _isHardMode = value;
    notifyListeners();
  }
  
  // Hint system methods
  bool isLetterRevealed(String word, int letterIndex) {
    return _revealedLetters[word.toUpperCase()]?.contains(letterIndex) ?? false;
  }
  
  void revealLetter(String word, int letterIndex) {
    final upperWord = word.toUpperCase();
    _revealedLetters[upperWord] ??= <int>{};
    _revealedLetters[upperWord]!.add(letterIndex);
    notifyListeners();
  }
  
  // Get the next letter to reveal when hint button is pressed
  void useHint() {
    if (_currentGameLevel == null) return;
    
    // Find unfound words
    final unfoundWords = _currentGameLevel!.targetWords
        .where((word) => !isWordFound(word))
        .toList();
    
    if (unfoundWords.isEmpty) return;
    
    // Find a word that has started being revealed but isn't complete yet
    String? targetWord;
    
    // First, look for a word that has some letters revealed but not all
    for (final word in unfoundWords) {
      final revealedCount = _revealedLetters[word]?.length ?? 0;
      if (revealedCount > 0 && revealedCount < word.length) {
        targetWord = word;
        break;
      }
    }
    
    // If no partially revealed word found, find the next word to start revealing
    if (targetWord == null && unfoundWords.isNotEmpty) {
      // Look for words that haven't been revealed at all yet
      for (final word in unfoundWords) {
        final revealedCount = _revealedLetters[word]?.length ?? 0;
        if (revealedCount == 0) {
          targetWord = word;
          break;
        }
      }
      
      // If all words have some letters revealed, find the next word that isn't fully revealed
      if (targetWord == null) {
        for (final word in unfoundWords) {
          final revealedCount = _revealedLetters[word]?.length ?? 0;
          if (revealedCount < word.length) {
            targetWord = word;
            break;
          }
        }
      }
    }
    
    // If we found a word to reveal a letter from
    if (targetWord != null) {
      final revealedSet = _revealedLetters[targetWord] ?? <int>{};
      
      // Get all unrevealed letter positions
      final unrevealedPositions = <int>[];
      for (int i = 0; i < targetWord.length; i++) {
        if (!revealedSet.contains(i)) {
          unrevealedPositions.add(i);
        }
      }
      
      // Reveal a random unrevealed letter
      if (unrevealedPositions.isNotEmpty) {
        final randomIndex = unrevealedPositions[
          DateTime.now().millisecondsSinceEpoch % unrevealedPositions.length
        ];
        revealLetter(targetWord, randomIndex);
      }
    }
  }
  
  // Get revealed letters count for a word
  int getRevealedLettersCount(String word) {
    return _revealedLetters[word.toUpperCase()]?.length ?? 0;
  }
}