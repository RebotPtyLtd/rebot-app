import 'dart:io' show Platform;
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Chrome / Web
      return 'http://127.0.0.1:3000/api/auth';
    } else if (Platform.isAndroid) {
      // Android emulator
      return 'http://10.0.2.2:3000/api/auth';
    } else {
      // iOS simulator / macOS app
      return 'http://127.0.0.1:3000/api/auth';
    }
  }
}

class ApiService {
  Future<http.Response> login(String username, String password) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/login");

    final response = await http.post(
      url,
      body: {"username": username, "password": password},
    );

    return response;
  }
}
