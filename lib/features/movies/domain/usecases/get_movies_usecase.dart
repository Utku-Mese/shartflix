import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/services/firebase_service.dart';
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
    // Firebase Performance trace başlat
    final trace = FirebaseService.startTrace('get_movies_api_call');
    trace?.setMetric('page', page);
    if (search != null) {
      trace?.putAttribute('search_query', search);
      trace?.putAttribute('has_search', 'true');
    } else {
      trace?.putAttribute('has_search', 'false');
    }

    try {
      final result = await _movieRepository.getMovies(
        page: page,
        search: search,
      );

      // Success/failure metrics ekle
      result.fold(
        (movies) {
          trace?.setMetric('success', 1);
          trace?.setMetric('movies_count', movies.length);
          trace?.putAttribute('result', 'success');
        },
        (error) {
          trace?.setMetric('success', 0);
          trace?.putAttribute('result', 'error');
          trace?.putAttribute('error_message', error.message);
        },
      );

      return result.mapErr((failure) => failure.message);
    } finally {
      // Trace'i sonlandır
      trace?.stop();
    }
  }
}
