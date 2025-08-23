import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialRepository {
  final _storage = const FlutterSecureStorage();

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: "email", value: email);
    await _storage.write(key: "password", value: password);
  }

  Future<Map<String, String?>> loadCredentials() async {
    final email = await _storage.read(key: "email");
    final password = await _storage.read(key: "password");
    return {"email": email, "password": password};
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: "email");
    await _storage.delete(key: "password");
  }
}
