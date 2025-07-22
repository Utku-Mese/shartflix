class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://caseapi.servicelabs.tech/api';

  // Auth endpoints
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String profile = '/user/profile';
  static const String uploadPhoto = '/user/upload_photo';

  // Movie endpoints
  static const String movieList = '/movie/list';
  static const String movieFavorites = '/movie/favorites';
  static const String movieFavorite = '/movie/favorite';

  // Pagination
  static const int defaultPageSize = 5;

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
