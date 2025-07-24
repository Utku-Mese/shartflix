import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

@injectable
class ToggleFavoriteUseCase {
  final MovieRepository _movieRepository;

  ToggleFavoriteUseCase(this._movieRepository);

  Future<Result<bool, String>> call(int movieId) async {
    final result = await _movieRepository.toggleFavorite(movieId);
    return result.mapErr((failure) => failure.message);
  }
}
