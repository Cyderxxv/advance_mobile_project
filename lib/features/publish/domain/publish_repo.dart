import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:dio/dio.dart';

class PublishRepo {
  PublishRepo._();
  static PublishRepo instant = PublishRepo._();

  Future publishTelegram({
    required String botToken,
    required String assistantId,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };
      final data = {
        'botToken': botToken,
      };

      final response = await DioNetwork.instant.dio.post(
        '/bot-integration/telegram/publish/$assistantId',
        data: data,
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
      rethrow;
    }
  }
}