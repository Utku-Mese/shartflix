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
  Future<Result<List<Movie>, Failure>> getFeaturedMovies() async {
    try {
      _logger.debug('Fetching featured movies');

      final response = await _apiService.getFeaturedMovies();

      if (response.isSuccess && response.data != null) {
        final movies = response.data!.movies
            .map((movieModel) => movieModel.toEntity())
            .toList();

        _logger.debug('Featured movies fetched - count: ${movies.length}');
        return Result.ok(movies);
      } else {
        final message = response.response.message;
        _logger.debug('Featured movies fetch failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Featured movies dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Featured movies unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<List<Movie>, Failure>> getTrendingMovies() async {
    try {
      _logger.debug('Fetching trending movies');

      final response = await _apiService.getTrendingMovies();

      if (response.isSuccess && response.data != null) {
        final movies = response.data!.movies
            .map((movieModel) => movieModel.toEntity())
            .toList();

        _logger.debug('Trending movies fetched - count: ${movies.length}');
        return Result.ok(movies);
      } else {
        final message = response.response.message;
        _logger.debug('Trending movies fetch failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Trending movies dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Trending movies unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<Movie, Failure>> getMovieDetail(int movieId) async {
    try {
      _logger.debug('Fetching movie detail - id: $movieId');

      final response = await _apiService.getMovieDetail(movieId);

      if (response.isSuccess && response.data != null) {
        final movie = response.data!.toEntity();

        _logger.debug('Movie detail fetched - title: ${movie.title}');
        return Result.ok(movie);
      } else {
        final message = response.response.message;
        _logger.debug('Movie detail fetch failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Movie detail dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Movie detail unexpected error', e, StackTrace.current);
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
  Future<Result<List<Movie>, Failure>> getWatchLaterMovies({
    int page = 1,
  }) async {
    try {
      _logger.debug('Fetching watch later movies - page: $page');

      final response = await _apiService.getWatchLaterMovies(page: page);

      if (response.isSuccess && response.data != null) {
        final movies = response.data!.movies
            .map((movieModel) => movieModel.toEntity())
            .toList();

        _logger.debug('Watch later movies fetched - count: ${movies.length}');
        return Result.ok(movies);
      } else {
        final message = response.response.message;
        _logger.debug('Watch later movies fetch failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Watch later movies dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error(
          'Watch later movies unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<bool, Failure>> addToFavorites(int movieId) async {
    try {
      _logger.debug('Adding movie to favorites - id: $movieId');

      final response = await _apiService.addToFavorites(movieId);

      if (response.isSuccess) {
        _logger.debug('Movie added to favorites successfully');
        return Result.ok(true);
      } else {
        final message = response.response.message;
        _logger.debug('Add to favorites failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Add to favorites dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Add to favorites unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<bool, Failure>> removeFromFavorites(int movieId) async {
    try {
      _logger.debug('Removing movie from favorites - id: $movieId');

      final response = await _apiService.removeFromFavorites(movieId);

      if (response.isSuccess) {
        _logger.debug('Movie removed from favorites successfully');
        return Result.ok(true);
      } else {
        final message = response.response.message;
        _logger.debug('Remove from favorites failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Remove from favorites dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error(
          'Remove from favorites unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<bool, Failure>> addToWatchLater(int movieId) async {
    try {
      _logger.debug('Adding movie to watch later - id: $movieId');

      final response = await _apiService.addToWatchLater(movieId);

      if (response.isSuccess) {
        _logger.debug('Movie added to watch later successfully');
        return Result.ok(true);
      } else {
        final message = response.response.message;
        _logger.debug('Add to watch later failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Add to watch later dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error(
          'Add to watch later unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<bool, Failure>> removeFromWatchLater(int movieId) async {
    try {
      _logger.debug('Removing movie from watch later - id: $movieId');

      final response = await _apiService.removeFromWatchLater(movieId);

      if (response.isSuccess) {
        _logger.debug('Movie removed from watch later successfully');
        return Result.ok(true);
      } else {
        final message = response.response.message;
        _logger.debug('Remove from watch later failed: $message');
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Remove from watch later dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error(
          'Remove from watch later unexpected error', e, StackTrace.current);
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
        final message = error.response?.data?['message'] ?? 'Server error';

        switch (statusCode) {
          case 400:
            return ValidationFailure(message);
          case 401:
            return AuthFailure(message: 'Authentication failed');
          case 403:
            return AuthFailure(message: 'Access denied');
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
