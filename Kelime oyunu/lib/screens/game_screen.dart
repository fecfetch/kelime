import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/game_state_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/language_provider.dart';
import '../models/game_level.dart';
import '../widgets/letter_circle.dart';
import '../widgets/word_grid.dart';
import '../widgets/current_word_display.dart';
import '../widgets/tutorial_overlay.dart';
import '../services/level_service.dart';
import 'settings_screen.dart';

class GameScreen extends StatefulWidget {
  final int world;
  final int subWorld;
  final int level;

  const GameScreen({
    super.key,
    required this.world,
    required this.subWorld,
    required this.level,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameStateProvider gameState;
  late ProgressProvider progress;
  GameLevel? currentLevel;
  bool isLoading = true;
  bool showTutorial = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLevel();
    });
  }

  Future<void> _loadLevel() async {
    gameState = context.read<GameStateProvider>();
    progress = context.read<ProgressProvider>();
    final languageProvider = context.read<LanguageProvider>();

    gameState.setCurrentLevel(widget.world, widget.subWorld, widget.level);

    // Load level data with language settings
    currentLevel = await LevelService.loadLevel(
      widget.world, 
      widget.subWorld, 
      widget.level,
      nativeLanguage: languageProvider.nativeLanguage,
      targetLanguage: languageProvider.targetLanguage,
    );

    if (currentLevel != null) {
      gameState.setGameLevel(currentLevel!);

      // Load any saved progress
      final savedProgress = await progress.getLevelProgress(
          widget.world, widget.subWorld, widget.level);
      for (String word in savedProgress) {
        gameState.addFoundWord(word);
      }
    }

    // Check if this is the first time playing
    await _checkFirstTime();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('has_seen_tutorial') ?? false;

    // Show tutorial for first level of first world
    if (!hasSeenTutorial &&
        widget.world == 0 &&
        widget.subWorld == 0 &&
        widget.level == 0) {
      if (mounted) {
        setState(() {
          showTutorial = true;
        });
      }
    }
  }

  void _completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_tutorial', true);

    if (mounted) {
      setState(() {
        showTutorial = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (currentLevel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: const Center(
          child: Text('Seviye yüklenemedi'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${gameState.currentSubWorldName} - Level ${widget.level + 1}'),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        actions: [
          // Ruby counter
          Consumer<ProgressProvider>(
            builder: (context, progress, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.diamond, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('${progress.rubies}'),
                  ],
                ),
              );
            },
          ),
          // Hint button
          IconButton(
            onPressed: _useHint,
            icon: const Icon(Icons.lightbulb),
          ),
          // Shuffle button
          IconButton(
            onPressed: _shuffleLetters,
            icon: const Icon(Icons.shuffle),
          ),
          // Settings button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          // Tutorial button
          IconButton(
            onPressed: () {
              setState(() {
                showTutorial = true;
              });
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4A90E2),
                  Color(0xFF7B68EE),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight,
                  ),
                  child: Column(
                    children: [
                      // Hints section
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          currentLevel!.hints,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Current word display
                      const CurrentWordDisplay(),

                      // Letter circle
                      SizedBox(
                        height: 300,
                        child: LetterCircle(
                          letters: currentLevel!.sourceWord.split(''),
                          onWordFormed: _onWordFormed,
                        ),
                      ),

                      // Word grid
                      Container(
                        constraints: const BoxConstraints(minHeight: 200),
                        child: WordGrid(
                          targetWords: currentLevel!.targetWords,
                          hints: currentLevel!.hints.split(' | '),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tutorial overlay
          if (showTutorial)
            TutorialOverlay(
              onComplete: _completeTutorial,
              onWordFormed: _onTutorialWordFormed,
              onCardTapped: _onTutorialCardTapped,
            ),
        ],
      ),
    );
  }

  void _onWordFormed(String word) {
    final upperWord = word.toUpperCase();

    if (currentLevel!.targetWords.contains(upperWord)) {
      if (!gameState.isWordFound(upperWord)) {
        gameState.addFoundWord(upperWord);
        _saveProgress();

        // Check if game is complete
        if (gameState.isGameComplete) {
          _onLevelComplete();
        }

        _showWordFoundFeedback(upperWord, true);
      } else {
        _showWordFoundFeedback(upperWord, false, isAlreadyFound: true);
      }
    } else if (currentLevel!.validWords.contains(upperWord.toLowerCase())) {
      // Bonus word
      progress.addRubies(1);
      _showWordFoundFeedback(upperWord, true, isBonus: true);
    } else {
      _showWordFoundFeedback(upperWord, false);
    }
  }

  void _showWordFoundFeedback(String word, bool isCorrect,
      {bool isAlreadyFound = false, bool isBonus = false}) {
    if (!mounted) return;

    Color color;
    String message;

    if (isAlreadyFound) {
      color = Colors.orange;
      message = 'Zaten bulundu!';
    } else if (isBonus) {
      color = Colors.green;
      message = 'Bonus kelime! +1 💎';
    } else if (isCorrect) {
      color = Colors.green;
      message = 'Harika!';
    } else {
      color = Colors.red;
      message = 'Tekrar deneyin';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$word - $message'),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _saveProgress() async {
    await progress.saveLevelProgress(
        widget.world, widget.subWorld, widget.level, gameState.foundWords);
  }

  void _onLevelComplete() async {
    // Clear saved progress
    await progress.clearLevelProgress(
        widget.world, widget.subWorld, widget.level);

    // Unlock next level
    int nextLevel = widget.level + 1;
    int nextSubWorld = widget.subWorld;
    int nextWorld = widget.world;

    if (nextLevel >= WorldData.getNumLevels(widget.world, widget.subWorld)) {
      nextLevel = 0;
      nextSubWorld++;
      if (nextSubWorld >= WorldData.numSubWorlds) {
        nextSubWorld = 0;
        nextWorld++;
      }
    }

    await progress.unlockNextLevel(nextWorld, nextSubWorld, nextLevel);

    // Add completion reward
    await progress.addRubies(5);

    // Show completion dialog
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Seviye Tamamlandı!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tebrikler!'),
            SizedBox(height: 10),
            Text('5 💎 kazandınız'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to level select
            },
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );
  }

  void _useHint() async {
    const hintCost = 2;
    if (await progress.spendRubies(hintCost)) {
      // Use the new hint system to reveal a letter
      gameState.useHint();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bir harf açıldı!'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yeterli elmas yok! 2 💎 gerekli'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _shuffleLetters() {
    // This will be handled by the LetterCircle widget
    setState(() {});
  }

  void _onTutorialWordFormed() {
    // Auto-advance tutorial when user forms a word during interactive step
    // This will be handled by the tutorial overlay
  }

  void _onTutorialCardTapped() {
    // Auto-advance tutorial when user taps a card during interactive step
    // This will be handled by the tutorial overlay
  }
}
