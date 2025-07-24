import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

@injectable
class AddToFavoritesUseCase {
  final MovieRepository _movieRepository;

  AddToFavoritesUseCase(this._movieRepository);

  Future<Result<bool, String>> call(int movieId) async {
    final result = await _movieRepository.addToFavorites(movieId);
    return result.mapErr((failure) => failure.message);
  }
}

@injectable
class RemoveFromFavoritesUseCase {
  final MovieRepository _movieRepository;

  RemoveFromFavoritesUseCase(this._movieRepository);

  Future<Result<bool, String>> call(int movieId) async {
    final result = await _movieRepository.removeFromFavorites(movieId);
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
