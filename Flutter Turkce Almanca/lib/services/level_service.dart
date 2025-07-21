import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/game_level.dart';
import '../providers/language_provider.dart';
import 'level_generator.dart';

class LevelService {
  // Keep some handcrafted levels for the first few levels
  static final Map<String, GameLevel> _handcraftedLevels = {
    '0_0_0': GameLevel(
      hints: 'Yapmak | Tamam | İskele',
      sourceWord: 'dock',
      targetWords: ['DO', 'OK', 'DOCK'],
      validWords: ['do', 'ok', 'dock'],
    ),
    '0_0_1': GameLevel(
      hints: 'Bir | Ve',
      sourceWord: 'and',
      targetWords: ['AN', 'AND'],
      validWords: ['an', 'ad', 'and'],
    ),
    '0_0_2': GameLevel(
      hints: 'Ait | Veya | İçin',
      sourceWord: 'for',
      targetWords: ['OF', 'OR', 'FOR'],
      validWords: ['of', 'or', 'for'],
    ),
    '0_0_3': GameLevel(
      hints: 'Kedi | Araba | Sanat | Araba',
      sourceWord: 'cart',
      targetWords: ['CAT', 'CAR', 'ART', 'CART'],
      validWords: ['cat', 'car', 'art', 'cart', 'tar', 'rat'],
    ),
    '0_0_4': GameLevel(
      hints: 'Nasıl | Kim | Ah',
      sourceWord: 'who',
      targetWords: ['WHO', 'HOW', 'OH'],
      validWords: ['who', 'how', 'oh', 'ow'],
    ),
    '0_0_5': GameLevel(
      hints: 'Güneş | Biz',
      sourceWord: 'sun',
      targetWords: ['SUN', 'US'],
      validWords: ['sun', 'us', 'nu'],
    ),
    '0_0_6': GameLevel(
      hints: 'Koşmak | Ön ek',
      sourceWord: 'run',
      targetWords: ['RUN', 'UN'],
      validWords: ['run', 'un', 'nu'],
    ),
    '0_0_7': GameLevel(
      hints: 'Eğlence | Ön ek',
      sourceWord: 'fun',
      targetWords: ['FUN', 'UN'],
      validWords: ['fun', 'un', 'nu'],
    ),
    '0_0_8': GameLevel(
      hints: 'Köpek | Git',
      sourceWord: 'dog',
      targetWords: ['DOG', 'GO'],
      validWords: ['dog', 'go', 'god'],
    ),
    '0_0_9': GameLevel(
      hints: 'Ev | O | Ben',
      sourceWord: 'home',
      targetWords: ['HOME', 'HE', 'ME'],
      validWords: ['home', 'he', 'me', 'oh'],
    ),
    '0_0_10': GameLevel(
      hints: 'Takım | Yemek | Çay',
      sourceWord: 'team',
      targetWords: ['TEAM', 'EAT', 'TEA'],
      validWords: ['team', 'eat', 'tea', 'met', 'mat'],
    ),
    '0_0_11': GameLevel(
      hints: 'Su | Savaş | Sanat | Ham',
      sourceWord: 'water',
      targetWords: ['WATER', 'WAR', 'ART', 'RAW'],
      validWords: ['water', 'war', 'art', 'raw', 'rat', 'tar'],
    ),
    
    // Sub-world 1 levels (0_1_x)
    '0_1_0': GameLevel(
      hints: 'Mavi | Olmak',
      sourceWord: 'blue',
      targetWords: ['BLUE', 'BE'],
      validWords: ['blue', 'be', 'el', 'ue'],
    ),
    '0_1_1': GameLevel(
      hints: 'Kız',
      sourceWord: 'girl',
      targetWords: ['GIRL'],
      validWords: ['girl', 'gir'],
    ),
    '0_1_2': GameLevel(
      hints: 'Okul | Soğuk',
      sourceWord: 'school',
      targetWords: ['SCHOOL', 'COOL'],
      validWords: ['school', 'cool', 'look', 'hook'],
    ),
    '0_1_3': GameLevel(
      hints: 'Mutlu | Ödeme',
      sourceWord: 'happy',
      targetWords: ['HAPPY', 'PAY'],
      validWords: ['happy', 'pay', 'hay', 'app'],
    ),
    '0_1_4': GameLevel(
      hints: 'Dünya | Kelime | Lord',
      sourceWord: 'world',
      targetWords: ['WORLD', 'WORD', 'LORD'],
      validWords: ['world', 'word', 'lord', 'row', 'low'],
    ),
    
    // Sub-world 2 levels (0_2_x)
    '0_2_0': GameLevel(
      hints: 'Gece | Şey | İnce',
      sourceWord: 'night',
      targetWords: ['NIGHT', 'THING', 'THIN'],
      validWords: ['night', 'thing', 'thin', 'hint', 'gin'],
    ),
    '0_2_1': GameLevel(
      hints: 'Işık | Vurmak | O',
      sourceWord: 'light',
      targetWords: ['LIGHT', 'HIT', 'IT'],
      validWords: ['light', 'hit', 'it', 'lit', 'gilt'],
    ),
    '0_2_2': GameLevel(
      hints: 'Sağ | Kum | O',
      sourceWord: 'right',
      targetWords: ['RIGHT', 'GRIT', 'HER'],
      validWords: ['right', 'grit', 'her', 'hit', 'rig'],
    ),
    '0_2_3': GameLevel(
      hints: 'Küçük | Hepsi | Alışveriş merkezi',
      sourceWord: 'small',
      targetWords: ['SMALL', 'ALL', 'MALL'],
      validWords: ['small', 'all', 'mall', 'slam', 'am'],
    ),
    '0_2_4': GameLevel(
      hints: 'Beyaz | İle | Buğday',
      sourceWord: 'white',
      targetWords: ['WHITE', 'WITH', 'WHEAT'],
      validWords: ['white', 'with', 'wheat', 'the', 'hit'],
    ),
    
    // Sub-world 3 levels (0_3_x)
    '0_3_0': GameLevel(
      hints: 'Siyah | Geri | Eksiklik',
      sourceWord: 'black',
      targetWords: ['BLACK', 'BACK', 'LACK'],
      validWords: ['black', 'back', 'lack', 'cab', 'lab'],
    ),
    '0_3_1': GameLevel(
      hints: 'Yeşil | Gen | Yakın',
      sourceWord: 'green',
      targetWords: ['GREEN', 'GENE', 'NEAR'],
      validWords: ['green', 'gene', 'near', 'rage', 'gear'],
    ),
    '0_3_2': GameLevel(
      hints: 'Kırmızı | Var | Kulak',
      sourceWord: 'red',
      targetWords: ['RED', 'ARE', 'EAR'],
      validWords: ['red', 'are', 'ear', 'dear', 'read'],
    ),
    '0_3_3': GameLevel(
      hints: 'Sarı | Düşük | Baykuş',
      sourceWord: 'yellow',
      targetWords: ['YELLOW', 'LOW', 'OWL'],
      validWords: ['yellow', 'low', 'owl', 'well', 'yell'],
    ),
    '0_3_4': GameLevel(
      hints: 'Turuncu | Öfke | Menzil',
      sourceWord: 'orange',
      targetWords: ['ORANGE', 'ANGER', 'RANGE'],
      validWords: ['orange', 'anger', 'range', 'gear', 'near'],
    ),
    
    // Sub-world 4 levels (0_4_x)
    '0_4_0': GameLevel(
      hints: 'Aile | Posta | Başarısız',
      sourceWord: 'family',
      targetWords: ['FAMILY', 'MAIL', 'FAIL'],
      validWords: ['family', 'mail', 'fail', 'film', 'lay'],
    ),
    '0_4_1': GameLevel(
      hints: 'Arkadaş | Ateş | Binmek',
      sourceWord: 'friend',
      targetWords: ['FRIEND', 'FIRE', 'RIDE'],
      validWords: ['friend', 'fire', 'ride', 'find', 'fine'],
    ),
    '0_4_2': GameLevel(
      hints: 'Grup | Bizim | Dökmek',
      sourceWord: 'group',
      targetWords: ['GROUP', 'OUR', 'POUR'],
      validWords: ['group', 'our', 'pour', 'pro', 'rug'],
    ),
    '0_4_3': GameLevel(
      hints: 'Parti | Parça | Tuzak',
      sourceWord: 'party',
      targetWords: ['PARTY', 'PART', 'TRAP'],
      validWords: ['party', 'part', 'trap', 'try', 'pay'],
    ),
    '0_4_4': GameLevel(
      hints: 'Müzik | Hasta | Toplam',
      sourceWord: 'music',
      targetWords: ['MUSIC', 'SICK', 'SUM'],
      validWords: ['music', 'sick', 'sum', 'cum', 'mic'],
    ),
  };

