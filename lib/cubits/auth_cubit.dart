import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/storage/user_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserStorage _storage;

  AuthCubit(this._storage) : super(AuthInitial());

  Future<void> checkAuth(BuildContext context) async {
    final restored = await _storage.restoreLoggedUser();

    if (restored && UserStorage.loggedUser != null) {
      emit(AuthAuthenticated(UserStorage.loggedUser!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    final user = await _storage.login(email, password);
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthError('Invalid email or password'));
    }
  }

  Future<void> register(User user) async {
    await _storage.registerUser(user);
    emit(AuthAuthenticated(user));
  }

  Future<void> logout() async {
    await _storage.logoutUser();
    emit(AuthUnauthenticated());
  }
}
