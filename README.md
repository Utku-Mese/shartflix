# Shartflix

A modern Flutter movie application built with Clean Architecture and MVVM pattern.

## Project Overview

Shartflix is a comprehensive movie streaming application case study that demonstrates professional Flutter development practices with modular architecture, state management, and internationalization.

## Features

### Core Features
- **Authentication**: User login, registration, and profile management
- **Movie Browsing**: Infinite scroll movie listing with pagination
- **Favorites**: Add/remove movies from favorites with real-time UI updates
- **Profile Management**: User profile with photo upload functionality
- **Limited Offer Bottom Sheet**: Special subscription offers

### Bonus Features 
- **Custom Theme System**: Light/Dark theme support with system detection
- **Localization**: Multi-language support (English, Turkish)
- **Logger Service**: Comprehensive logging for debugging and monitoring. Network, authentication, and business event logging
- **Secure Token Management**: Encrypted storage for authentication tokens
- **Splash Screen**: Animated splash screen with smooth transitions

## Architecture

### Clean Architecture Layers
```
lib/
├── core/                   # Shared core functionality
│   ├── constants/         # App constants, colors, themes
│   ├── di/               # Dependency injection setup
│   ├── error/            # Error handling (failures, exceptions)
│   ├── network/          # API client configuration
│   ├── services/         # Core services (logger, storage, theme, i18n)
│   └── utils/            # Utilities and extensions
├── features/             # Feature-based modules
│   ├── auth/             # Authentication feature
│   ├── movies/           # Movies feature
│   └── profile/          # Profile feature
└── l10n/                 # Localization files
```

### Technology Stack
- **Framework**: Flutter 3.6+
- **State Management**: Bloc
- **Architecture**: Clean Architecture + MVVM
- **Dependency Injection**: GetIt + Injectable
- **Network**: Dio + Retrofit
- **Storage**: Shared Preferences + Flutter Secure Storage
- **Localization**: Flutter Intl
- **Testing**: Unit tests with comprehensive coverage

## Getting Started

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shartflix
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Generate localization**
   ```bash
   flutter gen-l10n
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Development

### Code Generation
Run this command when you modify injectable classes or JSON models:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Localization
Add new translations in `lib/l10n/app_en.arb` and `lib/l10n/app_tr.arb`, then run:
```bash
flutter gen-l10n
```

### Testing
```bash
flutter test                    # Run all tests
flutter test --coverage        # Run tests with coverage
```

### Code Analysis
```bash
flutter analyze                 # Static code analysis
```

## API Endpoints

The application integrates with the following API endpoints:

### Authentication
- `POST /user/login` - User login
- `POST /user/register` - User registration
- `GET /user/profile` - Get user profile
- `POST /user/upload_photo` - Upload profile photo

### Movies
- `GET /movie/list` - Get paginated movie list
- `GET /movie/favorites` - Get user's favorite movies
- `POST /movie/favorite/{favoriteId}` - Add/remove favorite

## Core Services

### Logger Service
Comprehensive logging with categorized outputs:
- **Network requests/responses**
- **Authentication events**
- **Navigation tracking**
- **Business logic events**
- **Error tracking with stack traces**

### Theme Service
- Light/Dark theme switching
- System theme detection
- Persistent theme preference
- Custom color schemes

### Localization Service
- Multi-language support
- Runtime language switching
- Fallback to default language
- Persistent language preference

### Secure Storage Service
- Encrypted token storage
- Secure user data persistence
- Automatic token management
- Cross-platform compatibility

## Configuration

### API Configuration
Update the base URL in `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://your-api-base-url.com/api';
```

### Theme Customization
Modify colors in `lib/core/constants/app_colors.dart` and themes in `lib/core/constants/app_theme.dart`.

### Localization
Add new languages by creating new `.arb` files in `lib/l10n/` and updating the supported locales.
