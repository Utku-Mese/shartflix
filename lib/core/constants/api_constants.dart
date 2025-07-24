class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://caseapi.servicelabs.tech';

  // Headers
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String contentType = 'application/json';

  // Auth endpoints
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String uploadPhoto = '/user/upload_photo';
  static const String profile = '/user/profile';

  // Movie endpoints
  static const String movies = '/movie/list';
  static const String favorites = '/movie/favorites';
  static String addToFavorites(int favoriteId) => '/movie/favorite/$favoriteId';

  // Query parameters
  static const String page = 'page';
  static const String search = 'search';
  static const String perPage = 'perPage';

  // Error codes
  static const String unauthorized = '401';
  static const String forbidden = '403';
  static const String notFound = '404';
  static const String serverError = '500';

  // Default values
  static const int defaultPerPage = 5;
  static const int defaultTimeout = 30;
}
