import 'dart:async';

import 'package:dispatch/app/user_authentication_bloc/user_authentication_state.dart';
import 'package:dispatch/data/cache_storage.dart';
import 'package:dispatch/data/local_data_source/user_local_data_source.dart';
import 'package:dispatch/data/remote_data_source/authentication_remote_data_source.dart';
import 'package:dispatch/domain/model/authentication_data_model.dart';
import 'package:dispatch/domain/repository/authentication_repository.dart';
import 'package:dispatch/utils/http_utils.dart';
import 'package:dispatch/utils/object_utils.dart';

class AuthenticationRepository implements IAuthenticationRepository {
  final _statusStreamController = StreamController<AuthenticationStatus>();

  AuthenticationRepository({
    required this.userLocalDataSource,
    required this.authenticationRemoteDataSource,
  });

  final UserLocalDataSource userLocalDataSource;
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;

  @override
  Stream<AuthenticationStatus> get statusStream async* {
    yield* _statusStreamController.stream;
  }

  @override
  Future<void> signUp({required RegistrationDataModel model}) async {
    await authenticationRemoteDataSource.signUp(model: model);
    await logIn(model: LoginDataModel(email: model.email, password: model.password));
  }

  @override
  Future<void> logIn({required LoginDataModel model}) async {
    final authenticatedUser = await authenticationRemoteDataSource.logIn(model: model);

    CacheStorage()
      ..writeUser(authenticatedUser.user)
      ..writeAccessToken(authenticatedUser.accessToken);

    await userLocalDataSource.upsertAuthenticatedUser(authenticatedUser);

    _statusStreamController.sink.add(AuthenticationStatus.authenticated);
  }

  @override
  Future<void> logOut() async {
    CacheStorage().readUser().safeLet((user) async {
      await userLocalDataSource.removeAccessToken(user.email);
      CacheStorage()
        ..writeUser(null)
        ..writeAccessToken(null);
    });

    deleteCookies();

    _statusStreamController.sink.add(AuthenticationStatus.unauthenticated);
  }

  @override
  Future<void> refreshTokens() async {
    final accessToken = await authenticationRemoteDataSource.refreshTokens();
    CacheStorage().readUser().safeLet((user) async {
      await userLocalDataSource.updateAccessToken(user.email, accessToken);
      CacheStorage().writeAccessToken(accessToken);
    });
  }
}
