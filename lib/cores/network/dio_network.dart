import 'dart:io';

import 'package:chatbot_ai/cores/network/repuest_network.dart';
import 'package:chatbot_ai/cores/store/store.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioNetwork {
  DioNetwork._();
  static DioNetwork instant = DioNetwork._();
  late BaseOptions _options;
  late String url;
  late Dio dio;

  bool loggingInterceptorEnabled = true;

  Future init(String url, {BaseOptions? options, bool isAuth = false}) async {
    _options = options ??
        BaseOptions(
          baseUrl: url,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          responseType: ResponseType.json,
        );
    if (isAuth == true) {
      _options.headers['Authorization'] = 'Bearer ${StoreData.instant.token}';
    } else {
      _options.headers.remove('Authorization');
    }
    _options.headers.remove(Headers.contentLengthHeader);
    dio = Dio(_options);
    // ignore: deprecated_member_use
    if (!kIsWeb) {
      // ignore: deprecated_member_use
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio.interceptors.addAll([
      RequestNetwork(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }
}
