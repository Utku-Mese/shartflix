# 🎬 Shartflix - Case Study


[![Flutter Version](https://img.shields.io/badge/Flutter-3.6+-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg)](https://firebase.google.com)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green.svg)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC-blue.svg)](https://bloclibrary.dev)

## Table of Contents

- [Project Overview](#-project-overview)
- [Architecture & Design Patterns](#-architecture--design-patterns)
- [Features](#-features)
- [File Structure](#-file-structure)
- [Technology Stack](#-technology-stack)
- [Firebase Integration](#-firebase-integration)
- [Design Patterns](#-design-patterns)
- [Color Scheme & Theming](#-color-scheme--theming)
- [Logger Service](#-logger-service)
- [State Management (BLoC)](#-state-management-bloc)
- [Dependency Injection](#-dependency-injection)
- [Use Cases & Clean Architecture](#-use-cases--clean-architecture)
- [MVVM Pattern Implementation](#-mvvm-pattern-implementation)
- [Constants Structure](#-constants-structure)
- [Localization](#-localization)
- [Layout System](#-layout-system)
- [Cache & Storage System](#-cache--storage-system)
- [Session & Token Management](#-session--token-management)
- [Splash Screen](#-splash-screen)
- [Navigation System](#-navigation-system)
- [Network Status Management](#-network-status-management)
- [Error & Failure Handling](#-error--failure-handling)
- [Getting Started](#-getting-started)
- [API Documentation](#-api-documentation)
- [Testing](#-testing)
- [Performance Optimization](#-performance-optimization)
- [Deployment](#-deployment)

## 📺 Preview Video

Watch the project preview video on YouTube:  
[![Watch the video](https://img.shields.io/badge/Preview-YouTube-red)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)

[![Watch the video](https://img.youtube.com/vi/M30Eq9_Ipv0/0.jpg)](https://www.youtube.com/watch?v=M30Eq9_Ipv0)


## 📦 APK Download

You can find the latest Android build in the `apk` folder at the project root:  
[Download APK](./apk/app-release.apk)


## 📱 Project Overview

Shartflix is a comprehensive, production-ready Flutter movie streaming application that demonstrates enterprise-level development practices. Built with Clean Architecture principles, MVVM pattern, and modern Flutter development techniques, this application serves as a complete reference for scalable mobile application development.

### 🎯 Project Goals

- **Scalability**: Modular architecture supporting easy feature additions
- **Maintainability**: Clear separation of concerns and well-documented code
- **Performance**: Optimized for smooth user experience across all platforms
- **Reliability**: Comprehensive error handling and crash reporting
- **User Experience**: Intuitive design with accessibility considerations
- **Multi-platform**: Support for iOS, Android, Web and macOS

### 🚀 Key Highlights

- **Enterprise-grade architecture** with Clean Architecture and MVVM
- **Comprehensive Firebase integration** (Analytics, Crashlytics, Performance)
- **Advanced state management** using BLoC pattern
- **Multi-language support** with Flutter Intl
- **Robust error handling** and logging system
- **Secure authentication** with token management
- **Responsive design** supporting multiple screen sizes
- **Dark/Light theme** with system theme detection
- **Offline capabilities** with intelligent caching
- **Real-time monitoring** and analytics

## 🏗 Architecture & Design Patterns

### Clean Architecture Overview


```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │   Widgets   │ │   Screens   │ │        BLoC             │ │
│  │   (Views)   │ │  (Pages)    │ │   (State Management)    │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │  Entities   │ │  Use Cases  │ │     Repositories        │ │
│  │  (Models)   │ │ (Business)  │ │    (Interfaces)         │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │ Data Sources│ │ Repositories│ │       Models            │ │
│  │ (API/Local) │ │(Implement.) │ │   (Data Transfer)       │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### MVVM Pattern Implementation

The application implements MVVM (Model-View-ViewModel) pattern:

- **Model**: Domain entities and data models
- **View**: Flutter widgets and screens
- **ViewModel**: BLoC classes acting as ViewModels

### Core Design Patterns

1. **Repository Pattern**: Abstract data access logic
2. **Factory Pattern**: Object creation and dependency injection
3. **Observer Pattern**: State management with BLoC
4. **Singleton Pattern**: Core services (Logger, Storage, etc.)
5. **Builder Pattern**: Complex object construction
6. **Strategy Pattern**: Different algorithms for caching, networking
7. **Command Pattern**: Use cases as commands
8. **Adapter Pattern**: External API integration

## ✨ Features

### 🔐 Authentication System
- **User Registration**: Email/password with validation
- **User Login**: Secure authentication with token management
- **Auto-login**: Remember user session
- **Profile Management**: User profile with photo upload

### 🎬 Movie Management
- **Movie Details**: Comprehensive movie information
- **Favorites System**: Add/remove favorites with sync

### 🎨 User Interface
- **Dark/Light Theme**: System and manual theme switching
- **Responsive Design**: Adaptive layouts for all screen sizes
- **Custom Components**: Reusable UI components library

### 🌍 Internationalization
- **Multi-language Support**: English, Turkish (extensible)
- **Dynamic Language Switching**: Runtime language changes

### 📊 Analytics & Monitoring
- **User Behavior Tracking**: Page views, interactions
- **Performance Monitoring**: App performance metrics
- **Crash Reporting**: Automatic crash detection and reporting
- **Custom Events**: Business-specific event tracking
- **Real-time Debugging**: Firebase Analytics debug mode

### 🔧 Developer Features
- **Comprehensive Logging**: Categorized logging system
- **Code Generation**: Automated boilerplate generation

## 📁 File Structure

```
shartflix/
├── android/                          # Android platform configuration
├── ios/                              # iOS platform configuration
├── macos/                            # macOS platform configuration
├── web/                              # Web platform configuration
├── linux/                           # Linux platform configuration
├── lib/                             # Main application code
│   ├── core/                        # Core functionality (shared across features)
│   │   ├── bloc/                    # Core BLoC implementations
│   │   │   ├── connectivity/        # Network connectivity BLoC
│   │   │   └── theme/              # Theme management BLoC
│   │   ├── constants/              # Application constants
│   │   │   ├── api_constants.dart  # API endpoints and configurations
│   │   │   ├── app_colors.dart     # Color palette definitions
│   │   │   ├── app_constants.dart  # General app constants
│   │   │   ├── app_theme.dart      # Theme configurations
│   │   │   ├── asset_constants.dart # Asset paths
│   │   │   └── route_constants.dart # Route names and paths
│   │   ├── di/                     # Dependency Injection
│   │   │   ├── injection.dart      # GetIt configuration
│   │   │   └── injection.config.dart # Generated DI configuration
│   │   ├── error/                  # Error handling
│   │   │   ├── exceptions.dart     # Custom exceptions
│   │   │   ├── failures.dart       # Failure classes
│   │   │   └── error_handler.dart  # Global error handling
│   │   ├── network/                # Network layer
│   │   │   ├── api_client.dart     # Dio HTTP client configuration
│   │   │   ├── network_info.dart   # Network connectivity checker
│   │   ├── services/               # Core services
│   │   │   ├── firebase_service.dart # Firebase integration
│   │   │   ├── logger_service.dart # Logging service
│   │   │   └── theme_service.dart  # Theme management
│   │   ├── utils/                  # Utility functions
│   │   │   ├── extensions/         # Dart extensions
│   │   │   ├── formatters/         # Data formatters
│   │   │   ├── helpers/           # Helper functions
│   │   │   └── validators/        # Input validators
│   │   └── widgets/               # Reusable UI components
│   │       ├── buttons/           # Custom button components
│   │       ├── dialogs/           # Dialog components
│   │       ├── forms/             # Form components
│   │       ├── loaders/           # Loading indicators
│   │       └── common/            # Common widgets
│   ├── features/                  # Feature modules (Clean Architecture)
│   │   ├── auth/                  # Authentication feature
│   │   │   ├── data/              # Data layer
│   │   │   │   ├── datasources/   # Data sources (API/Local)
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── models/        # Data models
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   └── auth_response_model.dart
│   │   │   │   └── repositories/  # Repository implementations
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/            # Domain layer
│   │   │   │   ├── entities/      # Domain entities
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/  # Repository interfaces
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/      # Use cases (business logic)
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       ├── logout_usecase.dart
│   │   │   │       └── get_current_user_usecase.dart
│   │   │   └── presentation/      # Presentation layer
│   │   │       ├── bloc/          # BLoC state management
│   │   │       │   ├── auth_bloc.dart
│   │   │       │   ├── auth_event.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── pages/         # Screen widgets
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   └── profile_page.dart
│   │   │       └── widgets/       # Feature-specific widgets
│   │   │           ├── login_form.dart
│   │   │           ├── register_form.dart
│   │   │           └── profile_avatar.dart
│   │   ├── movies/                # Movies feature (similar structure)
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── profile/               # Profile feature
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── settings/              # Settings feature
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── splash/                # Splash screen feature
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── l10n/                      # Localization files
│   │   ├── app_en.arb            # English translations
│   │   ├── app_tr.arb            # Turkish translations
│   ├── shared/                   # Shared utilities and widgets
│   │   ├── widgets/              # Shared widgets
│   │   └── utils/                # Shared utilities
│   ├── firebase_options.dart     # Firebase configuration
│   └── main.dart                 # Application entry point
├── assets/                       # Static assets
│   ├── images/                   # Image assets
│   ├── icons/                    # Icon assets
│   ├── fonts/                    # Font files
│   └── animations/               # Lottie animations
├── analysis_options.yaml         # Dart analysis configuration
├── pubspec.yaml                  # Dependencies and metadata
└── README.md                     # Project documentation
```

## 🛠 Technology Stack

### 🎯 Core Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | 3.6+ | Cross-platform UI framework |
| **Dart** | 3.0+ | Programming language |
| **Material Design 3** | Latest | Design system and UI components |

### 📦 Key Dependencies

#### State Management
```yaml
flutter_bloc: ^8.1.6           # BLoC pattern implementation
equatable: ^2.0.5              # Value equality for state classes
```

#### Dependency Injection
```yaml
get_it: ^8.0.0                 # Service locator
injectable: ^2.5.0             # Code generation for DI
injectable_generator: ^2.6.2    # Build runner for injectable
```

#### Networking
```yaml
dio: ^5.7.0                    # HTTP client
connectivity_plus: ^6.0.5      # Network connectivity detection
json_annotation: ^4.9.0        # JSON serialization annotations
json_serializable: ^6.8.0      # JSON serialization code generation
```

#### Firebase Integration
```yaml
firebase_core: ^3.6.0          # Firebase core functionality
firebase_analytics: ^11.3.3    # User analytics and behavior tracking
firebase_crashlytics: ^4.1.3   # Crash reporting and error tracking
firebase_performance: ^0.10.0+8 # Performance monitoring
```

#### Storage & Security
```yaml
flutter_secure_storage: ^9.2.2 # Encrypted local storage
shared_preferences: ^2.3.2     # Simple key-value storage
package_info_plus: ^8.0.2      # App package information
```

#### UI Components & Media
```yaml
cached_network_image: ^3.4.1   # Efficient image caching and loading
image_picker: ^1.1.2           # Camera and gallery image selection
flutter_svg: ^2.2.0            # SVG image support
```

#### Internationalization
```yaml
flutter_localizations:         # Flutter's built-in localization
  sdk: flutter
intl: ^0.19.0                  # Internationalization utilities
```

#### Development Tools
```yaml
logger: ^2.4.0                 # Logging utility
flutter_native_splash: ^2.4.1  # Native splash screen
build_runner: ^2.4.13         # Code generation runner
flutter_launcher_icons: ^0.14.4 # App icon generation
```

#### Testing
```yaml
flutter_test:                 # Flutter testing framework
  sdk: flutter
flutter_lints: ^5.0.0         # Dart linting rules
```

### 🏗 Architecture Dependencies

#### Clean Architecture Layers
- **Presentation**: `flutter_bloc` for state management
- **Domain**: Pure Dart with `equatable` for entities
- **Data**: `dio` for networking, storage services for persistence

#### MVVM Implementation
- **Model**: Domain entities and data models
- **View**: Flutter widgets with `flutter_bloc` widgets
- **ViewModel**: BLoC classes acting as ViewModels

### 📱 Platform-Specific Features

#### Android
- **Minimum SDK**: 21 (Android 5.0)
- **Target SDK**: 35 (Android 15)
- **Kotlin**: 2.1.0
- **Android Gradle Plugin**: 8.7.3

#### iOS
- **Minimum Deployment**: 12.0
- **Swift**: 5.0+
- **Xcode**: 14.0+

#### Web
- **Dart Compilation**: dart2js
- **PWA Support**: Enabled
- **Web Renderers**: HTML, CanvasKit

#### macOS
- **Minimum Deployment**: 11.0
- **Universal Binary**: Supported

## 🔥 Firebase Integration

### Firebase Project Configuration

| Platform | App ID | Bundle/Package ID |
|----------|--------|-------------------|
| **Web** | `1:745682564401:web:e4672cf6919728d9182c10` | `com.example.shartflix` |
| **Android** | `1:745682564401:android:d46e75be8dbfa247182c10` | `com.example.shartflix` |
| **iOS** | `1:745682564401:ios:75e0c71f79b9e75e182c10` | `com.example.shartflix` |
| **macOS** | `1:745682564401:ios:75e0c71f79b9e75e182c10` | `com.example.shartflix` |

### Firebase Services Implementation

#### 📊 Firebase Analytics
```dart
// Core analytics tracking
class FirebaseService {
  static FirebaseAnalytics get analytics => _analytics!;

  // User behavior tracking
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics!.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // Custom event tracking
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics!.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
```

#### 💥 Firebase Crashlytics
```dart
// Crash reporting with context
static Future<void> recordError({
  required dynamic exception,
  StackTrace? stackTrace,
  String? reason,
  bool fatal = false,
}) async {
  if (kIsWeb || _crashlytics == null) {
    debugPrint('Error recorded (Web): $exception');
    return;
  }
  
  await _crashlytics!.recordError(
    exception,
    stackTrace,
    reason: reason,
    fatal: fatal,
  );
}

// Custom logging
static Future<void> log(String message) async {
  if (kIsWeb || _crashlytics == null) {
    debugPrint('Crashlytics log (Web): $message');
    return;
  }
  
  await _crashlytics!.log(message);
}
```

#### ⚡ Firebase Performance
```dart
// Performance monitoring
static Trace? startTrace(String traceName) {
  if (_performance == null) return null;
  return _performance!.newTrace(traceName);
}

// HTTP performance tracking
static HttpMetric? newHttpMetric(String url, HttpMethod httpMethod) {
  if (_performance == null) return null;
  return _performance!.newHttpMetric(url, httpMethod);
}
```

### 📈 Tracked Events

#### Authentication Events
- `login` - User login with method parameter
- `sign_up` - User registration with method parameter
- `logout` - User logout

#### Movie Interaction Events
- `movie_view` - Movie detail page visits
- `favorite_movie` / `unfavorite_movie` - Favorite actions

#### User Journey Events
- `screen_view` - Page navigation tracking
- `app_open` - App launch events
- `session_start` / `session_end` - User session tracking

#### Performance Events
- `app_performance` - Custom performance metrics

#### Error Events
- `error_boundary` - Caught application errors
- `network_error` - Network connectivity issues
- `validation_error` - Form validation failures

### 🚀 Firebase Debug Mode

Enable debug mode for real-time event tracking:

```bash
# Android
flutter run --dart-define=FIREBASE_ANALYTICS_DEBUG_MODE=true

# iOS
flutter run --dart-define=FIREBASE_ANALYTICS_DEBUG_MODE=true

# Web
flutter run -d chrome --dart-define=FIREBASE_ANALYTICS_DEBUG_MODE=true
```

## 🎨 Color Scheme & Theming

### Color Palette

The application uses a Netflix-inspired color scheme with comprehensive light and dark theme support:

#### Primary Colors
```dart
static const Color primary = Color(0xFFE50914);      // Netflix Red
static const Color primaryDark = Color(0xFF6F060B);  // Darker Red
```

#### Dark Theme (Default)
```dart
// Background Colors
static const Color darkBackground = Color(0xFF090909);        // Almost Black
static const Color darkCardBackground = Color(0xFF1A1A1A);    // Dark Gray
static const Color darkSurfaceBackground = Color(0xFF1C1C1C); // Surface Gray

// Text Colors
static const Color darkTextPrimary = Color(0xFFFFFFFF);       // White
static const Color darkTextSecondary = Color(0xFFB0B0B0);     // Light Gray
static const Color darkTextTertiary = Color(0xFF808080);      // Medium Gray
```

#### Light Theme
```dart
// Background Colors
static const Color lightBackground = Color(0xFFFFFFFF);        // Pure White
static const Color lightCardBackground = Color(0xFFF8F9FA);    // Off White
static const Color lightSurfaceBackground = Color(0xFFFAFAFA); // Light Surface

// Text Colors
static const Color lightTextPrimary = Color(0xFF212121);       // Dark Gray
static const Color lightTextSecondary = Color(0xFF616161);     // Medium Gray
static const Color lightTextTertiary = Color(0xFF9E9E9E);      // Light Gray
```

#### Status Colors
```dart
static const Color success = Color(0xFF4CAF50);  // Green
static const Color warning = Color(0xFFFF9800);  // Orange
static const Color error = Color(0xFFF44336);    // Red
static const Color info = Color(0xFF2196F3);     // Blue
```

### Log Output Examples

```
flutter: ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
flutter: │ #0   LoggerService.debug (package:shartflix/core/services/logger_service.dart:22:13)
flutter: │ #1   SecureStorageService.read (package:shartflix/core/services/secure_storage_service.dart:28:15)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 00:57:55.228 (+0:00:03.669513)
flutter: ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
flutter: │ 🐛 SecureStorage: Read data for key: auth_token
flutter: └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```

## 🔄 State Management (BLoC)

### BLoC Pattern Architecture

The application uses the BLoC (Business Logic Component) pattern for comprehensive state management:

```dart
// Event-State-BLoC Pattern Implementation
abstract class AuthEvent extends Equatable {}
abstract class AuthState extends Equatable {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({required this.loginUseCase, required this.logoutUseCase}) 
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }
}
```

### Core BLoCs

- **AuthBloc**: Authentication state management
- **MoviesBloc**: Movie list and pagination  
- **ThemeBloc**: Theme switching and persistence
- **ConnectivityBloc**: Network status monitoring
- **ProfileBloc**: User profile management

## 💉 Dependency Injection

### GetIt + Injectable Configuration

```dart
@InjectableInit()
void configureDependencies() => getIt.init();

// Service registrations
@singleton
class AuthRepository {}

@lazySingleton  
class ApiClient {}
```

### Module Structure
- **Core Module**: Essential services (Logger, Storage, Network)
- **Data Module**: Repositories and data sources
- **Domain Module**: Use cases and business logic

## 🏛 Use Cases & Clean Architecture

### Use Case Implementation

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetMoviesUseCase implements UseCase<List<Movie>, GetMoviesParams> {
  final MovieRepository repository;
  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetMoviesParams params) async {
    return await repository.getMovies(page: params.page, limit: params.limit);
  }
}
```

### Layer Separation
- **Presentation**: Widgets, Pages, BLoCs
- **Domain**: Entities, Use Cases, Repository Interfaces  
- **Data**: Repository Implementations, Data Sources, Models

## 📋 Constants Structure

### Organized Constants

```dart
// API Constants
class ApiConstants {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';
  static const String moviesEndpoint = '/user/movies';
}

// App Constants
class AppConstants {
  // App Info
  static const String appName = 'Shartflix';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxUsernameLength = 50;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 18.0;
  static const double defaultElevation = 4.0;
}


// Route Constants  
class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
}
```

## 🌍 Localization

### Multi-language Support

- **English (en)**: Default language
- **Turkish (tr)**: Secondary language
- **Extensible**: Easy to add new languages

## 💾 Cache & Storage System

### Cache Strategy

- **User Profile**: Memory cache
- **Images**: Cached indefinitely with LRU eviction

### Session Management

- **Auto-refresh**: Tokens refreshed automatically
- **Secure Storage**: Encrypted local storage

## 🌐 Network Status Management

### Connectivity Monitoring

```dart
@injectable
class ConnectivityService {
  final Connectivity _connectivity;
  final LoggerService _logger;

  ConnectivityService(this._connectivity, this._logger);

  /// Check if device has internet connection
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        _logger.warning('No connectivity detected');
        return false;
      }

      // Additional check to verify internet access
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _logger.info('Internet connection verified');
        return true;
      }

      _logger.warning('DNS lookup failed - no internet');
      return false;
    } catch (e) {
      _logger.error('Error checking connectivity', e);
      return false;
    }
  }

  /// Get current connectivity status
  Future<ConnectivityResult> getCurrentConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.first;
    } catch (e) {
      _logger.error('Error getting connectivity status', e);
      return ConnectivityResult.none;
    }
  }

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Check specific API endpoint connectivity
  Future<bool> canReachApi() async {
    try {
      final result = await InternetAddress.lookup('https://caseapi.servicelabs.tech');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _logger.info('API server reachable');
        return true;
      }

      _logger.warning('API server unreachable');
      return false;
    } catch (e) {
      _logger.error('Error reaching API server', e);
      return false;
    }
  }
}

```

## ❌ Error & Failure Handling

### Comprehensive Error System

```dart
// Custom Failures
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
```

## 🚀 Getting Started

### 📋 Prerequisites

#### System Requirements
- **Operating System**: macOS 10.15+, Windows 10+, Ubuntu 18.04+
- **Flutter SDK**: 3.6.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Git**: Latest version

#### Platform-Specific Requirements

**For Android Development:**
- Android Studio 2022.1.1+
- Android SDK 21+ (Android 5.0)
- Java Development Kit (JDK) 17

**For iOS Development:**
- macOS 10.15+
- Xcode 14.0+
- iOS 12.0+
- CocoaPods installed

**For Web Development:**
- Chrome browser
- Web server for testing

### 🔧 Installation Steps

#### 1. Clone the Repository

```bash
# Using HTTPS
git clone https://github.com/your-username/shartflix.git
cd shartflix
```

#### 2. Install Flutter Dependencies

```bash
# Install all dependencies
flutter pub get

# Verify dependencies
flutter pub deps
```

#### 3. Generate Required Code

```bash
# Generate dependency injection code
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 4. Generate Localization Files

```bash
# Generate localization code
flutter gen-l10n
```

#### 5. Firebase Configuration

##### Option A: Use Existing Configuration (Recommended for Testing)
The project comes with pre-configured Firebase settings. You can use them for testing:

```bash
# Firebase is already configured in:
# - lib/firebase_options.dart
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
# - macos/Runner/GoogleService-Info.plist
```

##### Option B: Setup Your Own Firebase Project

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

#### Development Mode Features

```bash
# Run with hot reload (default)
flutter run

# Run in release mode
flutter run --release

# Run with flavor (if configured)
flutter run --flavor development
```

## 📊 Performance Optimization

### Performance Strategies

- **Image Optimization**: Cached network images with loading states
- **Lazy Loading**: Pagination for large lists
- **Build Optimization**: Efficient widget rebuilds with BLoC selectors

### Monitoring

- **Firebase Performance**: Automatic performance tracking
- **Custom Metrics**: Business-specific performance measurements
- **Memory Profiling**: Development-time memory analysis

---

***BUILD BY MEHMET UTKU MESE***