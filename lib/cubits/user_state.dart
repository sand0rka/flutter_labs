part of 'user_cubit.dart';

class UserState extends Equatable {
  final User? user;
  final bool isDeleted;
  final String? errorMessage;

  const UserState._({
    this.user,
    this.isDeleted = false,
    this.errorMessage,
  });

  const UserState.initial() : this._();

  const UserState.loaded(User user) : this._(user: user);

  const UserState.deleted() : this._(isDeleted: true);

  const UserState.error(String message) : this._(errorMessage: message);

  bool get isLoading => this == const UserState.initial();

  bool get isLoaded => user != null;

  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [user, isDeleted, errorMessage];
}
