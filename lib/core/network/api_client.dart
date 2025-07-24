import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_constants.dart';
import '../services/logger_service.dart';
import '../services/secure_storage_service.dart';
import '../services/connectivity_service.dart';

@injectable
class ApiClient {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  final LoggerService _logger;
  final ConnectivityService _connectivity;

  ApiClient(this._dio, this._secureStorage, this._logger, this._connectivity) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Request interceptor for adding auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check internet connectivity first
          final hasConnection = await _connectivity.hasInternetConnection();
          if (!hasConnection) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection available',
                type: DioExceptionType.connectionError,
              ),
            );
            return;
          }

          final token = await _secureStorage.getToken();
          if (token != null) {
            options.headers[ApiConstants.authorization] =
                '${ApiConstants.bearer} $token';
          }
          options.headers[Headers.contentTypeHeader] = ApiConstants.contentType;

          _logger.logRequest(
            options.method,
            options.uri.toString(),
            options.data,
          );

          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.logResponse(
            response.requestOptions.method,
            response.requestOptions.uri.toString(),
            response.statusCode ?? 0,
            response.data,
          );
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.logResponse(
            error.requestOptions.method,
            error.requestOptions.uri.toString(),
            error.response?.statusCode ?? 0,
            error.response?.data,
          );

          // Handle common errors
          if (error.response?.statusCode == 401) {
            // Token expired or invalid
            _secureStorage.clearAuthData();
            _logger.logAuth('Token invalidated due to 401 error', null);
          }

          // Handle connectivity errors
          if (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {

            final connectivityError = DioException(
              requestOptions: error.requestOptions,
              error: 'İnternet bağlantısı kontrol ediniz',
              type: DioExceptionType.connectionError,
            );
            handler.next(connectivityError);
            return;
          }

          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
