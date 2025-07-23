import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Result<List<Movie>, Failure>> getMovies({
    int page = 1,
    String? search,
  });

  Future<Result<List<Movie>, Failure>> getFeaturedMovies();

  Future<Result<List<Movie>, Failure>> getTrendingMovies();

  Future<Result<Movie, Failure>> getMovieDetail(int movieId);

  Future<Result<List<Movie>, Failure>> getFavoriteMovies({
    int page = 1,
  });

  Future<Result<List<Movie>, Failure>> getWatchLaterMovies({
    int page = 1,
  });

  Future<Result<bool, Failure>> addToFavorites(int movieId);

  Future<Result<bool, Failure>> removeFromFavorites(int movieId);

  Future<Result<bool, Failure>> addToWatchLater(int movieId);

  Future<Result<bool, Failure>> removeFromWatchLater(int movieId);
}
