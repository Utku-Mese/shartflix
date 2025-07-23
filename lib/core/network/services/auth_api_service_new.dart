import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../api_response.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/data/models/auth_requests.dart';
import '../../constants/api_constants.dart';

@injectable
class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<ApiResponse<UserModel>> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<UserModel>> register(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<dynamic>> forgotPassword(
      Map<String, dynamic> request) async {
    final response = await _dio.post(
      ApiConstants.forgotPassword,
      data: request,
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => json,
    );
  }

  Future<ApiResponse<UserModel>> getProfile() async {
    final response = await _dio.get(ApiConstants.profile);
    return ApiResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<dynamic>> changePassword(
      Map<String, dynamic> request) async {
    final response = await _dio.post(
      ApiConstants.changePassword,
      data: request,
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => json,
    );
  }

  Future<ApiResponse<UploadPhotoResponse>> uploadProfilePhoto(
      FormData formData) async {
    final response = await _dio.post(
      ApiConstants.uploadPhoto,
      data: formData,
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => UploadPhotoResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
