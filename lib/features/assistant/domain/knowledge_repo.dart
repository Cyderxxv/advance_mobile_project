import 'dart:ffi';
import 'dart:io';
import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:dio/dio.dart';

class KnowledgeRepo {
  KnowledgeRepo._();
  static KnowledgeRepo instant = KnowledgeRepo._();

  Future getKnowledges({
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
        '/knowledge',
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

  Future createKnowledge({
    required String knowledgeName,
    String? description,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final data = {  
        'knowledgeName': knowledgeName,
        if (description != null) 'description': description,
    };

      final response = await DioNetwork.instant.dio.post(
        '/knowledge',
        data: data,
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
  
      rethrow;
    }
  }

  Future updateKnowledge({
    required String id,
    required String knowledgeName,
    String? description,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final data = {
        'knowledgeName': knowledgeName,
        if (description != null) 'description': description,
      };

      final response = await DioNetwork.instant.dio.patch(
        '/knowledge/$id',
        data: data,
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteKnowledge({
    required String id,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.delete(
        '/knowledge/$id',
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future importFilesToKB({
    required File file,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });

      final response = await DioNetwork.instant.dio.post(
        '/knowledge/files',
        data: formData,
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      rethrow;

    }
  }
}