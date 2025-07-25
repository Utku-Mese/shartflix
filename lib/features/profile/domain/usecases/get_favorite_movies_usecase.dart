import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetFavoriteMoviesUseCase {
  final ProfileRepository _repository;

  GetFavoriteMoviesUseCase(this._repository);

  Future<Result<List<Movie>, Failure>> call() async {
    return await _repository.getFavoriteMovies();
  }
}
