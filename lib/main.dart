import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injection.dart';
import 'core/services/logger_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/localization_service.dart';

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
  Locale _currentLocale = const Locale('en', 'US');

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
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocalizationService.supportedLocales,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
  }

  Future<void> _startSplashSequence() async {
    final logger = getIt<LoggerService>();

    // Start animation
    _animationController.forward();

    try {
      // Simulate initialization time
      await Future.delayed(const Duration(seconds: 3));

      logger.info('Splash sequence completed');

      // Navigate to main content
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.error('Error during splash sequence', e, stackTrace);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo placeholder
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.movie,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Shartflix',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Movie Experience',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shartflix'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _toggleTheme(context),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Shartflix!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'All core services are ready:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('✅ Logger Service'),
            Text('✅ Secure Storage Service'),
            Text('✅ Theme Service'),
            Text('✅ Localization Service'),
            Text('✅ Dependency Injection'),
            SizedBox(height: 32),
            Text(
              'Ready for feature development!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  // TODO: Change language to English
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Türkçe'),
                onTap: () {
                  // TODO: Change language to Turkish
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTheme(BuildContext context) {
    final themeService = getIt<ThemeService>();
    themeService.toggleTheme();
    // TODO: Implement theme change notification
  }
}
