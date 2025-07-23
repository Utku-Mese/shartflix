import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User, Failure>> login({
    required String email,
    required String password,
  });

  Future<Result<User, Failure>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<Result<bool, Failure>> forgotPassword({
    required String email,
  });

  Future<Result<User, Failure>> getProfile();

  Future<Result<bool, Failure>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Result<String, Failure>> uploadProfilePhoto({
    required MultipartFile photo,
  });

  Future<Result<void, Failure>> logout();

  Future<bool> isLoggedIn();

  Future<User?> getCurrentUser();
}
