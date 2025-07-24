import 'package:dio/dio.dart';
import '../api_response.dart';
import '../../../features/movies/data/models/movie_responses.dart';
import '../../constants/api_constants.dart';

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

  Future<ApiResponse<FavoriteActionData>> toggleFavorite(int favoriteId) async {
    final response = await _dio.post(ApiConstants.addToFavorites(favoriteId));
    return ApiResponse.fromJson(
      response.data,
      (json) => FavoriteActionData.fromJson(json as Map<String, dynamic>),
    );
  }
}
