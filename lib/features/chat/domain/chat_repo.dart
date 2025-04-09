import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:dio/dio.dart';

class ChatRepo {
  ChatRepo._();
  static ChatRepo instant = ChatRepo._();

  Future sendMessage({
    required String content,
    required List<String> files,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> assistant,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'Content-Type': 'application/json',
      };

      final response = await DioNetwork.instant.dio.post(
        '/ai-chat/messages',
        data: {
          'content': content,
          'files': null,
          'metadata': metadata,
          'assistant': assistant,
        },
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