import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

@injectable
class ToggleFavoriteUseCase {
  final MovieRepository _movieRepository;

  ToggleFavoriteUseCase(this._movieRepository);

  Future<Result<bool, String>> call(String movieId) async {
    final result = await _movieRepository.toggleFavorite(movieId);
    return result.mapErr((failure) => failure.message);
  }
}

@injectable
class GetFavoriteMoviesUseCase {
  final MovieRepository _movieRepository;

  GetFavoriteMoviesUseCase(this._movieRepository);

  Future<Result<List<Movie>, String>> call({int page = 1}) async {
    final result = await _movieRepository.getFavoriteMovies(page: page);
    return result.mapErr((failure) => failure.message);
  }
}

// Legacy alias for backward compatibility
@injectable
class AddToFavoritesUseCase extends ToggleFavoriteUseCase {
  AddToFavoritesUseCase(super.movieRepository);
}
