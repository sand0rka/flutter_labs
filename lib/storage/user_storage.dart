import 'dart:convert';

import 'package:mobile/models/user.dart';
import 'package:mobile/storage/i_user_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage implements IUserStorage {
  static const _userKey = 'users';
  static const _isLoggedInKey = 'is_logged_in';
  static const _loggedUserIdKey = 'logged_user_id';

  static User? loggedUser;

  @override
  Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    users.add(user);
    loggedUser = user;

    await prefs.setString(
      _userKey, jsonEncode(users.map((e) => e.toJSON()).toList()),);
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_loggedUserIdKey, user.id);
  }

  @override
  Future<User?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getUser(email, password);
    if (user != null) {
      loggedUser = user;
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_loggedUserIdKey, user.id);
    }
    return loggedUser;
  }

  @override
  Future<User?> getUser(String email, String password) async {
    final users = await getUsers();
    try {
      final user = users.firstWhere(
            (user) => (user.password == password && user.email == email),
      );
      loggedUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();

    final newUserList = users
        .map(
          (oldUser) => user.id == oldUser.id ? user : oldUser,
    )
        .toList();

    await prefs.setString(
      _userKey, jsonEncode(newUserList.map((e) => e.toJSON()).toList()),);
  }

  @override
  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => User.fromJSON(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getUsers();
    final updated = list.where((e) => e.id != loggedUser?.id).toList();
    await prefs.setString(
      _userKey, jsonEncode(updated.map((e) => e.toJSON()).toList()),);
  }

  @override
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    loggedUser = null;
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_loggedUserIdKey);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<bool> restoreLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = await isUserLoggedIn();
    final userId = prefs.getString(_loggedUserIdKey);

    if (loggedIn && userId != null) {
      final users = await getUsers();
      final matchingUsers = users.where((u) => u.id == userId).toList();
      if (matchingUsers.isNotEmpty) {
        loggedUser = matchingUsers.first;
        return true;
      }
    }
    return false;
  }
}
