import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _userLanguageKey = 'user_language';
  static const String _sourceLanguageKey = 'source_language';
  static const String _cefrLevelKey = 'cefr_level';
  
  static UserPreferencesService? _instance;
  static UserPreferencesService get instance {
    _instance ??= UserPreferencesService._();
    return _instance!;
  }
  
  UserPreferencesService._();
  
  SharedPreferences? _prefs;
  
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  // User's native language (for hints/translations)
  Future<String> getUserLanguage() async {
    await _initPrefs();
    return _prefs!.getString(_userLanguageKey) ?? 'turkish';
  }
  
  Future<void> setUserLanguage(String languageCode) async {
    await _initPrefs();
    await _prefs!.setString(_userLanguageKey, languageCode);
  }
  
  // Source language (language being learned)
  Future<String> getSourceLanguage() async {
    await _initPrefs();
    return _prefs!.getString(_sourceLanguageKey) ?? 'en';
  }
  
  Future<void> setSourceLanguage(String languageCode) async {
    await _initPrefs();
    await _prefs!.setString(_sourceLanguageKey, languageCode);
  }
  
  // CEFR Level
  Future<String> getCEFRLevel() async {
    await _initPrefs();
    return _prefs!.getString(_cefrLevelKey) ?? 'A1';
  }
  
  Future<void> setCEFRLevel(String level) async {
    await _initPrefs();
    await _prefs!.setString(_cefrLevelKey, level);
  }
  
  // Get level file name based on preferences
  Future<String> getLevelFileName() async {
    final sourceLanguage = await getSourceLanguage();
    final cefrLevel = await getCEFRLevel();
    return '${sourceLanguage}_${cefrLevel.toLowerCase()}_levels.json';
  }
  
  // Available languages for hints
  static const Map<String, String> availableLanguages = {
    'turkish': 'Türkçe',
    'english': 'English',
    'german': 'Deutsch',
    'spanish': 'Español',
    'chinese': '中文',
    'hindi': 'हिन्दी',
    'french': 'Français',
  };
  
  // Available source languages (languages that can be learned)
  static const Map<String, String> availableSourceLanguages = {
    'en': 'English',
    'de': 'German',
    'es': 'Spanish',
    'fr': 'French',
  };
  
  // Available CEFR levels
  static const List<String> availableCEFRLevels = [
    'A1', 'A2', 'B1', 'B2', 'C1', 'C2'
  ];
}