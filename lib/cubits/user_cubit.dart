import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/storage/user_storage.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserStorage _storage;

  UserCubit({UserStorage? storage})
      : _storage = storage ?? UserStorage(),
        super(const UserState.initial()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = UserStorage.loggedUser;
    if (user != null) {
      emit(UserState.loaded(user));
      return;
    }
    emit(const UserState.error('User not found'));
  }

  Future<void> updateUser(User updatedUser) async {
    await _storage.updateUser(updatedUser);
    emit(UserState.loaded(updatedUser));
  }

  Future<void> deleteUser() async {
    await _storage.deleteUser();
    emit(const UserState.deleted());
  }
}
