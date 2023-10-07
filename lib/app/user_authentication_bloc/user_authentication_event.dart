part of 'user_authentication_bloc.dart';

sealed class UserAuthenticationEvent extends Equatable {
  const UserAuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class _AuthenticationStatusChanged extends UserAuthenticationEvent {
  const _AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

final class LogoutRequested extends UserAuthenticationEvent {}
