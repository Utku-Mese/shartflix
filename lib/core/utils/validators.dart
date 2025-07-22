class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email adresi gerekli';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Geçerli bir email adresi girin';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Şifre gerekli';
    }

    if (password.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }

    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'İsim gerekli';
    }

    if (name.length < 2) {
      return 'İsim en az 2 karakter olmalı';
    }

    if (name.length > 50) {
      return 'İsim en fazla 50 karakter olabilir';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName gerekli';
    }

    return null;
  }
}
