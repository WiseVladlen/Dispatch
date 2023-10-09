import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dispatch/data/cache_storage.dart';
import 'package:dispatch/data/http_service/dio_service.dart';
import 'package:dispatch/utils/object_utils.dart';
import 'package:path_provider/path_provider.dart';

class HttpHeaders {
  static const authorizationHeader = 'Authorization';
  static const setCookieHeader = 'Set-Cookie';

  static Map<String, String> get baseHttpHeaders {
    return {authorizationHeader: CacheStorage().readAccessToken() ?? ''};
  }
}

Future<void> saveCookieFromResponse(Uri uri, Response<dynamic> response) async {
  await response.headers[HttpHeaders.setCookieHeader].safeLet((cookies) async {
    await DioService.cookieJar.saveFromResponse(
      uri,
      cookies.map((e) => Cookie.fromSetCookieValue(e)).toList(),
    );
  });
}

Future<void> deleteCookies() => DioService.cookieJar.deleteAll();

Future<void> prepareCookieJar() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final cookieJar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage('${appDocDir.path}/.cookies/'),
  );

  DioService.addInterceptor(CookieManager(cookieJar));
}

bool isNetworkImage(String path) {
  return Uri.parse(path).let((uri) => uri.scheme == 'http' || uri.scheme == 'https');
}
