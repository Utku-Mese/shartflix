import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../firebase_options.dart';

@singleton
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebasePerformance? _performance;

  static FirebaseAnalytics get analytics => _analytics!;
  static FirebaseCrashlytics? get crashlytics => _crashlytics;
  static FirebasePerformance get performance => _performance!;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _analytics = FirebaseAnalytics.instance;

      // not supported on web
      if (!kIsWeb) {
        _crashlytics = FirebaseCrashlytics.instance;
        // Crashlytics configuration
        await _configureCrashlytics();
      }

      _performance = FirebasePerformance.instance;

      // Analytics configuration
      await _configureAnalytics();

      debugPrint('Firebase services initialized successfully');
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      rethrow;
    }
  }

  /// Crashlytics configuration
  static Future<void> _configureCrashlytics() async {
    // not supported on web
    if (kIsWeb || _crashlytics == null) return;

    // Disable crashlytics in debug mode
    if (kDebugMode) {
      await _crashlytics!.setCrashlyticsCollectionEnabled(false);
    } else {
      await _crashlytics!.setCrashlyticsCollectionEnabled(true);
    }

    FlutterError.onError = (errorDetails) {
      _crashlytics!.recordFlutterFatalError(errorDetails);
    };
    // Catch platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics!.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Analytics configuration
  static Future<void> _configureAnalytics() async {
    if (_analytics == null) return;

    await _analytics!.setAnalyticsCollectionEnabled(true);

    if (kDebugMode) {
      await _analytics!.setAnalyticsCollectionEnabled(true);
      print('Firebase Analytics Debug Mode: ENABLED');
    }
  }

  static Future<void> setUserProperties({
    required String userId,
    String? userType,
  }) async {
    if (_analytics == null) return;

    await _analytics!.setUserId(id: userId);

    if (userType != null) {
      await _analytics!.setUserProperty(name: 'user_type', value: userType);
    }
  }

  /// Log event
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (_analytics == null) return;

    await _analytics!.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Log screen view
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (_analytics == null) return;

    await _analytics!.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Log login event
  static Future<void> logLogin(String loginMethod) async {
    await logEvent(
      name: 'login',
      parameters: {
        'method': loginMethod,
      },
    );
  }

  /// Log sign up event
  static Future<void> logSignUp(String signUpMethod) async {
    await logEvent(
      name: 'sign_up',
      parameters: {
        'method': signUpMethod,
      },
    );
  }

  /// Log movie favorite event
  static Future<void> logMovieFavorite({
    required String movieId,
    required String movieTitle,
    required bool isFavorited,
  }) async {
    await logEvent(
      name: isFavorited ? 'favorite_movie' : 'unfavorite_movie',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
      },
    );
  }

  /// Log error
  static Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  }) async {

    if (kIsWeb || _crashlytics == null) {
      debugPrint('Error recorded (Web): $exception');
      if (stackTrace != null) debugPrint('Stack trace: $stackTrace');
      return;
    }

    await _crashlytics!.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  /// Log custom message
  static Future<void> log(String message) async {
    if (kIsWeb || _crashlytics == null) {
      debugPrint('Crashlytics log (Web): $message');
      return;
    }

    await _crashlytics!.log(message);
  }

  /// Start performance tracking
  static Trace? startTrace(String traceName) {
    if (_performance == null) return null;

    return _performance!.newTrace(traceName);
  }

  /// Create HTTP metric
  static HttpMetric? newHttpMetric(String url, HttpMethod httpMethod) {
    if (_performance == null) return null;

    return _performance!.newHttpMetric(url, httpMethod);
  }

  static Future<void> logMovieFavoriteAction({
    required String movieId,
    required bool isAdding,
    required bool success,
  }) async {
    await logEvent(
      name: 'movie_favorite_action',
      parameters: {
        'movie_id': movieId,
        'action': isAdding ? 'add' : 'remove',
        'success': success,
      },
    );
  }

  static Future<void> logAppPerformance({
    required String operation,
    required int durationMs,
    Map<String, Object>? additionalData,
  }) async {
    final parameters = <String, Object>{
      'operation': operation,
      'duration_ms': durationMs,
    };

    if (additionalData != null) {
      parameters.addAll(additionalData);
    }

    await logEvent(
      name: 'app_performance',
      parameters: parameters,
    );
  }

  static Future<void> logPageView({
    required String pageName,
    String? pageClass,
    Map<String, Object>? additionalData,
  }) async {
    final parameters = <String, Object>{
      'page_name': pageName,
    };

    if (pageClass != null) {
      parameters['page_class'] = pageClass;
    }

    if (additionalData != null) {
      parameters.addAll(additionalData);
    }

    await logEvent(
      name: 'page_view',
      parameters: parameters,
    );
  }
}
