class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://nodelabs.flutter.com.tr/api';
  static const String baseImageUrl = 'https://nodelabs.flutter.com.tr';

  // Headers
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String contentType = 'application/json';

  // Auth endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/password/forgot';
  static const String uploadPhoto = '/upload/profile/photo';

  // User endpoints
  static const String profile = '/profile';
  static const String changePassword = '/profile/change-password';

  // Movie endpoints
  static const String movies = '/movies';
  static const String featured = '/movies/featured';
  static const String trending = '/movies/trending';
  static const String favorites = '/favorites';
  static const String watchLater = '/watch-later';

  // Movie detail endpoints
  static String movieDetail(int movieId) => '/movies/$movieId';
  static String addToFavorites(int movieId) => '/movies/$movieId/favorite';
  static String removeFromFavorites(int movieId) =>
      '/movies/$movieId/unfavorite';
  static String toggleFavorite(int movieId) =>
      '/movies/$movieId/toggle-favorite';
  static String addToWatchLater(int movieId) => '/movies/$movieId/watch-later';
  static String removeFromWatchLater(int movieId) =>
      '/movies/$movieId/remove-watch-later';

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
  static const int defaultPerPage = 10;
  static const int defaultTimeout = 30;
}
