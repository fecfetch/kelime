import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/game_state_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/language_provider.dart';
import '../providers/feature_timer_provider.dart';
import '../models/game_level.dart';
import '../widgets/letter_circle.dart';
import '../widgets/word_grid.dart';
import '../widgets/current_word_display.dart';
import '../widgets/tutorial_overlay.dart';
import '../widgets/translation_hints_widget.dart';
import '../widgets/circular_hint_button.dart';
import '../widgets/circular_letter_hint_button.dart';
import '../services/level_service.dart';
import '../services/user_preferences_service.dart';
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
                      // Translation hints section
                      FutureBuilder<String>(
                        future: UserPreferencesService.instance.getUserLanguage(),
                        builder: (context, snapshot) {
                          final userLanguage = snapshot.data ?? 'turkish';
                          return TranslationHintsWidget(
                            key: ValueKey('hints_${widget.world}_${widget.subWorld}_${widget.level}'),
                            hints: currentLevel!.hints,
                            targetWords: currentLevel!.targetWords,
                            world: widget.world,
                            subWorld: widget.subWorld,
                            level: widget.level,
                            userLanguage: userLanguage,
                          );
                        },
                      ),

                      // Current word display
                      const CurrentWordDisplay(),

                      // Letter circle with hint buttons
                      SizedBox(
                        height: 300,
                        child: Row(
                          children: [
                            // Letter hint button (left side)
                            SizedBox(
                              width: 120,
                              child: Center(
                                child: CircularLetterHintButton(
                                  onLetterRevealed: () {
                                    // Trigger a rebuild to show revealed letters
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            
                            // Letter circle
                            Expanded(
                              child: LetterCircle(
                                letters: currentLevel!.sourceWord.split(''),
                                onWordFormed: _onWordFormed,
                              ),
                            ),
                            
                            // Translation hint button (right side)
                            SizedBox(
                              width: 120,
                              child: Center(
                                child: CircularHintButton(
                                  hints: currentLevel!.hints,
                                  targetWords: currentLevel!.targetWords,
                                  world: widget.world,
                                  subWorld: widget.subWorld,
                                  level: widget.level,
                                  onHintRevealed: () {
                                    // Trigger a rebuild of the translation hints widget
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
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
        
        // Auto-reveal the translation for the found word
        final timerProvider = context.read<FeatureTimerProvider>();
        timerProvider.autoRevealHintForFoundWord(
          widget.world, 
          widget.subWorld, 
          widget.level, 
          upperWord, 
          currentLevel!.targetWords
        );

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
