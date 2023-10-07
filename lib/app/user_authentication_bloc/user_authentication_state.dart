import 'package:dispatch/domain/model/user_model.dart';
import 'package:equatable/equatable.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated;

  bool get isAuthenticated => this == authenticated;
}

final class UserAuthenticationState extends Equatable {
  const UserAuthenticationState._internal({
    this.user,
    this.status = AuthenticationStatus.unauthenticated,
  });

  final UserModel? user;
  final AuthenticationStatus status;

  const UserAuthenticationState.unauthenticated() : this._internal();

  const UserAuthenticationState.authenticated(UserModel user)
      : this._internal(
          user: user,
          status: AuthenticationStatus.authenticated,
        );

  @override
  List<Object?> get props => [user, status];
}
