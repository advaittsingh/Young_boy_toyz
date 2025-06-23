import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUserSession({
    required String email,
    required String name,
    required String role,
    required String token,
  }) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'role', value: role);
    await _storage.write(key: 'token', value: token);
    await _storage.write(
        key: 'lastActiveTime', value: DateTime.now().toIso8601String());
  }

  Future<Map<String, String?>> getUserSession() async {
    final email = await _storage.read(key: 'email');
    final name = await _storage.read(key: 'name');
    final role = await _storage.read(key: 'role');
    final token = await _storage.read(key: 'token');
    final lastActiveTime = await _storage.read(key: 'lastActiveTime');
    return {
      'email': email,
      'name': name,
      'role': role,
      'token': token,
      'lastActiveTime': lastActiveTime,
    };
  }

  Future<void> updateLastActiveTime() async {
    await _storage.write(
        key: 'lastActiveTime', value: DateTime.now().toIso8601String());
  }

  Future<bool> isSessionTimedOut(Duration timeout) async {
    final lastActiveTimeStr = await _storage.read(key: 'lastActiveTime');
    if (lastActiveTimeStr == null) return true;
    final lastActiveTime = DateTime.tryParse(lastActiveTimeStr);
    if (lastActiveTime == null) return true;
    return DateTime.now().difference(lastActiveTime) > timeout;
  }

  Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
