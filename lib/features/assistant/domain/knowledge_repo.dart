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

  Future uploadFiles({
    required List<File> files,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': 'a153d8df-ee7d-4ac3-943e-882726700f9b',
        'Content-Type': 'multipart/form-data',
      };

      final formData = FormData();
      for (var file in files) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(file.path),
          ),
        );
      }

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

  Future importKBFromConfluence ({
    required String name,
    required String wikiUrl,
    required String username,
    required String token,
    required String knowledgeId,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final data = {
        "datasources": [
          {
            "type": "confluence",
            "name": name,
            "credentials": {
              "url": wikiUrl,
              "username": username,
              "token": token,
            }
          }
        ]
      };

      final response = await DioNetwork.instant.dio.post(
        '/knowledge/$knowledgeId/datasources',
        data: data,
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDatasourceFromKnowledge({
    required String? q,
    required String? order,
    required String? orderField,
    required int? offset,
    required int? limit,
    required Bool? isFavorite,
    required Bool? isPublished,
    required String knowledgeId,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.knowledgeBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.get(
        '/knowledge/$knowledgeId/datasources',
        queryParameters: {
          'q': q,
          'order': order,
          'offset': offset,
          'limit': limit,
        },
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}