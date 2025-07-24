import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/services/movie_api_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final MovieApiService _apiService;
  final LoggerService _logger;

  const MovieRepositoryImpl(
    this._apiService,
    this._logger,
  );

  @override
  Future<Result<List<Movie>, Failure>> getMovies({
    int page = 1,
    String? search,
  }) async {
    try {
      _logger.debug('Fetching movies - page: $page, search: $search');

      final response = await _apiService.getMovies(
        page: page,
        search: search,
      );

      if (response.isSuccess && response.data != null) {
        final movies = response.data!.movies
            .map((movieModel) => movieModel.toEntity())
            .toList();

        _logger.debug('Movies fetched successfully - count: ${movies.length}');
        return Result.ok(movies);
      } else {
        final message = response.response.message;
        _logger.debug('Movies fetch failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Movies fetch dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Movies fetch unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<List<Movie>, Failure>> getFavoriteMovies({
    int page = 1,
  }) async {
    try {
      _logger.debug('Fetching favorite movies - page: $page');

      final response = await _apiService.getFavoriteMovies(page: page);

      if (response.isSuccess && response.data != null) {
        final movies = response.data!.movies
            .map((movieModel) => movieModel.toEntity())
            .toList();

        _logger.debug('Favorite movies fetched - count: ${movies.length}');
        return Result.ok(movies);
      } else {
        final message = response.response.message;
        _logger.debug('Favorite movies fetch failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Favorite movies dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Favorite movies unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<bool, Failure>> toggleFavorite(int movieId) async {
    try {
      _logger.debug('Toggling favorite status for movie - id: $movieId');

      final response = await _apiService.toggleFavorite(movieId);

      if (response.isSuccess) {
        _logger.debug('Movie favorite status toggled successfully');
        return Result.ok(true);
      } else {
        final message = response.response.message;
        _logger.debug('Toggle favorite failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Toggle favorite dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Toggle favorite unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
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
          // Check for our API format: {response: {code: ..., message: ...}}
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

        // Handle token-related errors as authentication failures regardless of status code
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
