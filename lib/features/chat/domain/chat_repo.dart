import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:dio/dio.dart';

class ChatRepo {
  ChatRepo._();
  static ChatRepo instant = ChatRepo._();

  Future<Map<String, dynamic>> sendMessage({
    required String content,
    required List<String> files,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> assistant,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'Content-Type': 'application/json',
        'X-Stack-Access-Type': 'client',
        'X-Stack-Project-Id': AppConstants.projectId,
        'X-Stack-Publishable-Client-Key': AppConstants.clientKey,
      };

      final response = await Dio().post(
        '/ai-chat/messages',
        data: {
          'content': content,
          'files': files,
          'metadata': metadata,
          'assistant': assistant,
        },
        options: Options(headers: headers),
      );

      if (response.data != null) {
        return response.data;
      }
      throw Exception('No response received from the server');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data ?? e.message ?? 'An error occurred');
      }
      throw Exception(e.toString());
    }
  }
}