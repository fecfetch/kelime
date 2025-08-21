# Multilingual Level Generator Design

## Overview

This document describes the design of an improved multilingual level generator for the word game that assumes all word banks are complete with multilingual support. The generator is designed to work in an ideal state where all languages have complete word banks with translations to all other supported languages.

## Supported Languages

The system should eventually support these language combinations:
- Turkish native → English target
- English native → German target
- German native → English target
- French native → English target
- Spanish native → English target
- Chinese native → English target
- Hindi native → English target

## Word Bank Structure

In the ideal state, all word banks should follow this structure:

### English Word Banks
```dart
// word_bank_english_a1.dart
const List<Map<String, dynamic>> wordBankEnglishA1 = [
  {
    'word': 'hello',
    'translations': {
      'turkish': 'merhaba',
      'german': 'hallo',
      'french': 'bonjour',
      'spanish': 'hola',
      'chinese': '你好',
      'hindi': 'नमस्ते'
    }
  },
  // ... more words
];
```

### German Word Banks
```dart
// word_bank_german_a1.dart
const List<Map<String, dynamic>> wordBankGermanA1 = [
  {
    'word': 'hallo',
    'translations': {
      'turkish': 'merhaba',
      'english': 'hello',
      'french': 'bonjour',
      'spanish': 'hola',
      'chinese': '你好',
      'hindi': 'नमस्ते'
    }
  },
  // ... more words
];
```

## File Path Structure

The file paths should follow this pattern:
```
lib/data/{LanguageCode.toUpperCase()}-WB/word_bank_{languageCode}_{cefrLevel.toLowerCase()}.dart
```

Examples:
- `lib/data/ENGLISH-WB/word_bank_english_a1.dart`
- `lib/data/GERMAN-WB/word_bank_german_a1.dart`
- `lib/data/FRENCH-WB/word_bank_french_a1.dart`

## Adaptive Parsing

The generator should implement adaptive parsing that can handle:
1. Complete multilingual word banks with all translations
2. Partial word banks with missing translations
3. Legacy word banks with single translation fields
4. Empty or missing word banks

## Multilingual Hint Generation

The hint generation system should:
1. Generate hints in all available languages from the word bank
2. Handle missing translations gracefully
3. Provide "not yet implemented" messages for incomplete word banks
4. Support dynamic language combinations

## Error Handling

The generator should handle these scenarios:
- Missing word bank files: Show "Word bank not yet implemented"
- Empty word banks: Show "Word bank not yet populated"
- Incomplete translations: Show "Translations not yet complete"
- Parsing errors: Show descriptive error messages

## Implementation Plan

### 1. Language Configuration System

Create a comprehensive language configuration that supports all planned languages:

```python
available_configs = {
    'en': {
        'name': 'English',
        'folder': 'ENGLISH-WB',
        'levels': ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
    },
    'de': {
        'name': 'German', 
        'folder': 'GERMAN-WB',
        'levels': ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
    },
    'tr': {
        'name': 'Turkish',
        'folder': 'TURKISH-WB',
        'levels': ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
    },
    'fr': {
        'name': 'French',
        'folder': 'FRENCH-WB',
        'levels': ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
    },
    'es': {
        'name': 'Spanish',
        'folder': 'SPANISH-WB',
        'levels': ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
    },
    'zh': {
        'name': 'Chinese',
        'folder': 'CHINESE-WB',
        'levels': ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
    },
    'hi': {
        'name': 'Hindi',
        'folder': 'HINDI-WB',
        'levels': ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
    }
}
```

### 2. Adaptive Word Bank Parser

Implement a parser that can handle different word bank formats:

