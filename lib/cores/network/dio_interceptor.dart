import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:chatbot_ai/cores/store/store.dart';
import 'package:chatbot_ai/features/splash/pages/welcome.dart';
import 'package:chatbot_ai/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioInterceptor extends Interceptor{


  @override
  Future<dynamic> onError(DioException err, ErrorInterceptorHandler handler) async {
  
    // if (err.response?.statusCode == 401 && err.requestOptions.uri.path.contains("refresh-token") == false) {
    if (err.response?.statusCode == 401) {
      try {
        if (StoreData.instant.refreshToken.isNotEmpty == true) {
          final tokenTemp = StoreData.instant.refreshToken;
      await StoreData.instant.setToken("");
      await StoreData.instant.setRefreshToken("");
      DioNetwork.instant.init(AppConstants.authBaseUrl);
      DioNetwork.instant.dio.options.headers.addAll({
        'X-Stack-Access-Type': 'client',
        'X-Stack-Project-Id': AppConstants.projectId,
        'X-Stack-Publishable-Client-Key': AppConstants.clientKey,
        'X-Stack-Refresh-Token': tokenTemp, 
      });

      final response = await DioNetwork.instant.dio.get(
        "/auth/sessions/current/refresh",
      );
          if (response.statusCode == 200 || response.statusCode == 201) {
            await StoreData.instant.setToken(response.data['access_token']);
            err.requestOptions.headers['Authorization'] = "Bearer ${StoreData.instant.token}";
            final opts = Options(method: err.requestOptions.method, headers: err.requestOptions.headers);
            final cloneReq = await DioNetwork.instant.dio
                .request(err.requestOptions.path, options: opts, data: err.requestOptions.data, queryParameters: err.requestOptions.queryParameters);
            return handler.resolve(cloneReq);
          }
        } else {
              await StoreData.instant.removeAllCache();
              if (navigatorKey.currentContext != null) {
                Navigator.of(navigatorKey.currentContext!).pushReplacement(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                );
              }           
              return handler.reject(err);
        }
      } catch (e) {

        rethrow;
      }
    } 
}
}