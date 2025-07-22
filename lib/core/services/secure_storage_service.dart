import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import 'logger_service.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;
  final LoggerService _logger;

  SecureStorageService(this._storage, this._logger);

  // Generic methods
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      _logger.debug('SecureStorage: Wrote data for key: $key');
    } catch (e, stackTrace) {
      _logger.error(
          'SecureStorage: Failed to write data for key: $key', e, stackTrace);
      rethrow;
    }
  }

  Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      _logger.debug('SecureStorage: Read data for key: $key');
      return value;
    } catch (e, stackTrace) {
      _logger.error(
          'SecureStorage: Failed to read data for key: $key', e, stackTrace);
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      _logger.debug('SecureStorage: Deleted data for key: $key');
    } catch (e, stackTrace) {
      _logger.error(
          'SecureStorage: Failed to delete data for key: $key', e, stackTrace);
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      _logger.debug('SecureStorage: Deleted all data');
    } catch (e, stackTrace) {
      _logger.error('SecureStorage: Failed to delete all data', e, stackTrace);
    }
  }

  // Auth-specific methods
  Future<void> saveToken(String token) async {
    await write(AppConstants.tokenKey, token);
    _logger.logAuth('Token saved', null);
  }

  Future<String?> getToken() async {
    final token = await read(AppConstants.tokenKey);
    _logger.logAuth('Token retrieved', token != null ? 'exists' : null);
    return token;
  }

  Future<void> deleteToken() async {
    await delete(AppConstants.tokenKey);
    _logger.logAuth('Token deleted', null);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // User data methods
  Future<void> saveUserData(String userData) async {
    await write(AppConstants.userKey, userData);
    _logger.debug('User data saved');
  }

  Future<String?> getUserData() async {
    return await read(AppConstants.userKey);
  }

  Future<void> deleteUserData() async {
    await delete(AppConstants.userKey);
    _logger.debug('User data deleted');
  }

  // Complete logout
  Future<void> clearAuthData() async {
    await deleteToken();
    await deleteUserData();
    _logger.logAuth('All auth data cleared', null);
  }
}
