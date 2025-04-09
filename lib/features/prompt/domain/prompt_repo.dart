import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:dio/dio.dart';

class PromptRepo {
  PromptRepo._();
  static PromptRepo instant = PromptRepo._();

  Future getPrompt({
    required int limit,
    required int offset,
    required String query,
    required List<String> categories,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.get(
        '/api/v1/prompts',
        queryParameters: {
          'query': query,
          'offset': 0,
          'limit': 10,
          'category': categories,
          'isFavorite': false,
          'isPublic': false,
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