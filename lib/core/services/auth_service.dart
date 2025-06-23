import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  // ⚠️ Change this to your computer's local IP if you're using a real iPhone
  static const String baseUrl = 'http://localhost:5001';

  // ====================
  // = AUTH: SIGN UP FLOW =
  // ====================

  // Send OTP for Signup
  Future<Map<String, dynamic>?> sendOtpForSignup(String name, String email) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/send-signup-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email}),
      );
      if (res.statusCode == 200) return json.decode(res.body);
    } catch (e) {
      print('sendOtpForSignup error: $e');
    }
    return null;
  }

  // Verify OTP and Signup
  Future<bool> verifySignupOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/verify-signup-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        await saveSession(
          token: data['token'],
          name: data['name'],
          email: data['email'],
          role: data['role'],
        );
        return true;
      }
    } catch (e) {
      print('verifySignupOtp error: $e');
    }
    return false;
  }

  // Signup using password
  Future<bool> signupWithPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/signup-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        await saveSession(
          token: data['token'],
          name: data['name'],
          email: data['email'],
          role: data['role'],
        );
        return true;
      }
    } catch (e) {
      print('signupWithPassword error: $e');
    }
    return false;
  }

  // ===================
  // = AUTH: LOGIN FLOW =
  // ===================

  // Send OTP for Login
  Future<Map<String, dynamic>?> sendOtpForLogin(String email) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/send-login-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      if (res.statusCode == 200) return json.decode(res.body);
    } catch (e) {
      print('sendOtpForLogin error: $e');
    }
    return null;
  }

  // Verify OTP Login
  Future<bool> verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/verify-login-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        await saveSession(
          token: data['token'],
          name: data['name'],
          email: data['email'],
          role: data['role'],
        );
        return true;
      }
    } catch (e) {
      print('verifyLoginOtp error: $e');
    }
    return false;
  }

  // Login using password
  Future<bool> loginWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        await saveSession(
          token: data['token'],
          name: data['name'],
          email: data['email'],
          role: data['role'],
        );
        return true;
      }
    } catch (e) {
      print('loginWithPassword error: $e');
    }
    return false;
  }

  // ========================
  // = SESSION MANAGEMENT =
  // ========================

  Future<void> saveSession({
    required String token,
    required String name,
    required String email,
    required String role,
  }) async {
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'role', value: role);
  }

  Future<bool> isLoggedIn() async => await _storage.read(key: 'token') != null;
  Future<void> logout() async => await _storage.deleteAll();

  // Getters
  Future<String?> getToken() async => await _storage.read(key: 'token');
  Future<String?> getName() async => await _storage.read(key: 'name');
  Future<String?> getEmail() async => await _storage.read(key: 'email');
  Future<String?> getRole() async => await _storage.read(key: 'role');
}
