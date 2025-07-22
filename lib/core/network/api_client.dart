import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

@injectable
class ApiClient {
  final Dio _dio;
  final SharedPreferences _prefs;

  ApiClient(this._dio, this._prefs) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Request interceptor for adding auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _prefs.getString(AppConstants.tokenKey);
          if (token != null) {
            options.headers[ApiConstants.authorization] =
                '${ApiConstants.bearer} $token';
          }
          options.headers[Headers.contentTypeHeader] = ApiConstants.contentType;
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle common errors
          if (error.response?.statusCode == 401) {
            // Token expired or invalid
            _prefs.remove(AppConstants.tokenKey);
            _prefs.remove(AppConstants.userKey);
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;
}
