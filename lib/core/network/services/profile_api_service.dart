import 'package:dio/dio.dart';
import '../api_response.dart';
import '../../constants/api_constants.dart';
import '../../../features/movies/data/models/movie_model.dart';
import '../../../features/profile/data/models/profile_model.dart';

class ProfileApiService {
  final Dio _dio;

  ProfileApiService(this._dio);

  Future<ApiResponse<ProfileModel>> getProfile() async {
    final response = await _dio.get(ApiConstants.profile);
    return ApiResponse.fromJson(
      response.data,
      (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<MovieModel>>> getFavoriteMovies() async {
    final response = await _dio.get(ApiConstants.favorites);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List)
          .map((movieJson) =>
              MovieModel.fromJson(movieJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
