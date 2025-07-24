import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

@injectable
class GetMoviesUseCase {
  final MovieRepository _movieRepository;

  GetMoviesUseCase(this._movieRepository);

  Future<Result<List<Movie>, String>> call({
    int page = 1,
    String? search,
  }) async {
    final result = await _movieRepository.getMovies(
      page: page,
      search: search,
    );
    return result.mapErr((failure) => failure.message);
  }
}
