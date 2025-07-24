import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class LoggerService {
  late final Logger _logger;

  LoggerService() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Network logging
  void logRequest(String method, String url, Map<String, dynamic>? data) {
    info('$method $url', data);
  }

  void logResponse(String method, String url, int statusCode, dynamic data) {
    if (statusCode >= 200 && statusCode < 300) {
      info('$method $url - $statusCode', data);
    } else {
      error('$method $url - $statusCode', data);
    }
  }

  // Auth logging
  void logAuth(String action, String? userId) {
    info('Auth: $action ${userId != null ? 'for user $userId' : ''}');
  }

  // Navigation logging
  void logNavigation(String from, String to) {
    info('Navigation: $from → $to');
  }

  // Business logic logging
  void logBusinessEvent(String event, Map<String, dynamic>? data) {
    info('Business Event: $event', data);
  }
}
