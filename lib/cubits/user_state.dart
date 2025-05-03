part of 'user_cubit.dart';

class UserState extends Equatable {
  final User? user;
  final bool isDeleted;
  final String? errorMessage;

  const UserState({
    this.user,
    this.isDeleted = false,
    this.errorMessage,
  });

  const UserState.initial()
      : user = null,
        isDeleted = false,
        errorMessage = null;

  const UserState.loaded(User this.user)
      : isDeleted = false,
        errorMessage = null;

  const UserState.deleted()
      : user = null,
        isDeleted = true,
        errorMessage = null;

  const UserState.error(String message)
      : user = null,
        isDeleted = false,
        errorMessage = message;

  @override
  List<Object?> get props => [user, isDeleted, errorMessage];
}
