import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String authBaseUrl = 'https://auth-api.dev.jarvis.cx/api/v1';
  static const String jarvisBaseUrl = 'https://api.dev.jarvis.cx/api/v1';
  static const String knowledgeBaseUrl = 'https://knowledge-api.dev.jarvis.cx/kb-core/v1';
  static const String projectId = 'a914f06b-5e46-4966-8693-80e4b9f4f409';
  static const String clientKey = 'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr';
  static String? _authToken;

  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String verificationCallbackUrl,
  }) async {
    try {
      final url = Uri.parse('$authBaseUrl/auth/password/sign-up');
      final headers = {
        'Content-Type': 'application/json',
        'X-Stack-Access-Type': 'client',
        'X-Stack-Project-Id': projectId,
        'X-Stack-Publishable-Client-Key': clientKey,
        'Accept': 'application/json',
      };
      final body = jsonEncode({
        'email': email,
        'password': password,
        'verification_callback_url': verificationCallbackUrl,
      });

      print('POST $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = response.body;
        print('Error Response: $errorBody');
        throw Exception('Failed to sign up: $errorBody');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$authBaseUrl/auth/password/sign-in');
      final headers = {
        'Content-Type': 'application/json',
        'X-Stack-Access-Type': 'client',
        'X-Stack-Project-Id': projectId,
        'X-Stack-Publishable-Client-Key': clientKey,
        'Accept': 'application/json',
      };
      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      print('POST $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['access_token'];
        return data;
      } else {
        final errorBody = response.body;
        print('Error Response: $errorBody');
        throw Exception('Failed to sign in: $errorBody');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

    static Future<String> getBotResponse(String message) async {
    if(_authToken == null){
      throw Exception('No authentication token found');
    }
    final url = Uri.parse('$jarvisBaseUrl/ai-chat/messages');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_authToken',
    };
    final body = jsonEncode({
      'content': message,
      'files': [],
      'metadata': {
        'conversation': {
          'message': [
            {
              'role': 'user',
              'content': message,
              'files': [],
              'assistant': {
                'model': 'gpt-4o-mini',
                'name': 'ByMax',
                'id': projectId,
              }
            }
          ]
        }
      },
      'assistant': {
        'model': 'knowledge-base',
        'name': 'ByMax',
        'id': projectId,
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']; // Adjust based on your API response structure
      } else {
        throw Exception('Failed to get bot response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error communicating with the bot: $e');
    }
  }
}