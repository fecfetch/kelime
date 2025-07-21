// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Kelime Şefi';

  @override
  String get settings => 'Ayarlar';

  @override
  String get play => 'Oyna';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get back => 'Geri';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get pause => 'Duraklat';

  @override
  String get resume => 'Devam Et';

  @override
  String get restart => 'Yeniden Başla';

  @override
  String get quit => 'Çık';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get gameInstructions => 'Kelime oluşturmak için harflere dokunun';

  @override
  String get foundWords => 'Bulunan Kelimeler';

  @override
  String get targetWords => 'Hedef Kelimeler';

  @override
  String get validWords => 'Geçerli Kelimeler';

  @override
  String get score => 'Puan';

  @override
  String get level => 'Seviye';

  @override
  String get world => 'Dünya';

  @override
  String get subWorld => 'Alt Dünya';

  @override
  String get rubies => 'Yakut';

  @override
  String get levelComplete => 'Seviye Tamamlandı!';

  @override
  String get worldComplete => 'Dünya Tamamlandı!';

  @override
  String get congratulations => 'Tebrikler!';

  @override
  String get nextLevel => 'Sonraki Seviye';

  @override
  String get nextWorld => 'Sonraki Dünya';

  @override
  String get reward => 'Ödül';

  @override
  String earnedRubies(int count) {
    return '$count yakut kazandınız!';
  }

  @override
  String get hint => 'İpucu';

  @override
  String get useHint => 'İpucu Kullan (2 yakut)';

  @override
  String get notEnoughRubies => 'Yeterli yakut yok';

  @override
  String get shuffle => 'Karıştır';

  @override
  String get nativeLanguage => 'Ana Dil';

  @override
  String get targetLanguage => 'Öğrenilecek Dil';

  @override
  String get languageSettings => 'Dil Ayarları';

  @override
  String get selectNativeLanguage => 'Ana dilinizi seçin';

  @override
  String get selectTargetLanguage => 'Öğrenmek istediğiniz dili seçin';

  @override
  String get applyLanguages => 'Dilleri Uygula';

  @override
  String get languageChanged => 'Dil ayarları değiştirildi';

  @override
  String get english => 'İngilizce';

  @override
  String get german => 'Almanca';

  @override
  String get french => 'Fransızca';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get turkish => 'Türkçe';

  @override
  String get portuguese => 'Portekizce';

  @override
  String get italian => 'İtalyanca';

  @override
  String get soundSettings => 'Ses Ayarları';

  @override
  String get musicVolume => 'Müzik Sesi';

  @override
  String get soundEffects => 'Ses Efektleri';

  @override
  String get vibration => 'Titreşim';
}
