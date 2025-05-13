import 'dart:ffi';
import 'package:chatbot_ai/cores/constants/app_constants.dart';
import 'package:chatbot_ai/cores/network/dio_network.dart';
import 'package:chatbot_ai/cores/store/store.dart';
import 'package:dio/dio.dart';

class PromptRepo {
  PromptRepo._();
  static PromptRepo instant = PromptRepo._();

  Future getPrompt({
    required int limit,
    required int offset,
     String? query,
     List<String>? categories,
     bool? isPublic,
      bool isFavorite = false,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.get(
        '/prompts',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'query': query,
          if (categories != null && categories.isNotEmpty) 'categories': categories,
          'offset': 0,
          'limit': 100,
          'isFavorite': isFavorite,
          'isPublic': isPublic,
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
    
    Future getPrivatePrompt({
    required int limit,
    required int offset,
     String? query,
     List<String>? categories,
     bool isPublic = false,
      bool isFavorite = false,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.get(
        '/prompts',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'query': query,
          if (categories != null && categories.isNotEmpty) 'categories': categories,
          'offset': 0,
          'limit': 100,
          'isFavorite': isFavorite,
          'isPublic': isPublic,
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

    Future updatePrompt({
      required String promptId,
      required String title,
      required String content,
      required String description,
      required String category,
      required String language,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
        'Authorization': 'Bearer ${StoreData.instant.token}',
        'Content-Type': 'application/json',
      };

      final response = await DioNetwork.instant.dio.patch(
        '/prompts/$promptId',
        data: {
          'title': title,
          'content': content,
          'description': description,
          'category': category,
          'language': language,
        },
        options: Options(headers: headers),
      );
      
      return response;

      // if (response.statusCode == 200) {
      //   setState(() {
      //     final prompt = _allPrompts.firstWhere((p) => p['_id'] == promptId);
      //     prompt['title'] = title;
      //     prompt['content'] = content;
      //     prompt['description'] = description;
      //   });
      //   print('Prompt updated successfully');
      // } else {
      //   print('Failed to update prompt: ${response.statusMessage}');
      // }
    } catch (e) {
      rethrow;
    }
  }



  Future deletePrompt({required String promptId}) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.delete(
        '/prompts/$promptId',
        options: Options(headers: headers),
      );

      return response;

      // if (response.statusCode == 200) {
      //   setState(() {
      //     _allPrompts.removeWhere((p) => p['_id'] == promptId);
      //     _privatePrompts.removeWhere((p) => p['_id'] == promptId);
      //   });
      //   print('Prompt deleted successfully');
      // } else {
      //   print('Failed to delete prompt: ${response.statusMessage}');
      // }
    } catch (e) {
      rethrow;
    }
  }

  Future toggleFavorite({required String promptId, required bool isFavorite}) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
      };

      final response = await DioNetwork.instant.dio.post(
        '/prompts/$promptId/favorite',
        options:
            Options(headers: headers),
      );
      
      return response;

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(isFavorite
      //       ? 'Prompt removed from favorites'
      //       : 'Prompt added to favorites');
      //   setState(() {
      //     final prompt = _allPrompts.firstWhere((p) => p['_id'] == promptId);
      //     prompt['isFavorite'] = !prompt['isFavorite'];
      //   });
      // } else {
      //   print('Failed to update favorite status: ${response.statusMessage}');
      // }
    } catch (e) {
      rethrow;  
    }
  }

  Future createPrivatePrompt({
    required String category,
    required String title,
    required String content,
    required String description,
    required bool isPublic,
    required String language,
  }) async {
    try {
      DioNetwork.instant.init(AppConstants.jarvisBaseUrl, isAuth: true);
      final headers = {
        'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',

      };

      final response = await DioNetwork.instant.dio.post(
        '/prompts',
        data: {
          'title': title,
          'content': content,
          'description': description,
          'category': category,
          'language': language,
          'isPublic': false,
        },
        options: Options(headers: headers),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}