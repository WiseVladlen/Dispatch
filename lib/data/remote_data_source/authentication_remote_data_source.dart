import 'package:dispatch/data/dto/user_dto.dart';
import 'package:dispatch/data/http_service/dio_service.dart';
import 'package:dispatch/data/mapper/user_mapper.dart';
import 'package:dispatch/domain/model/authentication_data_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/utils/http_utils.dart';

class AuthenticationRemoteDataSource {
  /// Creates a user according to the registration [model] parameter.
  ///
  /// Returns error ? if the user's [email] is not unique.
  ///
  /// Returns the created user if successful.
  Future<UserModel> signUp({required RegistrationDataModel model}) async {
    final uri = DioService.buildUri(path: 'auth/register');
    final response = await DioService.dio.postUri(uri, data: model.toJson());
    return UserDTO.fromJson(response.data).toUserModel();
  }

  /// Authorizes the user according to the login [model] parameter.
  ///
  /// Returns an error ? if the user's [email] is incorrect.
  ///
  /// Returns an error ? if the user's [password] is incorrect.
  ///
  /// Returns the created user and accessToken if successful.
  Future<AuthenticatedUserModel> logIn({required LoginDataModel model}) async {
    final uri = DioService.buildUri(path: 'auth/login');
    final response = await DioService.dio.postUri(uri, data: model.toJson());
    await saveCookieFromResponse(uri, response);
    return AuthenticatedUserDTO.fromJson(response.data).toAuthenticatedUserModel();
  }

  /// Updates access and refresh token.
  ///
  /// Returns a new access token.
  Future<String> refreshTokens() async {
    final uri = DioService.buildUri(path: 'auth/refresh');
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().getUri(uri);
    await saveCookieFromResponse(uri, response);
    return response.data.toString();
  }
}
