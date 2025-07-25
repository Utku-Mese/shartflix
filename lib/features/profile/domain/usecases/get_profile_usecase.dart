import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Result<Profile, Failure>> call() async {
    return await _repository.getProfile();
  }
}
