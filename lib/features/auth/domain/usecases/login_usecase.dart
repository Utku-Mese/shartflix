import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Result<User, String>> call(String email, String password) async {
    // Validation
    if (email.isEmpty) {
      return Result.err('E-posta adresi boş olamaz');
    }
    if (password.isEmpty) {
      return Result.err('Şifre boş olamaz');
    }
    if (!_isValidEmail(email)) {
      return Result.err('Geçerli bir e-posta adresi giriniz');
    }
    if (password.length < 6) {
      return Result.err('Şifre en az 6 karakter olmalıdır');
    }

    final result =
        await _authRepository.login(email: email, password: password);
    return result.mapErr((failure) => failure.message);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
