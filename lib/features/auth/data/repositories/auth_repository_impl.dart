import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/services/auth_api_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_requests.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final SecureStorageService _secureStorage;
  final LoggerService _logger;

  const AuthRepositoryImpl(
    this._apiService,
    this._secureStorage,
    this._logger,
  );

  @override
  Future<Result<User, Failure>> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.logAuth('Attempting login', email);

      final request = LoginRequest(
        email: email,
        password: password,
      );

      final response = await _apiService.login(request);

      if (response.isSuccess && response.data != null) {
        final user = response.data!.toEntity();

        // Store auth token separately for API requests
        await _secureStorage.saveToken(response.data!.token);

        // Store complete user data
        await _secureStorage.saveUserData(jsonEncode(response.data!.toJson()));

        _logger.logAuth('Login successful', user.email);
        return Result.ok(user);
      } else {
        final message = response.response.message;
        _logger.logAuth('Login failed: $message', email);
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Login dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Login unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<User, Failure>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      _logger.logAuth('Attempting registration', email);

      final request = RegisterRequest(
        email: email,
        name: '$firstName $lastName', // API expects single name field
        password: password,
      );

      final response = await _apiService.register(request);

      if (response.isSuccess && response.data != null) {
        final user = response.data!.toEntity();

        // Store auth token separately for API requests
        await _secureStorage.saveToken(response.data!.token);

        // Store complete user data
        await _secureStorage.saveUserData(jsonEncode(response.data!.toJson()));

        _logger.logAuth('Registration successful', user.email);
        return Result.ok(user);
      } else {
        final message = response.response.message;
        _logger.logAuth('Registration failed: $message', email);
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Registration dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Registration unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<User, Failure>> getProfile() async {
    try {
      _logger.logAuth('Fetching profile', null);

      final response = await _apiService.getProfile();

      if (response.isSuccess && response.data != null) {
        final user = response.data!.toEntity();

        // Update stored user data
        await _secureStorage.saveUserData(jsonEncode(response.data!.toJson()));

        _logger.logAuth('Profile fetch successful', user.email);
        return Result.ok(user);
      } else {
        final message = response.response.message;
        _logger.logAuth('Profile fetch failed: $message', null);
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Profile fetch dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Profile fetch unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<String, Failure>> uploadProfilePhoto({
    required MultipartFile photo,
  }) async {
    try {
      _logger.logAuth('Attempting photo upload', null);

      final formData = FormData.fromMap({
        'photo': photo,
      });

      final response = await _apiService.uploadProfilePhoto(formData);

      if (response.isSuccess && response.data != null) {
        final photoUrl = response.data!.photoUrl;
        _logger.logAuth('Photo upload successful', photoUrl);
        return Result.ok(photoUrl);
      } else {
        final message = response.response.message;
        _logger.logAuth('Photo upload failed: $message', null);
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Photo upload dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Photo upload unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<void, Failure>> logout() async {
    try {
      _logger.logAuth('Attempting logout', null);

      // Clear stored auth data
      await _secureStorage.clearAuthData();

      _logger.logAuth('Logout successful', null);
      return Result.ok(null);
    } catch (e) {
      _logger.error('Logout error', e, StackTrace.current);
      return Result.err(ServerFailure('Logout failed'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _secureStorage.hasToken();
    } catch (e) {
      _logger.error('Is logged in check error', e, StackTrace.current);
      return false;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _secureStorage.getUserData();
      if (userData != null) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        final userModel = UserModel.fromJson(userJson);
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      _logger.error('Get current user error', e, StackTrace.current);
      return null;
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        // Try to extract message from API response format first
        String message = 'Server error';
        final responseData = error.response?.data;

        if (responseData is Map<String, dynamic>) {
          // Check for our API format
          if (responseData['response'] is Map<String, dynamic>) {
            final responseInfo =
                responseData['response'] as Map<String, dynamic>;
            message = responseInfo['message'] ?? message;
          }
          // Fallback to direct message field
          else if (responseData['message'] != null) {
            message = responseData['message'];
          }
        }

        // Handle token errors
        if (message.contains('TOKEN_UNAVAILABLE') ||
            message.contains('TOKEN_EXPIRED') ||
            message.contains('INVALID_TOKEN')) {
          return AuthFailure(message: message);
        }

        switch (statusCode) {
          case 400:
            return ValidationFailure(message);
          case 401:
            return AuthFailure(message: message);
          case 403:
            return AuthFailure(message: message);
          case 404:
            return ServerFailure('Resource not found');
          case 500:
            return ServerFailure('Internal server error');
          default:
            return ServerFailure(message);
        }
      case DioExceptionType.cancel:
        return ServerFailure('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkFailure('No internet connection');
      default:
        return ServerFailure('Unexpected error occurred');
    }
  }
}
