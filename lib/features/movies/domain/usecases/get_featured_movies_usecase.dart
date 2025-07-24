import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

@injectable
class GetFeaturedMoviesUseCase {
  final MovieRepository _movieRepository;

  GetFeaturedMoviesUseCase(this._movieRepository);

  Future<Result<List<Movie>, String>> call() async {
    final result = await _movieRepository.getFeaturedMovies();
    return result.mapErr((failure) => failure.message);
  }
}
