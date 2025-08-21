import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  SupportedLanguage? _selectedNativeLanguage;
  SupportedLanguage? _selectedTargetLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      
      setState(() {
        _selectedNativeLanguage = languageProvider.nativeLanguage ?? SupportedLanguage.english;
        _selectedTargetLanguage = languageProvider.targetLanguage ?? SupportedLanguage.german;
        _isLoading = false;
      });
    } catch (e) {
      // Handle any errors that might occur during loading
      if (mounted) {
        setState(() {
          // Set default values if there's an error
          _selectedNativeLanguage = SupportedLanguage.english;
          _selectedTargetLanguage = SupportedLanguage.german;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _savePreferences() async {
    if (_selectedNativeLanguage == null || _selectedTargetLanguage == null) {
      return;
    }
    
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    await languageProvider.setLanguages(
      nativeLanguage: _selectedNativeLanguage!,
      targetLanguage: _selectedTargetLanguage!,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dil ayarları kaydedildi!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      
      if (_isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Dil Ayarları'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Language (for hints)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ana Dil',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'İpuçlarının hangi dilde gösterileceğini seçin',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<SupportedLanguage>(
                        value: _selectedNativeLanguage ?? languageProvider.availableNativeLanguages.first,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: languageProvider.availableNativeLanguages
                            .map((language) => DropdownMenuItem(
                                  value: language,
                                  child: Text(language.nativeName),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedNativeLanguage = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Öğrenilecek Dil',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hangi dili öğrenmek istediğinizi seçin',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<SupportedLanguage>(
                        value: _selectedTargetLanguage ?? languageProvider.availableTargetLanguages.first,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: languageProvider.availableTargetLanguages
                            .map((language) => DropdownMenuItem(
                                  value: language,
                                  child: Text(language.nativeName),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedTargetLanguage = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Ayarları Kaydet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // If there's an error, show a simple error screen
      return const Scaffold(
        body: Center(
          child: Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
        ),
      );
    }
  }
}