  // Cache for loaded levels to avoid repeated file reads
  static final Map<String, GameLevel> _levelCache = {};

  static Future<GameLevel?> loadLevel(int world, int subWorld, int level, {
    SupportedLanguage? nativeLanguage,
    SupportedLanguage? targetLanguage,
  }) async {
    // Use default languages if not provided (for backward compatibility)
    nativeLanguage ??= SupportedLanguage.turkish;
    targetLanguage ??= SupportedLanguage.english;
    
    final key = '${world}_${subWorld}_${level}_${nativeLanguage.code}_${targetLanguage.code}';
    
    // Return from cache if already loaded
    if (_levelCache.containsKey(key)) {
      return _levelCache[key];
    }
    
    // For Turkish → English (original game), use handcrafted levels for first few levels
    if (nativeLanguage == SupportedLanguage.turkish && 
        targetLanguage == SupportedLanguage.english &&
        _handcraftedLevels.containsKey('${world}_${subWorld}_$level')) {
      _levelCache[key] = _handcraftedLevels['${world}_${subWorld}_$level']!;
      return _handcraftedLevels['${world}_${subWorld}_$level'];
    }
    
    try {
      // Try to load from pre-generated file first (for Turkish → English)
      if (nativeLanguage == SupportedLanguage.turkish && 
          targetLanguage == SupportedLanguage.english) {
        final preGeneratedLevel = await _loadPreGeneratedLevel(world, subWorld, level);
        if (preGeneratedLevel != null) {
          _levelCache[key] = preGeneratedLevel;
          return preGeneratedLevel;
        }
      }
      
      // Generate level using multilingual system
      final generatedLevel = await _generateMultilingualLevel(
        world, subWorld, level, nativeLanguage, targetLanguage);
      if (generatedLevel != null) {
        _levelCache[key] = generatedLevel;
      }
      return generatedLevel;
    } catch (e) {
      print('❌ Error loading level $world-$subWorld-$level: $e');
      return null;
    }
  }
  
