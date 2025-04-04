import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:chatbot_ai/cores/store/store.dart';
import 'package:chatbot_ai/features/auth/data/input_login_model.dart';
import 'package:chatbot_ai/features/auth/data/input_register_model.dart';
import 'package:dio/dio.dart';
import '../../../cores/constants/app_constants.dart';

class AuthRepo {
  AuthRepo._();
  static AuthRepo instant = AuthRepo._();
  Future signUp({required InputRegisterModel data}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'X-Stack-Access-Type': 'client',
        'X-Stack-Project-Id': AppConstants.projectId,
        'X-Stack-Publishable-Client-Key': AppConstants.clientKey,
      };

      DioNetwork.instant.init(AppConstants.authBaseUrl);
      final response = await DioNetwork.instant.dio.post(
          "/auth/password/sign-up",
          data: data.toJson(),
          options: Options(headers: headers));
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }

   Future signIn({
    required InputLoginModel data,
    }) async {
    try {
      DioNetwork.instant.init(AppConstants.authBaseUrl);
      final headers = {
        'Content-Type': 'application/json',
        'X-Stack-Access-Type': 'client',
        'X-Stack-Project-Id': AppConstants.projectId,
        'X-Stack-Publishable-Client-Key': AppConstants.clientKey,
      };
      final response = await DioNetwork.instant.dio.post(
          "/auth/password/sign-in",
          data: data.toJson(),
          options: Options(headers: headers));
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }

  Future logout() async {
    try {
      DioNetwork.instant.init(AppConstants.authBaseUrl, isAuth: true);
      final headers = {
        'Content-Type': 'application/json',
        'X-Stack-Access-Type': 'client',
        'X-Stack-Project-Id': AppConstants.projectId,
        'X-Stack-Publishable-Client-Key': AppConstants.clientKey,
        'X-Stack-Refresh-Token': StoreData.instant.refreshToken,
      };
      final response = await DioNetwork.instant.dio.delete(
          "/auth/sessions/current",
          options: Options(headers: headers));
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }
}
