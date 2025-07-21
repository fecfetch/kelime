// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Chef de Mots';

  @override
  String get settings => 'Paramètres';

  @override
  String get play => 'Jouer';

  @override
  String get home => 'Accueil';

  @override
  String get back => 'Retour';

  @override
  String get continueButton => 'Continuer';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get restart => 'Redémarrer';

  @override
  String get quit => 'Quitter';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Sauvegarder';

  @override
  String get loading => 'Chargement...';

  @override
  String get gameInstructions => 'Touchez les lettres pour former des mots';

  @override
  String get foundWords => 'Mots Trouvés';

  @override
  String get targetWords => 'Mots Cibles';

  @override
  String get validWords => 'Mots Valides';

  @override
  String get score => 'Score';

  @override
  String get level => 'Niveau';

  @override
  String get world => 'Monde';

  @override
  String get subWorld => 'Sous-Monde';

  @override
  String get rubies => 'Rubis';

  @override
  String get levelComplete => 'Niveau Terminé!';

  @override
  String get worldComplete => 'Monde Terminé!';

  @override
  String get congratulations => 'Félicitations!';

  @override
  String get nextLevel => 'Niveau Suivant';

  @override
  String get nextWorld => 'Monde Suivant';

  @override
  String get reward => 'Récompense';

  @override
  String earnedRubies(int count) {
    return 'Vous avez gagné $count rubis!';
  }

  @override
  String get hint => 'Indice';

  @override
  String get useHint => 'Utiliser un Indice (2 rubis)';

  @override
  String get notEnoughRubies => 'Pas assez de rubis';

  @override
  String get shuffle => 'Mélanger';

  @override
  String get nativeLanguage => 'Langue Maternelle';

  @override
  String get targetLanguage => 'Langue Cible';

  @override
  String get languageSettings => 'Paramètres de Langue';

  @override
  String get selectNativeLanguage => 'Sélectionnez votre langue maternelle';

  @override
  String get selectTargetLanguage => 'Sélectionnez la langue à apprendre';

  @override
  String get applyLanguages => 'Appliquer les Langues';

  @override
  String get languageChanged => 'Paramètres de langue modifiés';

  @override
  String get english => 'Anglais';

  @override
  String get german => 'Allemand';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get turkish => 'Turc';

  @override
  String get portuguese => 'Portugais';

  @override
  String get italian => 'Italien';

  @override
  String get soundSettings => 'Paramètres Audio';

  @override
  String get musicVolume => 'Volume de la Musique';

  @override
  String get soundEffects => 'Effets Sonores';

  @override
  String get vibration => 'Vibration';
}