  /// Generate a level using the existing sophisticated level generator with multilingual support
  static Future<GameLevel?> _generateMultilingualLevel(
    int world, int subWorld, int level,
    SupportedLanguage nativeLanguage,
    SupportedLanguage targetLanguage,
  ) async {
    try {
      // Use the level generator with proper language parameters
      return await LevelGenerator.generateLevel(
        world, 
        subWorld, 
        level,
        nativeLanguage: nativeLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (e) {
      // If generation fails, return null to let the caller handle it
      return null;
    }
  }
  
  /// Simple word validator - find words that can be formed from source letters
  static List<String> _findPossibleWords(String sourceWord, List<String> allWords) {
    final sourceLetters = sourceWord.toLowerCase().split('');
    final possibleWords = <String>[];

    for (final word in allWords) {
      if (word.length > sourceWord.length) continue;
      if (word.length < 2) continue;

      final wordLetters = word.toLowerCase().split('');
      final availableLetters = List<String>.from(sourceLetters);
      bool canForm = true;

      for (final letter in wordLetters) {
        if (availableLetters.contains(letter)) {
          availableLetters.remove(letter);
        } else {
          canForm = false;
          break;
        }
      }

      if (canForm) {
        possibleWords.add(word);
      }
    }

    return possibleWords;
  }
  
  /// Load a pre-generated level from assets
  static Future<GameLevel?> _loadPreGeneratedLevel(int world, int subWorld, int level) async {
    try {
      final fileName = 'assets/levels/level_${world}_${subWorld}_$level.json';
      final jsonString = await rootBundle.loadString(fileName);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      
      return GameLevel(
        hints: jsonData['hints'] as String,
        sourceWord: jsonData['sourceWord'] as String,
        targetWords: List<String>.from(jsonData['targetWords'] as List),
        validWords: List<String>.from(jsonData['validWords'] as List),
      );
    } catch (e) {
      // File not found or parsing error - this is expected for levels that haven't been pre-generated
      return null;
    }
  }
  
  /// Clear the level cache (useful for testing or memory management)
  static void clearCache() {
    _levelCache.clear();
  }
  
  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    return {
      'cachedLevels': _levelCache.length,
      'cacheKeys': _levelCache.keys.toList(),
    };
  }


}