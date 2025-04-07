import 'package:mobile/models/user.dart';

abstract class IUserStorage {
  Future<void> registerUser(User user);
  Future<User?> login(String email, String password);
  Future<User?> getUser(String email, String password);
  Future<void> updateUser(User user);
  Future<List<User>> getUsers();
  Future<void> deleteUser();
  Future<void> logoutUser();
  Future<bool> isUserLoggedIn();
}
