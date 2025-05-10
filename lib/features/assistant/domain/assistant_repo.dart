import 'dart:ffi';
import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:dio/dio.dart';

class AssistantRepo {
  AssistantRepo._();
  static AssistantRepo instant = AssistantRepo._();

  Future getAssistants({
    String? q,
    String? order,
    String? orderField,
    int? offset,
    int? limit,
    Bool? isFavorite,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.get(
        '/ai-assistant',
        // queryParameters: {
        //   'q': q,
        //   'order': order,
        //   'offset': offset,
        //   'limit': limit,
        // },
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

  Future createAssistants({
    required String assistantName,
    String? instructions,
    String? description,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final data = {  
        'assistantName': assistantName,
        if (instructions != null) 'instructions': instructions,
        if (description != null) 'description': description,
    };

      final response = await DioNetwork.instant.dio.post(
        '/ai-assistant',
        data: data,
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
  
      rethrow;
    }
  }
}