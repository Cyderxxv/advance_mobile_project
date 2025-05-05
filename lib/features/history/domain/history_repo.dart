import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:dio/dio.dart';
import '../data/history_response_model.dart';

class HistoryRepo {
  HistoryRepo._();
  static HistoryRepo instant = HistoryRepo._();

  Future getConversations({
    String? cursor,
    int? limit,
    String? assistantId,
    required String assistantModel,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.get(
        '/ai-chat/conversations',
        queryParameters: {
          // if (cursor != null) 'cursor': cursor,
          // if (limit != null) 'limit': limit,
          // if (assistantId != null) 'assistantId': assistantId,
          'assistantModel': assistantModel,
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

  Future<HistoryResponseModel?> getConversationsHistory({
    required String conversationId,
    required String assistantModel,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.get(
        '/ai-chat/conversations/$conversationId/messages',
        queryParameters: {
          // if (cursor != null) 'cursor': cursor,
          // if (limit != null) 'limit': limit,
          // if (assistantId != null) 'assistantId': assistantId,
          'assistantModel': assistantModel,
        },
        options: Options(headers: headers),
      );

      if (response.data != null) {
        return HistoryResponseModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        return null;
      }
      rethrow;
    }
  }
}