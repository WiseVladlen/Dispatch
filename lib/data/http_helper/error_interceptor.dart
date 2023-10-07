import 'package:dio/dio.dart';
import 'package:dispatch/data/http_helper/authentication_error_handler.dart';
import 'package:dispatch/data/http_service/dio_service.dart';

typedef ResponseErrorHandler = Function(String, String);

class ErrorInterceptor extends Interceptor {
  const ErrorInterceptor({
    required this.onResponseErrorHandler,
    required this.authenticationErrorHandler,
  });

  final ResponseErrorHandler onResponseErrorHandler;
  final AuthenticationErrorHandler authenticationErrorHandler;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403) {
      try {
        // await authenticationErrorHandler.refreshTokens();
        final response = await DioService.dio.fetch(err.requestOptions);
        handler.resolve(response);
      } on DioException catch (e) {
        handler.reject(e);
      }
    } else {
      onResponseErrorHandler(
        err.response?.statusMessage ?? 'Unknown error',
        err.message ?? 'An unknown error occurred during the operation of the application',
      );
      handler.next(err);
    }
  }
}
