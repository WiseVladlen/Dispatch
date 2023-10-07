import 'dart:async';

import 'package:dispatch/app/user_authentication_bloc/user_authentication_state.dart';
import 'package:dispatch/domain/model/authentication_data_model.dart';

abstract interface class IAuthenticationRepository {
  abstract final Stream<AuthenticationStatus> statusStream;

  Future<void> signUp({required RegistrationDataModel model});
  Future<void> logIn({required LoginDataModel model});
  Future<void> logOut();

  Future<void> refreshTokens();
}
