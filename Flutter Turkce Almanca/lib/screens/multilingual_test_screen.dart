import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../services/user_preferences_service.dart';
import '../widgets/translation_hints_widget.dart';

class MultilingualTestScreen extends StatefulWidget {
  const MultilingualTestScreen({Key? key}) : super(key: key);

  @override
  State<MultilingualTestScreen> createState() => _MultilingualTestScreenState();
}

class _MultilingualTestScreenState extends State<MultilingualTestScreen> {
  Map<String, dynamic>? _testLevel;
  String _userLanguage = 'turkish';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    try {
      // Load user language preference
      final prefs = UserPreferencesService.instance;
      final userLang = await prefs.getUserLanguage();
      
      // Load test multilingual level
      final String jsonString = await rootBundle.loadString('assets/levels/en_a2_multilingual_test.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      setState(() {
        _userLanguage = userLang;
        _testLevel = jsonData['levels'][0]; // Use first level for testing
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading test data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_testLevel == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Çok Dilli Test'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Test verisi yüklenemedi'),
        ),
      );
    }

    final hints = _testLevel!['hints'] as Map<String, dynamic>;
    final targetWords = List<String>.from(_testLevel!['targetWords']);
    final sourceWord = _testLevel!['sourceWord'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Çok Dilli Test'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Seviyesi',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Kaynak Kelime: ${sourceWord.toUpperCase()}'),
                    Text('Hedef Kelimeler: ${targetWords.join(', ')}'),
                    Text('Seçili Dil: $_userLanguage'),
                    const SizedBox(height: 8),
                    Text(
                      'Mevcut Diller: ${hints.keys.join(', ')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Translation hints widget test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'İpuçları Widget Testi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TranslationHintsWidget(
                      hints: hints,
                      targetWords: targetWords,
                      world: 0,
                      subWorld: 0,
                      level: 0,
                      userLanguage: _userLanguage,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Language switcher for testing
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dil Değiştir (Test)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: hints.keys.map((language) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _userLanguage = language;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _userLanguage == language 
                                ? Colors.blue.shade600 
                                : Colors.grey.shade300,
                            foregroundColor: _userLanguage == language 
                                ? Colors.white 
                                : Colors.black,
                          ),
                          child: Text(language),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Raw hints display for debugging
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ham İpuçları (Debug)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...hints.entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}