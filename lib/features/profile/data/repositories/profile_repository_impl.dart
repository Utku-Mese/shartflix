import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/services/profile_api_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/utils/result.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService _apiService;
  final LoggerService _logger;

  const ProfileRepositoryImpl(
    this._apiService,
    this._logger,
  );

  @override
  Future<Result<Profile, Failure>> getProfile() async {
    try {
      _logger.debug('Fetching user profile');
      final response = await _apiService.getProfile();

      if (response.isSuccess && response.data != null) {
        final profile = response.data!.toEntity();
        _logger.debug('Profile fetched successfully: ${profile.name}');
        return Result.ok(profile);
      } else {
        final message = response.response.message;
        _logger.error(
            'Failed to fetch profile: $message', null, StackTrace.current);
        return Result.err(ServerFailure(message));
      }
    } on DioException catch (e) {
      _logger.error('Profile dio error', e, StackTrace.current);
      return Result.err(_handleDioError(e));
    } catch (e) {
      _logger.error('Profile unexpected error', e, StackTrace.current);
      return Result.err(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<List<Movie>, Failure>> getFavoriteMovies() async {
    try {
      _logger.debug('Fetching favorite movies');
      final response = await _apiService.getFavoriteMovies();

      if (response.isSuccess && response.data != null) {
        final movies =
            response.data!.map((movieModel) => movieModel.toEntity()).toList();
        _logger.debug(
            'Favorite movies fetched successfully: ${movies.length} movies');
        return Result.ok(movies);
      } else {
        final message = response.response.message;
        _logger.error('Failed to fetch favorite movies: $message', null,
            StackTrace.current);
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
  Future<Result<Profile, Failure>> uploadPhoto(File photo) async {
    try {
      _logger.debug('Uploading photo: ${photo.path}');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(photo.path),
      });

      final response = await _apiService.uploadPhoto(formData);

      if (response.isSuccess && response.data != null) {
        final profile = response.data!.toEntity();
        _logger.debug('Photo uploaded successfully: ${profile.photoUrl}');
        return Result.ok(profile);
      } else {
        final message = response.response.message;
        _logger.error(
            'Failed to upload photo: $message', null, StackTrace.current);
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

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return AuthFailure(message: 'Authentication required');
        } else if (statusCode == 403) {
          return AuthFailure(message: 'Access forbidden');
        } else if (statusCode == 404) {
          return ServerFailure('Resource not found');
        } else {
          return ServerFailure('Server error: $statusCode');
        }
      case DioExceptionType.cancel:
        return ServerFailure('Request cancelled');
      case DioExceptionType.connectionError:
        return ServerFailure('No internet connection');
      case DioExceptionType.badCertificate:
        return ServerFailure('Certificate error');
      case DioExceptionType.unknown:
        return ServerFailure('Unknown error occurred');
    }
  }
}
