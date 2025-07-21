// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Wort Koch';

  @override
  String get settings => 'Einstellungen';

  @override
  String get play => 'Spielen';

  @override
  String get home => 'Startseite';

  @override
  String get back => 'Zurück';

  @override
  String get continueButton => 'Weiter';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get restart => 'Neu starten';

  @override
  String get quit => 'Beenden';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get loading => 'Laden...';

  @override
  String get gameInstructions =>
      'Tippen Sie auf Buchstaben, um Wörter zu bilden';

  @override
  String get foundWords => 'Gefundene Wörter';

  @override
  String get targetWords => 'Zielwörter';

  @override
  String get validWords => 'Gültige Wörter';

  @override
  String get score => 'Punkte';

  @override
  String get level => 'Level';

  @override
  String get world => 'Welt';

  @override
  String get subWorld => 'Unterwelt';

  @override
  String get rubies => 'Rubine';

  @override
  String get levelComplete => 'Level abgeschlossen!';

  @override
  String get worldComplete => 'Welt abgeschlossen!';

  @override
  String get congratulations => 'Herzlichen Glückwunsch!';

  @override
  String get nextLevel => 'Nächstes Level';

  @override
  String get nextWorld => 'Nächste Welt';

  @override
  String get reward => 'Belohnung';

  @override
  String earnedRubies(int count) {
    return 'Sie haben $count Rubine verdient!';
  }

  @override
  String get hint => 'Hinweis';

  @override
  String get useHint => 'Hinweis verwenden (2 Rubine)';

  @override
  String get notEnoughRubies => 'Nicht genug Rubine';

  @override
  String get shuffle => 'Mischen';

  @override
  String get nativeLanguage => 'Muttersprache';

  @override
  String get targetLanguage => 'Zielsprache';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get selectNativeLanguage => 'Wählen Sie Ihre Muttersprache';

  @override
  String get selectTargetLanguage => 'Wählen Sie die zu lernende Sprache';

  @override
  String get applyLanguages => 'Sprachen anwenden';

  @override
  String get languageChanged => 'Spracheinstellungen geändert';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get french => 'Französisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get turkish => 'Türkisch';

  @override
  String get portuguese => 'Portugiesisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get soundSettings => 'Toneinstellungen';

  @override
  String get musicVolume => 'Musiklautstärke';

  @override
  String get soundEffects => 'Soundeffekte';

  @override
  String get vibration => 'Vibration';
}
