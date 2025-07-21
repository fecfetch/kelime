// Universal translation system - maps word IDs to translations in all supported languages
final Map<String, Map<String, String>> universalTranslations = {
  // Basic pronouns and articles
  'word_i': {'en': 'I', 'de': 'ich', 'tr': 'ben', 'fr': 'je', 'es': 'yo'},
  'word_you': {'en': 'you', 'de': 'du', 'tr': 'sen', 'fr': 'tu', 'es': 'tú'},
  'word_he': {'en': 'he', 'de': 'er', 'tr': 'o', 'fr': 'il', 'es': 'él'},
  'word_she': {'en': 'she', 'de': 'sie', 'tr': 'o', 'fr': 'elle', 'es': 'ella'},
  'word_it': {'en': 'it', 'de': 'es', 'tr': 'o', 'fr': 'il/elle', 'es': 'ello'},
  'word_we': {'en': 'we', 'de': 'wir', 'tr': 'biz', 'fr': 'nous', 'es': 'nosotros'},
  'word_they': {'en': 'they', 'de': 'sie', 'tr': 'onlar', 'fr': 'ils/elles', 'es': 'ellos'},
  
  // Basic verbs
  'word_be': {'en': 'to be', 'de': 'sein', 'tr': 'olmak', 'fr': 'être', 'es': 'ser'},
  'word_have': {'en': 'to have', 'de': 'haben', 'tr': 'sahip olmak', 'fr': 'avoir', 'es': 'tener'},
  'word_do': {'en': 'to do', 'de': 'machen', 'tr': 'yapmak', 'fr': 'faire', 'es': 'hacer'},
  'word_go': {'en': 'to go', 'de': 'gehen', 'tr': 'gitmek', 'fr': 'aller', 'es': 'ir'},
  'word_come': {'en': 'to come', 'de': 'kommen', 'tr': 'gelmek', 'fr': 'venir', 'es': 'venir'},
  'word_see': {'en': 'to see', 'de': 'sehen', 'tr': 'görmek', 'fr': 'voir', 'es': 'ver'},
  'word_know': {'en': 'to know', 'de': 'wissen', 'tr': 'bilmek', 'fr': 'savoir', 'es': 'saber'},
  'word_get': {'en': 'to get', 'de': 'bekommen', 'tr': 'almak', 'fr': 'obtenir', 'es': 'obtener'},
  'word_give': {'en': 'to give', 'de': 'geben', 'tr': 'vermek', 'fr': 'donner', 'es': 'dar'},
  'word_take': {'en': 'to take', 'de': 'nehmen', 'tr': 'almak', 'fr': 'prendre', 'es': 'tomar'},
  
  // Basic nouns
  'word_house': {'en': 'house', 'de': 'haus', 'tr': 'ev', 'fr': 'maison', 'es': 'casa'},
  'word_car': {'en': 'car', 'de': 'auto', 'tr': 'araba', 'fr': 'voiture', 'es': 'coche'},
  'word_dog': {'en': 'dog', 'de': 'hund', 'tr': 'köpek', 'fr': 'chien', 'es': 'perro'},
  'word_cat': {'en': 'cat', 'de': 'katze', 'tr': 'kedi', 'fr': 'chat', 'es': 'gato'},
  'word_man': {'en': 'man', 'de': 'mann', 'tr': 'adam', 'fr': 'homme', 'es': 'hombre'},
  'word_woman': {'en': 'woman', 'de': 'frau', 'tr': 'kadın', 'fr': 'femme', 'es': 'mujer'},
  'word_child': {'en': 'child', 'de': 'kind', 'tr': 'çocuk', 'fr': 'enfant', 'es': 'niño'},
  'word_book': {'en': 'book', 'de': 'buch', 'tr': 'kitap', 'fr': 'livre', 'es': 'libro'},
  'word_water': {'en': 'water', 'de': 'wasser', 'tr': 'su', 'fr': 'eau', 'es': 'agua'},
  'word_food': {'en': 'food', 'de': 'essen', 'tr': 'yemek', 'fr': 'nourriture', 'es': 'comida'},
  
  // Basic adjectives
  'word_good': {'en': 'good', 'de': 'gut', 'tr': 'iyi', 'fr': 'bon', 'es': 'bueno'},
  'word_bad': {'en': 'bad', 'de': 'schlecht', 'tr': 'kötü', 'fr': 'mauvais', 'es': 'malo'},
  'word_big': {'en': 'big', 'de': 'groß', 'tr': 'büyük', 'fr': 'grand', 'es': 'grande'},
  'word_small': {'en': 'small', 'de': 'klein', 'tr': 'küçük', 'fr': 'petit', 'es': 'pequeño'},
  'word_new': {'en': 'new', 'de': 'neu', 'tr': 'yeni', 'fr': 'nouveau', 'es': 'nuevo'},
  'word_old': {'en': 'old', 'de': 'alt', 'tr': 'eski', 'fr': 'vieux', 'es': 'viejo'},
  
  // Colors
  'word_red': {'en': 'red', 'de': 'rot', 'tr': 'kırmızı', 'fr': 'rouge', 'es': 'rojo'},
  'word_blue': {'en': 'blue', 'de': 'blau', 'tr': 'mavi', 'fr': 'bleu', 'es': 'azul'},
  'word_green': {'en': 'green', 'de': 'grün', 'tr': 'yeşil', 'fr': 'vert', 'es': 'verde'},
  'word_yellow': {'en': 'yellow', 'de': 'gelb', 'tr': 'sarı', 'fr': 'jaune', 'es': 'amarillo'},
  'word_black': {'en': 'black', 'de': 'schwarz', 'tr': 'siyah', 'fr': 'noir', 'es': 'negro'},
  'word_white': {'en': 'white', 'de': 'weiß', 'tr': 'beyaz', 'fr': 'blanc', 'es': 'blanco'},
  
  // Numbers
  'word_one': {'en': 'one', 'de': 'eins', 'tr': 'bir', 'fr': 'un', 'es': 'uno'},
  'word_two': {'en': 'two', 'de': 'zwei', 'tr': 'iki', 'fr': 'deux', 'es': 'dos'},
  'word_three': {'en': 'three', 'de': 'drei', 'tr': 'üç', 'fr': 'trois', 'es': 'tres'},
  'word_four': {'en': 'four', 'de': 'vier', 'tr': 'dört', 'fr': 'quatre', 'es': 'cuatro'},
  'word_five': {'en': 'five', 'de': 'fünf', 'tr': 'beş', 'fr': 'cinq', 'es': 'cinco'},
  
  // Time
  'word_time': {'en': 'time', 'de': 'zeit', 'tr': 'zaman', 'fr': 'temps', 'es': 'tiempo'},
  'word_day': {'en': 'day', 'de': 'tag', 'tr': 'gün', 'fr': 'jour', 'es': 'día'},
  'word_night': {'en': 'night', 'de': 'nacht', 'tr': 'gece', 'fr': 'nuit', 'es': 'noche'},
  'word_year': {'en': 'year', 'de': 'jahr', 'tr': 'yıl', 'fr': 'année', 'es': 'año'},
  'word_today': {'en': 'today', 'de': 'heute', 'tr': 'bugün', 'fr': 'aujourd\'hui', 'es': 'hoy'},
  
  // Family
  'word_family': {'en': 'family', 'de': 'familie', 'tr': 'aile', 'fr': 'famille', 'es': 'familia'},
  'word_mother': {'en': 'mother', 'de': 'mutter', 'tr': 'anne', 'fr': 'mère', 'es': 'madre'},
  'word_father': {'en': 'father', 'de': 'vater', 'tr': 'baba', 'fr': 'père', 'es': 'padre'},
  'word_son': {'en': 'son', 'de': 'sohn', 'tr': 'oğul', 'fr': 'fils', 'es': 'hijo'},
  'word_daughter': {'en': 'daughter', 'de': 'tochter', 'tr': 'kız', 'fr': 'fille', 'es': 'hija'},
};

