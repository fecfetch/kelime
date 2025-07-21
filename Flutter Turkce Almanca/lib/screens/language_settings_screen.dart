import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/multilingual_word_bank.dart';
import '../l10n/app_localizations.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  SupportedLanguage? _selectedNativeLanguage;
  SupportedLanguage? _selectedTargetLanguage;

  @override
  void initState() {
    super.initState();
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    _selectedNativeLanguage = languageProvider.nativeLanguage;
    _selectedTargetLanguage = languageProvider.targetLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Language Combination Display
                Card(
                  color: Colors.white.withValues(alpha: 0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Setup',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageProvider.languageCombinationDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'UI & Hints: ${languageProvider.nativeLanguage.nativeName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Learning: ${languageProvider.targetLanguage.nativeName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Native Language Selection
                Card(
                  color: Colors.white.withValues(alpha: 0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.nativeLanguage,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.selectNativeLanguage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...languageProvider.availableNativeLanguages.map((language) {
                          return RadioListTile<SupportedLanguage>(
                            title: Text(language.nativeName),
                            value: language,
                            groupValue: _selectedNativeLanguage,
                            onChanged: (SupportedLanguage? value) {
                              setState(() {
                                _selectedNativeLanguage = value;
                                // Update available target languages
                                final availableTargets = MultilingualWordBank.getAvailableTargetLanguages(value!);
                                if (!availableTargets.contains(_selectedTargetLanguage)) {
                                  _selectedTargetLanguage = availableTargets.isNotEmpty ? availableTargets.first : null;
                                }
                              });
                            },
                            activeColor: const Color(0xFF4A90E2),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Target Language Selection
                Card(
                  color: Colors.white.withValues(alpha: 0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.targetLanguage,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.selectTargetLanguage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_selectedNativeLanguage != null) ...[
                          ...MultilingualWordBank.getAvailableTargetLanguages(_selectedNativeLanguage!).map((language) {
                            return RadioListTile<SupportedLanguage>(
                              title: Text(language.nativeName),
                              subtitle: Text('Learn ${language.nativeName}'),
                              value: language,
                              groupValue: _selectedTargetLanguage,
                              onChanged: (SupportedLanguage? value) {
                                setState(() {
                                  _selectedTargetLanguage = value;
                                });
                              },
                              activeColor: const Color(0xFF4A90E2),
                            );
                          }),
                        ] else ...[
                          const Text(
                            'Please select a native language first',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.8),
                          foregroundColor: const Color(0xFF4A90E2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _canApplyChanges() ? _applyLanguageChanges : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.applyLanguages,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _canApplyChanges() {
    return _selectedNativeLanguage != null && 
           _selectedTargetLanguage != null &&
           _selectedNativeLanguage != _selectedTargetLanguage &&
           MultilingualWordBank.isLanguageCombinationSupported(
             nativeLanguage: _selectedNativeLanguage!,
             targetLanguage: _selectedTargetLanguage!,
           );
  }

  Future<void> _applyLanguageChanges() async {
    if (!_canApplyChanges()) return;

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(l10n.loading),
          ],
        ),
      ),
    );

    try {
      // Apply language changes
      await languageProvider.setLanguages(
        nativeLanguage: _selectedNativeLanguage!,
        targetLanguage: _selectedTargetLanguage!,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.languageChanged),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Go back to settings
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error applying language changes'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}