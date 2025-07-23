import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../api_response.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/data/models/auth_requests.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST('/login')
  Future<ApiResponse<UserModel>> login(@Body() LoginRequest request);

  @POST('/register')
  Future<ApiResponse<UserModel>> register(@Body() RegisterRequest request);

  @POST('/password/forgot')
  Future<ApiResponse<dynamic>> forgotPassword(@Body() Map<String, dynamic> request);

  @GET('/profile')
  Future<ApiResponse<UserModel>> getProfile();

  @POST('/profile/change-password')
  Future<ApiResponse<dynamic>> changePassword(@Body() Map<String, dynamic> request);

  @POST('/upload/profile/photo')
  Future<ApiResponse<UploadPhotoResponse>> uploadProfilePhoto(@Body() FormData formData);
}
