import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/services/logger_service.dart';
import 'core/services/theme_service.dart';
import 'core/widgets/auth_wrapper.dart';
import 'core/widgets/main_layout.dart';
import 'core/bloc/app_settings_bloc.dart';
import 'core/bloc/app_settings_event.dart';
import 'core/bloc/app_settings_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/profile/profile.dart';
import 'features/settings/presentation/pages/settings_page.dart';

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
  late final AppSettingsBloc _appSettingsBloc;

  @override
  void initState() {
    super.initState();
    _themeService = getIt<ThemeService>();
    _appSettingsBloc = getIt<AppSettingsBloc>();
    _appSettingsBloc.add(const LoadAppSettings());
  }

  @override
  void dispose() {
    _appSettingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _appSettingsBloc,
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          // Default values
          AppThemeMode themeMode = AppThemeMode.dark;
          Locale locale = const Locale('tr', 'TR');

          if (state is AppSettingsLoaded) {
            themeMode = state.themeMode;
            locale = state.locale;
          }

          return MaterialApp(
            title: 'Shartflix',
            theme: _themeService.getThemeData(
                themeMode, MediaQuery.platformBrightnessOf(context)),
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const MainLayout(initialIndex: 0),
              '/discover': (context) => const MainLayout(initialIndex: 1),
              '/profile': (context) => const MainLayout(initialIndex: 2),
              '/photo-upload': (context) => const PhotoUploadPage(),
              '/settings': (context) => const SettingsPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
