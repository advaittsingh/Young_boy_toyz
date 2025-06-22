import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  SharedPreferences? _prefs;

  String? _currentUserEmail;
  UserRole? _currentUserRole;
  String? _pendingEmail;
  String? _pendingNumber;
  String? _pendingName;
  String? _pendingPassword;
  String? _generatedEmailOtp;
  String? _generatedNumberOtp;

  static const String superAdminEmail = 'Superadmin@ybt.com';
  static const String superAdminPassword = 'superadmin123';

  final Map<String, Map<String, String>> _users = {}; // email -> {password, phone}

  String? get currentUserEmail => _currentUserEmail;
  UserRole? get currentUserRole => _currentUserRole;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    _currentUserEmail = _prefs?.getString('currentUserEmail');
    final roleStr = _prefs?.getString('currentUserRole');
    if (roleStr != null) {
      _currentUserRole = UserRole.values.firstWhere(
        (r) => r.toString() == roleStr,
        orElse: () => UserRole.user,
      );
    }

    final usersJson = _prefs?.getString('users');
    if (usersJson != null) {
      final decoded = json.decode(usersJson);
      for (var entry in decoded.entries) {
        _users[entry.key] = Map<String, String>.from(entry.value);
      }
    }
  }

  Future<UserRole?> loginWithPassword(String email, String password) async {
    if (email == superAdminEmail && password == superAdminPassword) {
      _currentUserEmail = email;
      _currentUserRole = UserRole.superAdmin;
      await _saveUserState();
      return UserRole.superAdmin;
    }

    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      _currentUserEmail = email;
      _currentUserRole = UserRole.user;
      await _saveUserState();
      return UserRole.user;
    }

    return null;
  }

  String? loginWithOtp(String email, String phone) {
    if (_users.containsKey(email) && _users[email]!['phone'] == phone) {
      _pendingEmail = email;
      _pendingNumber = phone;
      _generatedEmailOtp = _generateOtp();
      _generatedNumberOtp = _generateOtp();
      return _generatedEmailOtp!;
    }
    return null;
  }

  String? getGeneratedNumberOtp() {
    return _generatedNumberOtp;
  }

  bool verifyLoginOtp(String emailOtp, String numberOtp) {
    if (emailOtp == _generatedEmailOtp && numberOtp == _generatedNumberOtp) {
      _currentUserEmail = _pendingEmail;
      _currentUserRole = UserRole.user;
      _clearPending();
      _saveUserState();
      return true;
    }
    return false;
  }

  Map<String, String> signupUser(String name, String email, String phone, String password) {
    _pendingName = name;
    _pendingEmail = email;
    _pendingNumber = phone;
    _pendingPassword = password;

    _generatedEmailOtp = _generateOtp();
    _generatedNumberOtp = _generateOtp();

    return {
      'emailOtp': _generatedEmailOtp!,
      'numberOtp': _generatedNumberOtp!,
    };
  }

  bool verifyUserOtp(String emailOtp, String numberOtp) {
    if (emailOtp == _generatedEmailOtp && numberOtp == _generatedNumberOtp) {
      _users[_pendingEmail!] = {
        'password': _pendingPassword!,
        'phone': _pendingNumber!,
      };

      _currentUserEmail = _pendingEmail;
      _currentUserRole = UserRole.user;
      _clearPending();
      _saveUserState();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUserEmail = null;
    _currentUserRole = null;
    await _prefs?.remove('currentUserEmail');
    await _prefs?.remove('currentUserRole');
  }

  Future<void> _saveUserState() async {
    await _prefs?.setString('currentUserEmail', _currentUserEmail ?? '');
    await _prefs?.setString('currentUserRole', _currentUserRole?.toString() ?? '');
    final usersJson = json.encode(_users);
    await _prefs?.setString('users', usersJson);
  }

  void _clearPending() {
    _pendingEmail = null;
    _pendingName = null;
    _pendingNumber = null;
    _pendingPassword = null;
    _generatedEmailOtp = null;
    _generatedNumberOtp = null;
  }

  String _generateOtp() {
    final rand = Random();
    return (100000 + rand.nextInt(900000)).toString();
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail');
    return email != null && email.isNotEmpty;
  }
}
