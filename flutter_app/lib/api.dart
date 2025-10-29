import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rebot_flutter_app/models/office.dart';
import 'package:rebot_flutter_app/models/item.dart';
import 'package:rebot_flutter_app/models/comment.dart';
import 'package:rebot_flutter_app/models/user.dart';

final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080/api';

Future<List<Office>> fetchOffices() async {
  final res = await http.get(Uri.parse('$_baseUrl/offices'));

  if (res.statusCode != 200) {
    throw Exception('Failed to load offices');
  }
  final data = json.decode(res.body)['offices'] as List;
  return data.map((e) => Office.fromJson(e)).toList();
}

Future<Office> fetchOfficeDetails(int id) async {
  final res = await http.get(Uri.parse('$_baseUrl/offices/$id'));
  if (res.statusCode != 200) throw Exception('Failed to load office');
  return Office.fromJson(json.decode(res.body));
}

Future<List<Item>> fetchOfficeItems(int id) async {
  final res = await http.get(Uri.parse('$_baseUrl/offices/$id/items'));
  if (res.statusCode != 200) throw Exception('Failed to load items');
  final data = json.decode(res.body)['items'] as List;
  return data.map((e) => Item.fromJson(e)).toList();
}

Future<Item> fetchItemDetails(int id) async {
  final res = await http.get(Uri.parse('$_baseUrl/items/$id'));
  if (res.statusCode != 200) throw Exception('Failed to load item');
  return Item.fromJson(json.decode(res.body));
}

Future<List<Comment>> fetchItemComments(int id) async {
  final res = await http.get(Uri.parse('$_baseUrl/items/$id/comments'));
  if (res.statusCode != 200) throw Exception('Failed to load comments');
  final data = json.decode(res.body)['comments'] as List;
  return data.map((e) => Comment.fromJson(e)).toList();
}

Future<List<User>> fetchUsers() async {
  final res = await http.get(Uri.parse('$_baseUrl/users'));
  if (res.statusCode != 200) throw Exception('Failed to load users');
  final data = json.decode(res.body)['users'] as List;
  return data.map((e) => User.fromJson(e)).toList();
}

Future<void> postComment({
  required int itemId,
  required int userId,
  required String content,
  required String token,
}) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/comments'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'itemId': itemId, 'userId': userId, 'content': content}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to post comment');
  }
}
