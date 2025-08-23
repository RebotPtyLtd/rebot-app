// This file is your new network repository, placed in a 'services' folder.
// For example: lib/services/auth_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rebot_flutter_app/utils/app_config.dart';

class AuthRepository {
  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/login");
    final Map<String, String> body = {'email': email, 'password': password};
    try {
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      return http.Response(
        '{"error": "Failed to connect to the server."}',
        500,
      );
    }
  }
}
