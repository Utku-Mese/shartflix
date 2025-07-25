import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/profile.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class ProfileRepository {
  Future<Result<Profile, Failure>> getProfile();
  Future<Result<List<Movie>, Failure>> getFavoriteMovies();
  Future<Result<Profile, Failure>> uploadPhoto(File photo);
}
