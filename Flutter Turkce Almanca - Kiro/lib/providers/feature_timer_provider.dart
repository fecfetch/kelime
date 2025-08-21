import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feature_timer.dart';

class FeatureTimerProvider extends ChangeNotifier {
  late FeatureTimerManager _timerManager;
  Timer? _refreshTimer;
  
  // Per-level hint tracking
  final Map<String, Set<int>> _levelHints = {};
  
  FeatureTimerManager get timerManager => _timerManager;
  
  // Getters for easy access
  FeatureTimer get translationTimer => _timerManager.translationTimer;
  FeatureTimer get letterTimer => _timerManager.letterTimer;
  FeatureTimer get audioTimer => _timerManager.audioTimer;
  FeatureTimer get definitionTimer => _timerManager.definitionTimer;
  
  FeatureTimerProvider() {
    _timerManager = FeatureTimerManager();
    _startRefreshTimer();
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  void _startRefreshTimer() {
    // Refresh timers every minute to update UI
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _timerManager.refillAllTimers();
      notifyListeners();
    });
  }
  
  // Translation timer methods
  bool canUseTranslation() => translationTimer.canUse();
  
  void useTranslation() {
    if (canUseTranslation()) {
      translationTimer.use();
      _saveTimers();
      notifyListeners();
    }
  }
  
  void addTranslationHints(int amount) {
    translationTimer.addCount(amount);
    _saveTimers();
    notifyListeners();
  }
  
  void setUnlimitedTranslation(Duration duration) {
    translationTimer.setUnlimited(duration);
    _saveTimers();
    notifyListeners();
  }
  
  // Letter timer methods
  bool canUseLetter() => letterTimer.canUse();
  
  void useLetter() {
    if (canUseLetter()) {
      letterTimer.use();
      _saveTimers();
      notifyListeners();
    }
  }
  
  void addLetterHints(int amount) {
    letterTimer.addCount(amount);
    _saveTimers();
    notifyListeners();
  }
  
  void setUnlimitedLetter(Duration duration) {
    letterTimer.setUnlimited(duration);
    _saveTimers();
    notifyListeners();
  }
  
  // Audio timer methods
  bool canUseAudio() => audioTimer.canUse();
  
  void useAudio() {
    if (canUseAudio()) {
      audioTimer.use();
      _saveTimers();
      notifyListeners();
    }
  }
  
  void addAudioPlays(int amount) {
    audioTimer.addCount(amount);
    _saveTimers();
    notifyListeners();
  }
  
  // Definition timer methods
  bool canUseDefinition() => definitionTimer.canUse();
  
  void useDefinition() {
    if (canUseDefinition()) {
      definitionTimer.use();
      _saveTimers();
      notifyListeners();
    }
  }
  
  void addDefinitions(int amount) {
    definitionTimer.addCount(amount);
    _saveTimers();
    notifyListeners();
  }
  
  // Extension methods (for ads and ruby purchases)
  void watchAdForTranslations() {
    addTranslationHints(2);
    // TODO: Integrate with ad system
  }
  
  void buyTranslationBoost(int rubyCost) {
    // TODO: Integrate with ruby system
    addTranslationHints(5);
  }
  
  void buyUnlimitedTranslations(int rubyCost, Duration duration) {
    // TODO: Integrate with ruby system
    setUnlimitedTranslation(duration);
  }
  
  // Save/Load methods
  Future<void> loadTimers() async {
    final prefs = await SharedPreferences.getInstance();
    final timersJson = prefs.getString('feature_timers');
    
    if (timersJson != null) {
      try {
        final timersData = jsonDecode(timersJson);
        _timerManager.fromJson(timersData);
        
        // Load hint tracking data
        if (timersData['levelHints'] != null) {
          final hintsData = timersData['levelHints'] as Map<String, dynamic>;
          _levelHints.clear();
          hintsData.forEach((key, value) {
            _levelHints[key] = Set<int>.from(value as List);
          });
        }
        
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading feature timers: $e');
      }
    }
  }
  
  Future<void> _saveTimers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _timerManager.toJson();
    
    // Add hint tracking data
    data['levelHints'] = _levelHints.map((key, value) => MapEntry(key, value.toList()));
    
    final timersJson = jsonEncode(data);
    await prefs.setString('feature_timers', timersJson);
  }
  
  // Per-level hint tracking methods
  String _getLevelKey(int world, int subWorld, int level) {
    return 'hints_${world}_${subWorld}_$level';
  }
  
  Set<int> getRevealedHints(int world, int subWorld, int level) {
    final key = _getLevelKey(world, subWorld, level);
    return _levelHints[key] ?? {};
  }
  
  void addRevealedHint(int world, int subWorld, int level, int hintIndex) {
    final key = _getLevelKey(world, subWorld, level);
    _levelHints[key] ??= {};
    _levelHints[key]!.add(hintIndex);
    _saveTimers();
    notifyListeners();
  }
  
  void autoRevealHintForFoundWord(int world, int subWorld, int level, String targetWord, List<String> targetWords) {
    // Find the index of the target word in the list
    final wordIndex = targetWords.indexWhere((word) => word.toUpperCase() == targetWord.toUpperCase());
    
    if (wordIndex != -1) {
      final key = _getLevelKey(world, subWorld, level);
      _levelHints[key] ??= {};
      
      // Only add if not already revealed
      if (!_levelHints[key]!.contains(wordIndex)) {
        _levelHints[key]!.add(wordIndex);
        _saveTimers();
        notifyListeners();
      }
    }
  }
  
  // Utility methods
  String getTranslationTimerDisplay() {
    final timer = translationTimer;
    if (timer.currentCount > 0) {
      // Show current count, but cap the display of max at the actual max
      // This way if user has 8 hints, it shows "8/3" indicating they have extra
      return '${timer.currentCount}/${timer.maxCount}';
    } else {
      final timeUntilNext = timer.getTimeUntilNextRefill();
      final minutes = timeUntilNext.inMinutes;
      final seconds = timeUntilNext.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    }
  }
  
  String getLetterTimerDisplay() {
    final timer = letterTimer;
    if (timer.currentCount > 0) {
      // Show current count, allowing display of extra purchased hints
      return '${timer.currentCount}/${timer.maxCount}';
    } else {
      final timeUntilNext = timer.getTimeUntilNextRefill();
      final minutes = timeUntilNext.inMinutes;
      final seconds = timeUntilNext.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    }
  }

  String getAudioTimerDisplay() {
    final timer = audioTimer;
    if (timer.currentCount > 0) {
      // Show current count, allowing display of extra purchased hints
      return '${timer.currentCount}/${timer.maxCount}';
    } else {
      final timeUntilNext = timer.getTimeUntilNextRefill();
      final minutes = timeUntilNext.inMinutes;
      final seconds = timeUntilNext.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    }
  }
}