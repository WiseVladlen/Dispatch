import 'package:dispatch/data/cache_storage.dart';
import 'package:dispatch/data/dto/user_dto.dart';
import 'package:dispatch/data/http_service/dio_service.dart';
import 'package:dispatch/data/local_data_source/user_local_data_source.dart';
import 'package:dispatch/utils/http_utils.dart';
import 'package:dispatch/utils/object_utils.dart';

class AuthenticationErrorHandler {
  const AuthenticationErrorHandler({required this.userLocalDataSource});

  final UserLocalDataSource userLocalDataSource;

  /// Updates access and refresh token.
  Future<void> refreshTokens() async {
    final uri = DioService.buildUri(path: 'auth/refresh');

    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.getUri(uri);
    await saveCookieFromResponse(uri, response);

    final authenticatedUser = AuthenticatedUserDTO.fromJson(response.data);

    CacheStorage().readUser().safeLet((user) async {
      await userLocalDataSource.updateAccessToken(user.email, authenticatedUser.accessToken);
      CacheStorage().writeAccessToken(authenticatedUser.accessToken);
    });
  }
}
