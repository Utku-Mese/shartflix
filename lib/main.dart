import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/di/injection.dart';
import 'core/services/logger_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/localization_service.dart';
import 'features/splash/splash.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/auth/presentation/pages/photo_upload_page.dart';
import 'features/movies/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize logger
  final logger = getIt<LoggerService>();
  logger.info('Shartflix App Starting...');

  runApp(const ShartflixApp());
}

class ShartflixApp extends StatefulWidget {
  const ShartflixApp({super.key});

  @override
  State<ShartflixApp> createState() => _ShartflixAppState();
}

class _ShartflixAppState extends State<ShartflixApp> {
  late final ThemeService _themeService;
  late final LocalizationService _localizationService;
  late final LoggerService _logger;

  AppThemeMode _currentThemeMode = AppThemeMode.dark;
  Locale _currentLocale = const Locale('tr', 'TR');

  @override
  void initState() {
    super.initState();
    _themeService = getIt<ThemeService>();
    _localizationService = getIt<LocalizationService>();
    _logger = getIt<LoggerService>();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Load saved theme mode
      final themeMode = await _themeService.getCurrentThemeMode();

      // Load saved locale
      final locale = await _localizationService.getCurrentLocale();

      setState(() {
        _currentThemeMode = themeMode;
        _currentLocale = locale;
      });

      _logger.info('App initialized successfully');
      _logger.debug('Theme: $_currentThemeMode, Locale: $_currentLocale');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize app', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shartflix',
      theme: _themeService.getThemeData(
          _currentThemeMode, MediaQuery.platformBrightnessOf(context)),
      locale: _currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/photo-upload': (context) => const PhotoUploadPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
