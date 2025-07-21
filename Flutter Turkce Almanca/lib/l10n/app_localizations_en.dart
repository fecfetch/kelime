// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Word Chef';

  @override
  String get settings => 'Settings';

  @override
  String get play => 'Play';

  @override
  String get home => 'Home';

  @override
  String get back => 'Back';

  @override
  String get continueButton => 'Continue';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get restart => 'Restart';

  @override
  String get quit => 'Quit';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get loading => 'Loading...';

  @override
  String get gameInstructions => 'Tap letters to form words';

  @override
  String get foundWords => 'Found Words';

  @override
  String get targetWords => 'Target Words';

  @override
  String get validWords => 'Valid Words';

  @override
  String get score => 'Score';

  @override
  String get level => 'Level';

  @override
  String get world => 'World';

  @override
  String get subWorld => 'Sub-World';

  @override
  String get rubies => 'Rubies';

  @override
  String get levelComplete => 'Level Complete!';

  @override
  String get worldComplete => 'World Complete!';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get nextLevel => 'Next Level';

  @override
  String get nextWorld => 'Next World';

  @override
  String get reward => 'Reward';

  @override
  String earnedRubies(int count) {
    return 'You earned $count rubies!';
  }

  @override
  String get hint => 'Hint';

  @override
  String get useHint => 'Use Hint (2 rubies)';

  @override
  String get notEnoughRubies => 'Not enough rubies';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get nativeLanguage => 'Native Language';

  @override
  String get targetLanguage => 'Target Language';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get selectNativeLanguage => 'Select your native language';

  @override
  String get selectTargetLanguage => 'Select language to learn';

  @override
  String get applyLanguages => 'Apply Languages';

  @override
  String get languageChanged => 'Language settings changed';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get turkish => 'Turkish';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get italian => 'Italian';

  @override
  String get soundSettings => 'Sound Settings';

  @override
  String get musicVolume => 'Music Volume';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get vibration => 'Vibration';
}
