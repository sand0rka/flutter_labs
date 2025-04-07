import 'package:mobile/storage/user_storage.dart';

class RegistrationValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (RegExp(r'\d').hasMatch(value)) {
      return 'Name should not contain numbers';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Email must contain @';
    }
    return null;
  }

  static Future<String?> validateEmailExists(String email) async {
    final users = await UserStorage().getUsers();
    final exists =
        users.any((user) => user.email.toLowerCase() == email.toLowerCase());
    if (exists) return 'Email is already registered';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
