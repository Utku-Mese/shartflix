import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UploadPhotoUseCase {
  final ProfileRepository _repository;

  const UploadPhotoUseCase(this._repository);

  Future<Result<Profile, Failure>> call(File photo) async {
    return await _repository.uploadPhoto(photo);
  }
}
