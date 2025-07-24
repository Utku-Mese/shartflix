import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<Result<User, String>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validation
    if (firstName.isEmpty) {
      return Result.err('Ad boş olamaz');
    }
    if (lastName.isEmpty) {
      return Result.err('Soyad boş olamaz');
    }
    if (email.isEmpty) {
      return Result.err('E-posta adresi boş olamaz');
    }
    if (password.isEmpty) {
      return Result.err('Şifre boş olamaz');
    }
    if (confirmPassword.isEmpty) {
      return Result.err('Şifre tekrar boş olamaz');
    }
    if (!_isValidEmail(email)) {
      return Result.err('Geçerli bir e-posta adresi giriniz');
    }
    if (password.length < 6) {
      return Result.err('Şifre en az 6 karakter olmalıdır');
    }
    if (password != confirmPassword) {
      return Result.err('Şifreler eşleşmiyor');
    }

    final result = await _authRepository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    return result.mapErr((failure) => failure.message);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