/// Helper class to work with universal translations
class UniversalTranslations {
  /// Get translation for a word ID in a specific language
  static String getTranslation(String wordId, String languageCode) {
    final translations = universalTranslations[wordId];
    if (translations == null) {
      return wordId; // Fallback to word ID if not found
    }
    return translations[languageCode] ?? translations['en'] ?? wordId;
  }
  
  /// Get all available languages for a word ID
  static List<String> getAvailableLanguages(String wordId) {
    final translations = universalTranslations[wordId];
    if (translations == null) return [];
    return translations.keys.toList();
  }
  
  /// Check if a translation exists for a word ID and language
  static bool hasTranslation(String wordId, String languageCode) {
    final translations = universalTranslations[wordId];
    return translations?.containsKey(languageCode) ?? false;
  }
  
  /// Find word ID by word in any language
  static String? findWordId(String word, String languageCode) {
    for (final entry in universalTranslations.entries) {
      if (entry.value[languageCode]?.toLowerCase() == word.toLowerCase()) {
        return entry.key;
      }
    }
    return null;
  }
  
  /// Get all words in a specific language
  static List<String> getAllWordsInLanguage(String languageCode) {
    final words = <String>[];
    for (final translations in universalTranslations.values) {
      final word = translations[languageCode];
      if (word != null) {
        words.add(word);
      }
    }
    return words;
  }
}