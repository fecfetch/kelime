import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SupportedLanguage {
  english('en', 'English'),
  german('de', 'Deutsch'),
  french('fr', 'Français'),
  spanish('es', 'Español'),
  turkish('tr', 'Türkçe'),
  portuguese('pt', 'Português'),
  italian('it', 'Italiano');

  const SupportedLanguage(this.code, this.nativeName);
  
  final String code;
  final String nativeName;
  
  static SupportedLanguage fromCode(String code) {
    return SupportedLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => SupportedLanguage.english,
    );
  }
}

class LanguageProvider extends ChangeNotifier {
  SupportedLanguage _nativeLanguage = SupportedLanguage.english;
  SupportedLanguage _targetLanguage = SupportedLanguage.german;
  Locale _appLocale = const Locale('en');
  
  // Getters
  SupportedLanguage get nativeLanguage => _nativeLanguage;
  SupportedLanguage get targetLanguage => _targetLanguage;
  Locale get appLocale => _appLocale;
  
  // Available languages for learning (can be expanded)
  List<SupportedLanguage> get availableNativeLanguages => [
    SupportedLanguage.english,
    SupportedLanguage.german,
    SupportedLanguage.french,
    SupportedLanguage.spanish,
    SupportedLanguage.turkish,
  ];
  
  List<SupportedLanguage> get availableTargetLanguages => [
    SupportedLanguage.german,
    SupportedLanguage.french,
    SupportedLanguage.spanish,
    SupportedLanguage.italian,
    SupportedLanguage.portuguese,
  ];
  
  /// Initialize language settings from SharedPreferences
  Future<void> loadLanguageSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if this is the first time the app is launched
    final isFirstLaunch = !prefs.containsKey('native_language') && !prefs.containsKey('target_language');
    
    if (isFirstLaunch) {
      // For new users, default to English UI with German learning
      // This provides a better experience for international users
      _nativeLanguage = SupportedLanguage.english;
      _targetLanguage = SupportedLanguage.german;
      
      // Save these defaults
      await prefs.setString('native_language', _nativeLanguage.code);
      await prefs.setString('target_language', _targetLanguage.code);
    } else {
      // Load saved settings for existing users
      final nativeCode = prefs.getString('native_language') ?? 'en';
      _nativeLanguage = SupportedLanguage.fromCode(nativeCode);
      
      final targetCode = prefs.getString('target_language') ?? 'de';
      _targetLanguage = SupportedLanguage.fromCode(targetCode);
      
      // Special handling: If user has Turkish native + English target (old default),
      // and they haven't explicitly chosen this, offer them the new default
      if (_nativeLanguage == SupportedLanguage.turkish && 
          _targetLanguage == SupportedLanguage.english &&
          !(prefs.getBool('language_choice_confirmed') ?? false)) {
        // Switch to the new default for better international experience
        _nativeLanguage = SupportedLanguage.english;
        _targetLanguage = SupportedLanguage.german;
        
        // Save the new settings
        await prefs.setString('native_language', _nativeLanguage.code);
        await prefs.setString('target_language', _targetLanguage.code);
        await prefs.setBool('language_choice_confirmed', true);
      }
    }
    
    // Set app locale to native language
    _appLocale = Locale(_nativeLanguage.code);
    
    notifyListeners();
  }
  
  /// Save language settings to SharedPreferences
  Future<void> saveLanguageSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('native_language', _nativeLanguage.code);
    await prefs.setString('target_language', _targetLanguage.code);
  }
  
  /// Change native language (UI language)
  Future<void> setNativeLanguage(SupportedLanguage language) async {
    if (_nativeLanguage != language) {
      _nativeLanguage = language;
      _appLocale = Locale(language.code);
      await saveLanguageSettings();
      notifyListeners();
    }
  }
  
  /// Change target language (learning language)
  Future<void> setTargetLanguage(SupportedLanguage language) async {
    if (_targetLanguage != language) {
      _targetLanguage = language;
      await saveLanguageSettings();
      notifyListeners();
    }
  }
  
  /// Set both languages at once
  Future<void> setLanguages({
    required SupportedLanguage nativeLanguage,
    required SupportedLanguage targetLanguage,
  }) async {
    bool changed = false;
    
    if (_nativeLanguage != nativeLanguage) {
      _nativeLanguage = nativeLanguage;
      _appLocale = Locale(nativeLanguage.code);
      changed = true;
    }
    
    if (_targetLanguage != targetLanguage) {
      _targetLanguage = targetLanguage;
      changed = true;
    }
    
    if (changed) {
      await saveLanguageSettings();
      
      // Mark that the user has explicitly chosen their language combination
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('language_choice_confirmed', true);
      
      notifyListeners();
    }
  }
  
  /// Get localized language name based on current native language
  String getLocalizedLanguageName(SupportedLanguage language, BuildContext context) {
    // This will be used to show language names in the user's native language
    // For now, return the native name, but this can be expanded with proper localization
    switch (language) {
      case SupportedLanguage.english:
        return 'English';
      case SupportedLanguage.german:
        return 'German';
      case SupportedLanguage.french:
        return 'French';
      case SupportedLanguage.spanish:
        return 'Spanish';
      case SupportedLanguage.turkish:
        return 'Turkish';
      case SupportedLanguage.portuguese:
        return 'Portuguese';
      case SupportedLanguage.italian:
        return 'Italian';
    }
  }
  
  /// Check if current language combination is valid for learning
  bool get isValidLanguageCombination {
    return _nativeLanguage != _targetLanguage;
  }
  
  /// Get language combination description
  String get languageCombinationDescription {
    return '${_nativeLanguage.nativeName} → ${_targetLanguage.nativeName}';
  }
}