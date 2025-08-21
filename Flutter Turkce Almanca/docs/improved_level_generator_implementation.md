# Improved Level Generator Implementation

## Overview

This document provides the implementation plan for the improved multilingual level generator that assumes all word banks are complete with multilingual support.

## File Structure

The improved generator will be implemented in `scripts/improved_multilingual_generator.py` with the following structure:

## Complete Implementation

```python
#!/usr/bin/env python3
"""
Improved Multilingual Level Generator
Designed to work with complete multilingual word banks in an ideal state
"""

import json
import re
import random
import sys
import argparse
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Set, Tuple

class ImprovedMultilingualLevelGenerator:
    def __init__(self):
        self.random = random.Random(42)  # Fixed seed for reproducible results
        
        # Available languages and their configurations
        self.available_configs = {
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
        
    def read_dart_file_content(self, file_path: str) -> str:
        """Read the content of a Dart file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            return ""
    
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
    
    def load_combined_word_bank(self, language_code: str, target_cefr_level: str) -> List[Dict]:
        """Load combined word bank including target level and all lower levels"""
        config = self.available_configs[language_code]
        level_hierarchy = config['levels']
        
        # Find the index of target level
        try:
            target_index = level_hierarchy.index(target_cefr_level)
        except ValueError:
            raise ValueError(f"Invalid CEFR level: {target_cefr_level}")
        
        # Load target level and all lower levels
        combined_words = []
        levels_to_load = level_hierarchy[:target_index + 1]  # Include target level and all below
        
        print(f"Loading word banks for levels: {levels_to_load}")
        
        for level in levels_to_load:
            level_words = self.load_word_bank_for_level(language_code, level)
            combined_words.extend(level_words)
        
        print(f"Total combined vocabulary: {len(combined_words)} words")
        return combined_words
    
    def can_form_word(self, word: str, available_letters: List[str]) -> bool:
        """Check if a word can be formed from available letters"""
        word_letters = list(word.upper())
        available = available_letters.copy()
        
        for letter in word_letters:
            if letter in available:
                available.remove(letter)
            else:
                return False
        return True
    
    def find_formable_words_from_wordbank(self, source_word: str, word_bank: List[Dict]) -> List[str]:
        """Find all words from the word bank that can be formed from the source word"""
        source_letters = list(source_word.upper())
        formable_words = []
        
        for entry in word_bank:
            word = entry['word'].upper()
            if (word != source_word.upper() and 
                len(word) >= 3 and 
                len(word) <= len(source_word) and
                self.can_form_word(word, source_letters)):
                formable_words.append(word)
        
        return formable_words
    
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
    
    def expand_source_word(self, source_word: str, word_bank: List[Dict], min_targets: int = 3) -> str:
        """Expand source word by adding strategic letters to create more target words"""
        # Common letters that often create new words when added
        expansion_letters = ['s', 'e', 'd', 'r', 'n', 't', 'l', 'i', 'o', 'a', 'u', 'h', 'g', 'f', 'c', 'm', 'p', 'b', 'w', 'y']
        
        # Try the original word first
        original_formable = self.find_formable_words_from_wordbank(source_word, word_bank)
        if len(original_formable) >= min_targets:
            return source_word
        
        # Try adding each expansion letter at different positions
        best_expansion = source_word
        best_score = len(original_formable)
        
        for letter in expansion_letters:
            # Try adding the letter at different positions
            for pos in range(len(source_word) + 1):
                expanded_word = source_word[:pos] + letter + source_word[pos:]
                
                # Don't make words too long
                if len(expanded_word) > 10:
                    continue
                
                formable_words = self.find_formable_words_from_wordbank(expanded_word, word_bank)
                score = len(formable_words)
                
                # Bonus for including the original source word
                if source_word.upper() in [w.upper() for w in formable_words]:
                    score += 2
                
                if score > best_score:
                    best_score = score
                    best_expansion = expanded_word
        
        # If still not enough words, try adding two letters
        if len(self.find_formable_words_from_wordbank(best_expansion, word_bank)) < min_targets:
            for letter1 in expansion_letters[:10]:
                for letter2 in expansion_letters[:5]:
                    if letter1 == letter2:
                        continue
                    
                    # Try different positions for double expansion
                    positions = [
                        source_word + letter1 + letter2,
                        letter1 + source_word + letter2,
                        letter1 + letter2 + source_word,
                    ]
                    
                    for double_expanded in positions:
                        if len(double_expanded) > 10:
                            continue
                        
                        formable_words = self.find_formable_words_from_wordbank(double_expanded, word_bank)
                        if len(formable_words) >= min_targets:
                            return double_expanded
        
        return best_expansion

    def generate_levels(self, target_language_code: str, cefr_level: str, native_language_code: str = "tr", max_levels: int = 90) -> Dict:
        """Generate levels from word bank files with comprehensive word tracking"""
        print(f"Generating levels for {target_language_code.upper()} {cefr_level} (native: {native_language_code})...")
        
        # Load combined word bank (target level + all lower levels)
        word_bank = self.load_combined_word_bank(target_language_code, cefr_level)
        
        if not word_bank:
            print(f"Warning: No word bank loaded for {target_language_code} {cefr_level}")
            print("Status: Level generation skipped due to missing word bank")
            return {
                "metadata": {
                    "targetLanguage": target_language_code,
                    "nativeLanguage": native_language_code,
                    "cefrLevel": cefr_level,
                    "totalLevels": 0,
                    "generatedAt": datetime.now().isoformat(),
                    "description": f"Levels for {cefr_level} proficiency in {target_language_code.upper()}",
                    "status": "Word bank not yet implemented"
                },
                "levels": []
            }
        
        levels = []
        
        # Comprehensive word tracking system
        used_source_words = set()  # Never reuse source words
        used_target_words = []     # Track recently used target words
        word_usage_count = {}      # Count how often each word has been used
        
        # Avoidance windows
        target_word_avoidance_window = 20  # Don't repeat target words for 20 levels
        max_word_usage = 3  # Maximum times a word can appear as target across all levels
        
        # Sort words by length DESCENDING (longest first) for progressive difficulty
        sorted_words = sorted(word_bank, key=lambda x: len(x['word']), reverse=True)
        
        world = 1
        sub_world = 0
        level_in_subworld = 0
        attempts = 0
        max_attempts = len(sorted_words) * 2  # Prevent infinite loops
        
        for entry in sorted_words:
            if len(levels) >= max_levels or attempts >= max_attempts:
                break
            
            attempts += 1
            source_word = entry['word']
            
            # Skip if already used as source word or too short
            if source_word.upper() in used_source_words or len(source_word) < 4:
                continue
            
            # Skip if this word has been overused as a target word
            if word_usage_count.get(source_word.lower(), 0) >= max_word_usage:
                continue
            
            # Expand source word if needed to get enough target words
            expanded_source_word = self.expand_source_word(source_word, word_bank, min_targets=3)
            
            # Find words from word bank that can be formed from the expanded source word
            formable_words = self.find_formable_words_from_wordbank(expanded_source_word, word_bank)
            
            # Add the original source word as a target word (important!)
            if source_word.upper() not in [w.upper() for w in formable_words]:
                formable_words.append(source_word.upper())
            
            # Advanced filtering for target word selection
            available_targets = []
            for word in formable_words:
                word_lower = word.lower()
                
                # Skip if word was used recently as target
                if word_lower in used_target_words[-target_word_avoidance_window:]:
                    continue
                
                # Skip if word has been overused
                if word_usage_count.get(word_lower, 0) >= max_word_usage:
                    continue
                
                # Skip if word was already used as source (to maintain variety)
                if word.upper() in used_source_words:
                    continue
                
                available_targets.append(word)
            
            # If we filtered out too many words, relax some constraints
            if len(available_targets) < 2:
                # First fallback: allow recently used targets but not overused ones
                available_targets = [w for w in formable_words 
                                   if word_usage_count.get(w.lower(), 0) < max_word_usage
                                   and w.upper() not in used_source_words]
                
                # Second fallback: allow some overused words but prioritize less used ones
                if len(available_targets) < 2:
                    available_targets = [w for w in formable_words 
                                       if w.upper() not in used_source_words]
                    # Sort by usage count (least used first)
                    available_targets.sort(key=lambda w: word_usage_count.get(w.lower(), 0))
            
            if len(available_targets) >= 2:  # Need at least 2 formable words
                # Prefer 3+ target words, but accept 2 if necessary
                min_targets = 3 if len(available_targets) >= 3 else 2
                
                # Sort target words by length DESCENDING (longer words first) for better gameplay
                # Then by usage count (less used words first) for variety
                sorted_targets = sorted(available_targets, 
                                      key=lambda w: (-len(w), word_usage_count.get(w.lower(), 0)))
                
                # Select target words prioritizing longer, less-used ones
                selected_targets = sorted_targets[:8]  # Take up to 8 best words
                
                # Take the best targets
                final_targets = selected_targets[:min(6, len(selected_targets))]  # Max 6 target words
                
                # Ensure we have at least min_targets
                if len(final_targets) < min_targets and len(sorted_targets) >= min_targets:
                    final_targets = sorted_targets[:min_targets]
                
                # Generate multilingual hints from word bank
                multilingual_hints = self.generate_multilingual_hints(final_targets, word_bank, native_language_code)
                
                # Valid words include all formable words (not just targets)
                all_formable = self.find_formable_words_from_wordbank(expanded_source_word, word_bank)
                if source_word.upper() not in [w.upper() for w in all_formable]:
                    all_formable.append(source_word.upper())
                
                valid_words = sorted([word.lower() for word in all_formable])
                
                # Create level
                level = {
                    "world": world,
                    "subWorld": sub_world,
                    "level": level_in_subworld,
                    "sourceWord": expanded_source_word.lower(),
                    "targetWords": final_targets,
                    "hints": multilingual_hints,
                    "validWords": valid_words
                }
                
                levels.append(level)
                
                # Update tracking systems
                used_source_words.add(source_word.upper())
                used_source_words.add(expanded_source_word.upper())
                
                # Track target word usage
                for target in final_targets:
                    target_lower = target.lower()
                    used_target_words.append(target_lower)
                    word_usage_count[target_lower] = word_usage_count.get(target_lower, 0) + 1
                
                # Update world/subworld structure
                level_in_subworld += 1
                if level_in_subworld >= 18:  # 18 levels per subworld
                    level_in_subworld = 0
                    sub_world += 1
                    if sub_world >= 5:  # 5 subworlds per world
                        sub_world = 0
                        world += 1
                
                if len(levels) % 10 == 0:
                    print(f"Generated {len(levels)} levels...")
                    print(f"  Word usage stats: {len(word_usage_count)} unique words used")
                    print(f"  Most used words: {sorted(word_usage_count.items(), key=lambda x: x[1], reverse=True)[:5]}")
        
        # Create final structure
        result = {
            "metadata": {
                "targetLanguage": target_language_code,
                "nativeLanguage": native_language_code,
                "cefrLevel": cefr_level,
                "totalLevels": len(levels),
                "generatedAt": datetime.now().isoformat(),
                "description": f"Levels for {cefr_level} proficiency in {target_language_code.upper()}"
            },
            "levels": levels
        }
        
        print(f"Generated {len(levels)} levels for {target_language_code.upper()} {cefr_level}")
        print(f"Final word usage stats:")
        print(f"  Total unique words used: {len(word_usage_count)}")
        print(f"  Average usage per word: {sum(word_usage_count.values()) / len(word_usage_count):.2f}")
        
        return result
    
    def save_levels(self, levels_data: Dict, target_language_code: str, cefr_level: str, native_language_code: str = "tr"):
        """Save levels to JSON file"""
        output_path = f"assets/levels/{target_language_code}_{cefr_level.lower()}_{native_language_code}_levels.json"
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(levels_data, f, indent=2, ensure_ascii=False)
        
        print(f"Saved levels to {output_path}")
    
    def list_available_combinations(self):
        """List all available language/level combinations"""
        print("Available language/level combinations:")
        for lang_code, config in self.available_configs.items():
            print(f"  {lang_code} ({config['name']}): {', '.join(config['levels'])}")

def main():
    parser = argparse.ArgumentParser(description='Generate multilingual game levels from word banks')
    parser.add_argument('--target-language', '-t', required=True, help='Target language code (en, de, tr, fr, es, zh, hi)')
    parser.add_argument('--native-language', '-n', default='tr', help='Native language code (default: tr)')
    parser.add_argument('--level', '-c', required=True, help='CEFR level (A1, A2, B1, B2, C1, C2)')
    parser.add_argument('--max-levels', '-m', type=int, default=90, help='Maximum number of levels to generate')
    parser.add_argument('--list', action='store_true', help='List available combinations')
    
    args = parser.parse_args()
    
    generator = ImprovedMultilingualLevelGenerator()
    
    if args.list:
        generator.list_available_combinations()
        return
    
    try:
        levels_data = generator.generate_levels(args.target_language, args.level, args.native_language, args.max_levels)
        generator.save_levels(levels_data, args.target_language, args.level, args.native_language)
        print(f"✅ Successfully generated {args.target_language.upper()} {args.level} levels!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()
```

