import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Result<List<Movie>, Failure>> getMovies({
    int page = 1,
    String? search,
  });

  Future<Result<List<Movie>, Failure>> getFavoriteMovies({
    int page = 1,
  });

  Future<Result<bool, Failure>> toggleFavorite(String movieId);
}
