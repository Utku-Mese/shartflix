import 'package:injectable/injectable.dart';
import '../network/api_client.dart';
import '../network/services/auth_api_service.dart';
import '../network/services/movie_api_service.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  AuthApiService authApiService(ApiClient apiClient) => 
      AuthApiService(apiClient.dio);

  @lazySingleton
  MovieApiService movieApiService(ApiClient apiClient) => 
      MovieApiService(apiClient.dio);
}
