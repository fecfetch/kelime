import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';


class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  SupportedLanguage? selectedNativeLanguage;
  SupportedLanguage? selectedTargetLanguage;

  @override
  void initState() {
    super.initState();
    final languageProvider = context.read<LanguageProvider>();
    selectedNativeLanguage = languageProvider.nativeLanguage;
    selectedTargetLanguage = languageProvider.targetLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Languages'),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
      ),
      body: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Header
                const Text(
                  'Select Your Languages',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 10),
                
                const Text(
                  'Choose your native language and the language you want to learn',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Native Language Selection
                _buildLanguageSection(
                  title: 'Your Native Language',
                  subtitle: 'The language you speak fluently',
                  selectedLanguage: selectedNativeLanguage,
                  availableLanguages: _getAvailableNativeLanguages(),
                  onLanguageSelected: (language) {
                    setState(() {
                      selectedNativeLanguage = language;
                      // Reset target language if same as native
                      if (selectedTargetLanguage == language) {
                        selectedTargetLanguage = null;
                      }
                    });
                  },
                ),
                
                const SizedBox(height: 30),
                
                // Target Language Selection
                _buildLanguageSection(
                  title: 'Language to Learn',
                  subtitle: 'The language you want to practice',
                  selectedLanguage: selectedTargetLanguage,
                  availableLanguages: _getAvailableTargetLanguages(),
                  onLanguageSelected: (language) {
                    setState(() {
                      selectedTargetLanguage = language;
                    });
                  },
                ),
                
                const Spacer(),
                
                // Language combination preview
                if (selectedNativeLanguage != null && selectedTargetLanguage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Your Learning Setup:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${selectedNativeLanguage!.nativeName} → ${selectedTargetLanguage!.nativeName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Game interface and hints will be in your native language',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // Continue Button
                ElevatedButton(
                  onPressed: _canContinue() ? _saveAndContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Start Learning',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSection({
    required String title,
    required String subtitle,
    required SupportedLanguage? selectedLanguage,
    required List<SupportedLanguage> availableLanguages,
    required Function(SupportedLanguage) onLanguageSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 12),
        
        // Language options
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableLanguages.map((language) {
            final isSelected = selectedLanguage == language;
            final isDisabled = selectedNativeLanguage == language && title.contains('Learn');
            
            return GestureDetector(
              onTap: isDisabled ? null : () => onLanguageSelected(language),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white 
                      : isDisabled 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getLanguageFlag(language),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      language.nativeName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected 
                            ? const Color(0xFF4A90E2) 
                            : isDisabled 
                                ? Colors.white38
                                : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<SupportedLanguage> _getAvailableNativeLanguages() {
    return [
      SupportedLanguage.english,
      SupportedLanguage.german,
      SupportedLanguage.turkish,
    ];
  }

  List<SupportedLanguage> _getAvailableTargetLanguages() {
    final available = [
      SupportedLanguage.english,
      SupportedLanguage.german,
      SupportedLanguage.turkish,
    ];
    
    // Remove native language from target options
    if (selectedNativeLanguage != null) {
      available.remove(selectedNativeLanguage);
    }
    
    return available;
  }

  String _getLanguageFlag(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return '🇺🇸';
      case SupportedLanguage.german:
        return '🇩🇪';
      case SupportedLanguage.turkish:
        return '🇹🇷';
      case SupportedLanguage.french:
        return '🇫🇷';
      case SupportedLanguage.spanish:
        return '🇪🇸';
      case SupportedLanguage.portuguese:
        return '🇵🇹';
      case SupportedLanguage.italian:
        return '🇮🇹';
    }
  }

  bool _canContinue() {
    return selectedNativeLanguage != null && 
           selectedTargetLanguage != null && 
           selectedNativeLanguage != selectedTargetLanguage &&
           _isLanguageCombinationSupported(
             selectedNativeLanguage!, 
             selectedTargetLanguage!
           );
  }

  bool _isLanguageCombinationSupported(SupportedLanguage nativeLanguage, SupportedLanguage targetLanguage) {
    // All combinations of English, German, and Turkish are supported
    final supportedLanguages = [SupportedLanguage.english, SupportedLanguage.german, SupportedLanguage.turkish];
    return supportedLanguages.contains(nativeLanguage) && 
           supportedLanguages.contains(targetLanguage) && 
           nativeLanguage != targetLanguage;
  }

  void _saveAndContinue() async {
    if (!_canContinue()) return;

    final languageProvider = context.read<LanguageProvider>();
    
    await languageProvider.setLanguages(
      nativeLanguage: selectedNativeLanguage!,
      targetLanguage: selectedTargetLanguage!,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}