import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080/api';

Future<List<dynamic>> fetchOffices() async {
  final res = await http.get(Uri.parse('$baseUrl/offices'));

  if (res.statusCode != 200) {
    throw Exception('Failed to load offices');
  }

  final body = json.decode(res.body);
  return body['offices'];
}