```python
def extract_word_entries_from_content(self, content: str, language_code: str) -> List[Dict]:
    """Extract word entries from Dart file content using adaptive parsing"""
    entries = []
    
    # Try the complete multilingual format first
    complete_pattern = r"\{\s*'word':\s*'([^']+)',\s*'translations':\s*\{([^}]+)\}\s*\}"
    
    for match in re.finditer(complete_pattern, content, re.DOTALL):
        word = match.group(1)
        translations_str = match.group(2)
        
        # Parse translations
        translations = {}
        trans_pattern = r"'(\w+)':\s*'([^']+)'"
        
        for trans_match in re.finditer(trans_pattern, translations_str):
            lang = trans_match.group(1)
            translation = trans_match.group(2)
            translations[lang] = translation
        
        if translations:
            entries.append({
                'word': word,
                'translations': translations
            })
    
    # If no complete format entries found, try legacy format
    if not entries:
        legacy_pattern = r"\{\s*'word':\s*'([^']+)',\s*'translation':\s*'([^']+)'\s*\}"
        
        for match in re.finditer(legacy_pattern, content):
            word = match.group(1)
            translation = match.group(2)
            
            # Create a minimal translations object with just the target language
            translations = {language_code: translation}
            
            entries.append({
                'word': word,
                'translations': translations
            })
    
    return entries
```

### 3. Multilingual Hint Generator

Implement a hint generator that works with complete word banks:

```python
def generate_multilingual_hints(self, target_words: List[str], word_bank: List[Dict], native_language: str) -> Dict[str, str]:
    """Generate hints in all available languages from the word bank"""
    hints = {}
    
    # Get all available languages from word bank
    available_languages = set()
    for entry in word_bank:
        available_languages.update(entry['translations'].keys())
    
    # Generate hints for each language
    for language in available_languages:
        language_hints = []
        
        for target_word in target_words:
            # Find the word in word bank
            translation = f"[{target_word}]"  # fallback with brackets
            for entry in word_bank:
                if entry['word'].upper() == target_word.upper():
                    translation = entry['translations'].get(language, f"[{target_word}]")
                    break
            
            language_hints.append(translation)
        
        hints[language] = " | ".join(language_hints)
    
    return hints
```

### 4. Error Handling and Status Reporting

Implement comprehensive error handling:

```python
def load_word_bank_for_level(self, language_code: str, cefr_level: str) -> List[Dict]:
    """Load word bank for a specific language and CEFR level with error handling"""
    if language_code not in self.available_configs:
        raise ValueError(f"Language {language_code} not supported")
    
    config = self.available_configs[language_code]
    if cefr_level not in config['levels']:
        raise ValueError(f"CEFR level {cefr_level} not available for {config['name']}")
    
    # Construct file path
    file_path = f"lib/data/{config['folder']}/word_bank_{language_code}_{cefr_level.lower()}.dart"
    
    if not Path(file_path).exists():
        print(f"Warning: Word bank file not found: {file_path}")
        print("Status: Word bank not yet implemented")
        return []
    
    print(f"Loading word bank: {file_path}")
    content = self.read_dart_file_content(file_path)
    
    if not content:
        print(f"Warning: Could not read content from {file_path}")
        print("Status: Word bank not yet populated")
        return []
    
    entries = self.extract_word_entries_from_content(content, language_code)
    
    if not entries:
        print(f"Warning: No entries found in {file_path}")
        print("Status: Word bank format not recognized or empty")
        return []
    
    print(f"Extracted {len(entries)} words from {cefr_level}")
    return entries
```

## Future Enhancements

1. **Dynamic Language Detection**: Automatically detect available languages from the file system
2. **Translation Completeness Checking**: Verify that all language combinations have complete translations
3. **Progressive Difficulty**: Implement more sophisticated difficulty progression based on CEFR levels
4. **Cultural Context**: Add cultural context to hints for better language learning
5. **Performance Optimization**: Implement caching and other optimizations for large word banks

## Testing Strategy

1. **Unit Tests**: Test each component individually
2. **Integration Tests**: Test complete level generation workflows
3. **Edge Case Tests**: Test error conditions and incomplete data
4. **Performance Tests**: Test with large word banks
5. **Compatibility Tests**: Ensure backward compatibility with existing levels

This design will ensure that the level generator works properly when all word banks are complete, and gracefully handles cases where they are not yet implemented.