import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'logger_service.dart';

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
