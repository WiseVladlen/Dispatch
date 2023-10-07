import 'dart:async';

import 'package:dispatch/app/user_authentication_bloc/user_authentication_state.dart';
import 'package:dispatch/data/cache_storage.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/domain/repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_authentication_event.dart';

class UserAuthenticationBloc extends Bloc<UserAuthenticationEvent, UserAuthenticationState> {
  late final StreamSubscription<AuthenticationStatus> _statusStreamSubscription;

  final IAuthenticationRepository authenticationRepository;

  UserAuthenticationBloc({required this.authenticationRepository}) : super(buildState) {
    on<_AuthenticationStatusChanged>(_onStatusChanged);
    on<LogoutRequested>(_onLogoutRequested);

    _statusStreamSubscription = authenticationRepository.statusStream.listen((status) {
      add(_AuthenticationStatusChanged(status));
    });
  }

  static UserAuthenticationState get buildState {
    return switch (CacheStorage().readUser()) {
      (UserModel user) => UserAuthenticationState.authenticated(user),
      (_) => const UserAuthenticationState.unauthenticated(),
    };
  }

  void _onStatusChanged(_AuthenticationStatusChanged event, Emitter<UserAuthenticationState> emit) {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        emit(const UserAuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        emit(buildState);
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<UserAuthenticationState> emit) {
    authenticationRepository.logOut();
  }

  @override
  Future<void> close() {
    _statusStreamSubscription.cancel();
    return super.close();
  }
}