## Key Improvements

1. **Flexible Language Support**: The generator now supports all planned languages (en, de, tr, fr, es, zh, hi) with proper configuration.

2. **Adaptive Parsing**: The parser can handle both complete multilingual word banks and legacy single-translation format.

3. **Enhanced Error Handling**: Comprehensive error handling with descriptive status messages for different scenarios:
   - "Word bank not yet implemented"
   - "Word bank not yet populated"
   - "Word bank format not recognized or empty"

4. **Native Language Support**: The generator now accepts a native language parameter and generates hints accordingly.

5. **Improved File Path Construction**: Uses the correct folder naming convention (`LANGUAGE-WB`) and file naming pattern.

6. **Backward Compatibility**: Maintains compatibility with existing Turkish → English levels while supporting new language combinations.

## Usage Examples

```bash
# Generate English levels for Turkish native speakers
python scripts/improved_multilingual_generator.py -t en -n tr -c A1

# Generate German levels for English native speakers
python scripts/improved_multilingual_generator.py -t de -n en -c A1

# List all available language combinations
python scripts/improved_multilingual_generator.py --list
```

## Future Enhancements

1. **Dynamic Language Detection**: Automatically detect available languages from the file system
2. **Translation Completeness Checking**: Verify that all language combinations have complete translations
3. **Performance Optimization**: Implement caching and other optimizations for large word banks
4. **Progressive Difficulty**: Implement more sophisticated difficulty progression based on CEFR levels