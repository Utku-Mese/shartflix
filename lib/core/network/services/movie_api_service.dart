import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../api_response.dart';
import '../../../features/movies/data/models/movie_model.dart';
import '../../../features/movies/data/models/movie_responses.dart';

part 'movie_api_service.g.dart';

@RestApi()
abstract class MovieApiService {
  factory MovieApiService(Dio dio, {String baseUrl}) = _MovieApiService;

  @GET('/movies')
  Future<ApiResponse<MovieListData>> getMovies({
    @Query('page') int page = 1,
    @Query('search') String? search,
  });

  @GET('/movies/featured')
  Future<ApiResponse<MovieListData>> getFeaturedMovies();

  @GET('/movies/trending')
  Future<ApiResponse<MovieListData>> getTrendingMovies();

  @GET('/movies/{movieId}')
  Future<ApiResponse<MovieModel>> getMovieDetail(@Path('movieId') int movieId);

  @GET('/favorites')
  Future<ApiResponse<MovieListData>> getFavoriteMovies({
    @Query('page') int page = 1,
  });

  @GET('/watch-later')
  Future<ApiResponse<MovieListData>> getWatchLaterMovies({
    @Query('page') int page = 1,
  });

  @POST('/movies/{movieId}/favorite')
  Future<ApiResponse<FavoriteActionData>> addToFavorites(
    @Path('movieId') int movieId,
  );

  @POST('/movies/{movieId}/unfavorite')
  Future<ApiResponse<FavoriteActionData>> removeFromFavorites(
    @Path('movieId') int movieId,
  );

  @POST('/movies/{movieId}/watch-later')
  Future<ApiResponse<FavoriteActionData>> addToWatchLater(
    @Path('movieId') int movieId,
  );

  @POST('/movies/{movieId}/remove-watch-later')
  Future<ApiResponse<FavoriteActionData>> removeFromWatchLater(
    @Path('movieId') int movieId,
  );
}
