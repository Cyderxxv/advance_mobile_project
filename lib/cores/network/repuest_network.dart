import 'package:dio/dio.dart';

class RequestNetwork extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }
}
