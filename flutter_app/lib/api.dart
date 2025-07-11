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

Future<Map<String, dynamic>> fetchOfficeDetails(int officeId) async {
  final res = await http.get(Uri.parse('$baseUrl/offices/$officeId'));

  if (res.statusCode != 200) {
    throw Exception('Failed to load office details');
  }

  return json.decode(res.body);
}

Future<List<dynamic>> fetchOfficeItems(int officeId) async {
  final res = await http.get(Uri.parse('$baseUrl/offices/$officeId/items'));

  if (res.statusCode != 200) {
    throw Exception('Failed to load office items');
  }

  final body = json.decode(res.body);
  return body['items'];
}

Future<List<dynamic>> fetchItemComments(int itemId) async {
  final res = await http.get(Uri.parse('$baseUrl/items/$itemId/comments'));

  if (res.statusCode != 200) {
    throw Exception('Failed to load item comments');
  }

  final body = json.decode(res.body);
  return body['comments'];
}

Future<Map<String, dynamic>> fetchItemDetails(int itemId) async {
  final res = await http.get(Uri.parse('$baseUrl/items/$itemId'));

  if (res.statusCode != 200) {
    throw Exception('Failed to load item details');
  }

  return json.decode(res.body);
}

Future<List<dynamic>> fetchUsers() async {
  final res = await http.get(Uri.parse('$baseUrl/users'));

  if (res.statusCode != 200) {
    throw Exception('Failed to load users');
  }

  final body = json.decode(res.body);
  return body['users'];
}
