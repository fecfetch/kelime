import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_preferences_service.dart';

enum SupportedLanguage {
  english('en', 'English'),
  german('de', 'Deutsch'),
  french('fr', 'Français'),
  spanish('es', 'Español'),
  turkish('tr', 'Türkçe'),
  chinese('zh', '中文'),
  hindi('hi', 'हिन्दी');

  const SupportedLanguage(this.code, this.nativeName);
  
  final String code;
  final String nativeName;
  
  static SupportedLanguage fromCode(String code) {
    try {
      return SupportedLanguage.values.firstWhere(
        (lang) => lang.code == code,
        orElse: () => SupportedLanguage.english,
      );
    } catch (e) {
      // If there's an error, return the default value
      return SupportedLanguage.english;
    }
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
  List<SupportedLanguage> get availableNativeLanguages {
    try {
      return [
        SupportedLanguage.english,
        SupportedLanguage.german,
        SupportedLanguage.french,
        SupportedLanguage.spanish,
        SupportedLanguage.turkish,
        SupportedLanguage.chinese,
        SupportedLanguage.hindi,
      ];
    } catch (e) {
      // If there's an error, return a default list
      return [SupportedLanguage.english];
    }
  }
  
  List<SupportedLanguage> get availableTargetLanguages {
    try {
      return [
        SupportedLanguage.english,
        SupportedLanguage.german,
        SupportedLanguage.french,
        SupportedLanguage.spanish,
        SupportedLanguage.turkish,
        SupportedLanguage.chinese,
        SupportedLanguage.hindi,
      ];
    } catch (e) {
      // If there's an error, return a default list
      return [SupportedLanguage.english];
    }
  }
  
  /// Initialize language settings from SharedPreferences
  Future<void> loadLanguageSettings() async {
    try {
      final prefs = UserPreferencesService.instance;
      
      final nativeLanguageCode = await prefs.getUserLanguage();
      final targetLanguageCode = await prefs.getSourceLanguage();
      
      _nativeLanguage = SupportedLanguage.fromCode(nativeLanguageCode);
      _targetLanguage = SupportedLanguage.fromCode(targetLanguageCode);
      
      try {
        _appLocale = Locale(_nativeLanguage.code);
      } catch (e) {
        // If there's an error creating the locale, use the default
        _appLocale = const Locale('en');
      }
      
      notifyListeners();
    } catch (e) {
      // If there's an error loading the settings, use default values
      _nativeLanguage = SupportedLanguage.english;
      _targetLanguage = SupportedLanguage.german;
      _appLocale = const Locale('en');
      
      notifyListeners();
    }
  }
  
  /// Save language settings to SharedPreferences
  Future<void> saveLanguageSettings() async {
    try {
      final prefs = UserPreferencesService.instance;
      await prefs.setUserLanguage(_nativeLanguage.code);
      await prefs.setSourceLanguage(_targetLanguage.code);
    } catch (e) {
      // If there's an error, just continue without saving
    }
  }
  
  /// Change native language (UI language)
  Future<void> setNativeLanguage(SupportedLanguage language) async {
    try {
      if (_nativeLanguage != language) {
        _nativeLanguage = language;
        try {
          _appLocale = Locale(language.code);
        } catch (e) {
          // If there's an error creating the locale, use the default
          _appLocale = const Locale('en');
        }
        await saveLanguageSettings();
        notifyListeners();
      }
    } catch (e) {
      // If there's an error, just notify listeners to refresh the UI
      notifyListeners();
    }
  }
  
  /// Change target language (learning language)
  Future<void> setTargetLanguage(SupportedLanguage language) async {
    try {
      if (_targetLanguage != language) {
        _targetLanguage = language;
        await saveLanguageSettings();
        notifyListeners();
      }
    } catch (e) {
      // If there's an error, just notify listeners to refresh the UI
      notifyListeners();
    }
  }
  
  /// Set both languages at once
  Future<void> setLanguages({
    required SupportedLanguage nativeLanguage,
    required SupportedLanguage targetLanguage,
  }) async {
    try {
      bool changed = false;
      
      if (_nativeLanguage != nativeLanguage) {
        _nativeLanguage = nativeLanguage;
        try {
          _appLocale = Locale(nativeLanguage.code);
        } catch (e) {
          // If there's an error creating the locale, use the default
          _appLocale = const Locale('en');
        }
        changed = true;
      }
      
      if (_targetLanguage != targetLanguage) {
        _targetLanguage = targetLanguage;
        changed = true;
      }
      
      if (changed) {
        await saveLanguageSettings();
        
        // Mark that the user has explicitly chosen their language combination
        
        notifyListeners();
      }
    } catch (e) {
      // If there's an error, just notify listeners to refresh the UI
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
      case SupportedLanguage.chinese:
        return 'Chinese';
      case SupportedLanguage.hindi:
        return 'Hindi';
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