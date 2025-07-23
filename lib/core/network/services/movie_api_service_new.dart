import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../api_response.dart';
import '../../../features/movies/data/models/movie_model.dart';
import '../../../features/movies/data/models/movie_responses.dart';
import '../../constants/api_constants.dart';

@injectable
class MovieApiService {
  final Dio _dio;

  MovieApiService(this._dio);

  Future<ApiResponse<MovieListData>> getMovies({
    int page = 1,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      ApiConstants.page: page,
    };

    if (search != null && search.isNotEmpty) {
      queryParams[ApiConstants.search] = search;
    }

    final response = await _dio.get(
      ApiConstants.movies,
      queryParameters: queryParams,
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => MovieListData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<MovieListData>> getFeaturedMovies() async {
    final response = await _dio.get(ApiConstants.featured);
    return ApiResponse.fromJson(
      response.data,
      (json) => MovieListData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<MovieListData>> getTrendingMovies() async {
    final response = await _dio.get(ApiConstants.trending);
    return ApiResponse.fromJson(
      response.data,
      (json) => MovieListData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<MovieModel>> getMovieDetail(int movieId) async {
    final response = await _dio.get(ApiConstants.movieDetail(movieId));
    return ApiResponse.fromJson(
      response.data,
      (json) => MovieModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<MovieListData>> getFavoriteMovies({
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiConstants.favorites,
      queryParameters: {ApiConstants.page: page},
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => MovieListData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<MovieListData>> getWatchLaterMovies({
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiConstants.watchLater,
      queryParameters: {ApiConstants.page: page},
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => MovieListData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<FavoriteActionData>> addToFavorites(int movieId) async {
    final response = await _dio.post(ApiConstants.addToFavorites(movieId));
    return ApiResponse.fromJson(
      response.data,
      (json) => FavoriteActionData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<FavoriteActionData>> removeFromFavorites(
      int movieId) async {
    final response = await _dio.post(ApiConstants.removeFromFavorites(movieId));
    return ApiResponse.fromJson(
      response.data,
      (json) => FavoriteActionData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<FavoriteActionData>> addToWatchLater(int movieId) async {
    final response = await _dio.post(ApiConstants.addToWatchLater(movieId));
    return ApiResponse.fromJson(
      response.data,
      (json) => FavoriteActionData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<FavoriteActionData>> removeFromWatchLater(
      int movieId) async {
    final response =
        await _dio.post(ApiConstants.removeFromWatchLater(movieId));
    return ApiResponse.fromJson(
      response.data,
      (json) => FavoriteActionData.fromJson(json as Map<String, dynamic>),
    );
  }
}
