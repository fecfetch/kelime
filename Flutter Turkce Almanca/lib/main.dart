import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/game_state_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/language_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WordChefApp());
}

class WordChefApp extends StatelessWidget {
  const WordChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => GameStateProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Word Chef',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              fontFamily: 'Arial',
            ),
            // Localization support
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('de'), // German
              Locale('fr'), // French
              Locale('es'), // Spanish
              Locale('tr'), // Turkish
              Locale('pt'), // Portuguese
              Locale('it'), // Italian
            ],
            locale: languageProvider.appLocale,
            home: const AppInitializer(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// Widget to initialize app data before showing home screen
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);

    // Load language settings first
    await languageProvider.loadLanguageSettings();

    // Load progress data
    await progressProvider.loadProgress();

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const HomeScreen();
  }
}
