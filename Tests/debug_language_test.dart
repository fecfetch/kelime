import 'package:shared_preferences/shared_preferences.dart';

// Simulate the language provider logic
enum SupportedLanguage {
  english('en', 'English'),
  german('de', 'Deutsch'),
  turkish('tr', 'Türkçe');

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

void main() async {
  print('Testing language provider logic...');
  
  // Clear any existing preferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  print('\n1. Testing default values (fresh install):');
  await testLanguageLoading();
  
  print('\n2. Setting English → German:');
  await prefs.setString('native_language', 'en');
  await prefs.setString('target_language', 'de');
  await testLanguageLoading();
  
  print('\n3. Setting Turkish → English (original):');
  await prefs.setString('native_language', 'tr');
  await prefs.setString('target_language', 'en');
  await testLanguageLoading();
}

Future<void> testLanguageLoading() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Load native language (for UI) - default to Turkish (original game)
  final nativeCode = prefs.getString('native_language') ?? 'tr';
  final nativeLanguage = SupportedLanguage.fromCode(nativeCode);
  
  // Load target language (for learning) - default to English (original game)
  final targetCode = prefs.getString('target_language') ?? 'en';
  final targetLanguage = SupportedLanguage.fromCode(targetCode);
  
  // Set app locale to native language
  final appLocale = nativeLanguage.code;
  
  print('  Native language: ${nativeLanguage.nativeName} (${nativeLanguage.code})');
  print('  Target language: ${targetLanguage.nativeName} (${targetLanguage.code})');
  print('  App locale: $appLocale');
  print('  UI should be in: ${nativeLanguage.nativeName}');
  print('  Learning: ${targetLanguage.nativeName}');
  print('  Combination: ${nativeLanguage.nativeName} → ${targetLanguage.nativeName}');
}