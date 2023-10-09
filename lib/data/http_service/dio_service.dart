import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dispatch/utils/http_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static const scheme = 'http';
  static const host = '172.30.54.112';
  static const port = 8080;

  static Uri buildUri({
    String? path,
    Map<String, dynamic>? queryParameters,
  }) {
    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: path,
      queryParameters: queryParameters,
    );
  }

  static void addInterceptor(Interceptor interceptor) => dio.interceptors.add(interceptor);

  static CookieJar get cookieJar => dio.interceptors.whereType<CookieManager>().first.cookieJar;

  static final dio = Dio()
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    );
}

extension DioExtension on Dio {
  Dio setHeaders() => this..options.headers = HttpHeaders.baseHttpHeaders;
}
