import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/game_level.dart';
import '../providers/language_provider.dart';

class UniversalLevelLoader {
  static final Map<String, Map<String, dynamic>> _levelCache = {};
  static final Random _random = Random();

  /// Load a level for the given language combination
  static Future<GameLevel?> loadLevel(
    int world,
    int subWorld,
    int level, {
    required SupportedLanguage nativeLanguage,
    required SupportedLanguage targetLanguage,
    String cefrLevel = 'A1',
  }) async {
    try {
      // Generate cache key
      final cacheKey = '${targetLanguage.code}_${cefrLevel.toLowerCase()}_${nativeLanguage.code}';
      
      // Load levels if not cached
      if (!_levelCache.containsKey(cacheKey)) {
        await _loadLevelsFromAssets(cacheKey, targetLanguage, nativeLanguage, cefrLevel);
      }

      final levelData = _levelCache[cacheKey];
      if (levelData == null || levelData['levels'] == null) {
        return null;
      }

      final levels = levelData['levels'] as List;
      if (levels.isEmpty) {
        return null;
      }

      // Calculate level index based on world, subWorld, and level
      // This ensures consistent level selection for the same coordinates
      final levelIndex = _calculateLevelIndex(world, subWorld, level, levels.length);
      final selectedLevel = levels[levelIndex];

      return GameLevel(
        hints: selectedLevel['hints'] as String,
        sourceWord: selectedLevel['sourceWord'] as String,
        targetWords: List<String>.from(selectedLevel['targetWords']),
        validWords: List<String>.from(selectedLevel['validWords']),
      );
    } catch (e) {
      print('Error loading level: $e');
      return null;
    }
  }

  /// Load levels from assets and cache them
  static Future<void> _loadLevelsFromAssets(
    String cacheKey,
    SupportedLanguage targetLanguage,
    SupportedLanguage nativeLanguage,
    String cefrLevel,
  ) async {
    try {
      final fileName = '${targetLanguage.code}_${cefrLevel.toLowerCase()}_levels_${nativeLanguage.code}.json';
      final assetPath = 'assets/levels/$fileName';
      
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      
      _levelCache[cacheKey] = jsonData;
      
      print('✅ Loaded ${(jsonData['levels'] as List).length} levels for $cacheKey');
    } catch (e) {
      print('⚠️  Failed to load levels for $cacheKey: $e');
      // Create fallback level data
      _levelCache[cacheKey] = {
        'metadata': {
          'targetLanguage': targetLanguage.code,
          'nativeLanguage': nativeLanguage.code,
          'cefrLevel': cefrLevel,
          'totalLevels': 1,
        },
        'levels': [_createFallbackLevel(targetLanguage, nativeLanguage)]
      };
    }
  }

  /// Create a simple fallback level when no pre-generated levels are available
  static Map<String, dynamic> _createFallbackLevel(SupportedLanguage targetLanguage, SupportedLanguage nativeLanguage) {
    // Simple fallback based on target language
    switch (targetLanguage) {
      case SupportedLanguage.english:
        return {
          'levelId': 1,
          'sourceWord': 'SIMPLE',
          'targetWords': ['SIMPLE', 'SIM', 'ME'],
          'hints': nativeLanguage == SupportedLanguage.german ? 'einfach | sim | ich' : 'basit | sim | ben',
          'validWords': ['simple', 'sim', 'me', 'is'],
          'difficulty': 3,
        };
      case SupportedLanguage.german:
        return {
          'levelId': 1,
          'sourceWord': 'EINFACH',
          'targetWords': ['EINFACH', 'EIN', 'ICH'],
          'hints': nativeLanguage == SupportedLanguage.english ? 'simple | one | I' : 'basit | bir | ben',
          'validWords': ['einfach', 'ein', 'ich', 'fach'],
          'difficulty': 3,
        };
      case SupportedLanguage.turkish:
        return {
          'levelId': 1,
          'sourceWord': 'KOLAY',
          'targetWords': ['KOLAY', 'KOL', 'LAY'],
          'hints': nativeLanguage == SupportedLanguage.english ? 'easy | arm | lay' : 'einfach | arm | legen',
          'validWords': ['kolay', 'kol', 'lay', 'kay'],
          'difficulty': 3,
        };
    }
  }

  /// Calculate consistent level index based on coordinates
  static int _calculateLevelIndex(int world, int subWorld, int level, int totalLevels) {
    // Create a deterministic but varied level selection
    // This ensures the same coordinates always give the same level
    final seed = world * 1000 + subWorld * 100 + level;
    final random = Random(seed);
    return random.nextInt(totalLevels);
  }

  /// Check if levels are available for a language combination
  static Future<bool> hasLevelsFor({
    required SupportedLanguage nativeLanguage,
    required SupportedLanguage targetLanguage,
    String cefrLevel = 'A1',
  }) async {
    try {
      final cacheKey = '${targetLanguage.code}_${cefrLevel.toLowerCase()}_${nativeLanguage.code}';
      
      if (!_levelCache.containsKey(cacheKey)) {
        await _loadLevelsFromAssets(cacheKey, targetLanguage, nativeLanguage, cefrLevel);
      }

      final levelData = _levelCache[cacheKey];
      return levelData != null && 
             levelData['levels'] != null && 
             (levelData['levels'] as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get metadata for a language combination
  static Future<Map<String, dynamic>?> getMetadata({
    required SupportedLanguage nativeLanguage,
    required SupportedLanguage targetLanguage,
    String cefrLevel = 'A1',
  }) async {
    try {
      final cacheKey = '${targetLanguage.code}_${cefrLevel.toLowerCase()}_${nativeLanguage.code}';
      
      if (!_levelCache.containsKey(cacheKey)) {
        await _loadLevelsFromAssets(cacheKey, targetLanguage, nativeLanguage, cefrLevel);
      }

      final levelData = _levelCache[cacheKey];
      return levelData?['metadata'] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Clear the level cache (useful for testing or memory management)
  static void clearCache() {
    _levelCache.clear();
  }

  /// Get available level count for a language combination
  static Future<int> getLevelCount({
    required SupportedLanguage nativeLanguage,
    required SupportedLanguage targetLanguage,
    String cefrLevel = 'A1',
  }) async {
    try {
      final cacheKey = '${targetLanguage.code}_${cefrLevel.toLowerCase()}_${nativeLanguage.code}';
      
      if (!_levelCache.containsKey(cacheKey)) {
        await _loadLevelsFromAssets(cacheKey, targetLanguage, nativeLanguage, cefrLevel);
      }

      final levelData = _levelCache[cacheKey];
      if (levelData == null || levelData['levels'] == null) {
        return 0;
      }

      return (levelData['levels'] as List).length;
    } catch (e) {
      return 0;
    }
  }
}