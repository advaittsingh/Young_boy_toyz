import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _currentUserEmail;
  UserRole? _currentUserRole;
  String? _pendingEmail;
  String? _pendingNumber;
  String? _pendingName;
  String? _generatedEmailOtp;
  String? _generatedNumberOtp;
  late SharedPreferences _prefs;

  // Super admin credentials
  static const String superAdminEmail = 'Superadmin@ybt.com';
  static const String superAdminPassword = 'superadmin123';

  // In-memory user store (email -> number)
  final Map<String, String> _users = {};

  String? get currentUserEmail => _currentUserEmail;
  UserRole? get currentUserRole => _currentUserRole;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _currentUserEmail = _prefs.getString('currentUserEmail');
    final roleString = _prefs.getString('currentUserRole');
    if (roleString != null) {
      _currentUserRole = UserRole.values.firstWhere(
        (role) => role.toString() == roleString,
        orElse: () => UserRole.user,
      );
    }
    
    // Load users from preferences
    final usersJson = _prefs.getString('users');
    if (usersJson != null) {
      final Map<String, dynamic> decoded = Map<String, dynamic>.from(
        Map<String, dynamic>.from(usersJson as Map)
      );
      _users.addAll(Map<String, String>.from(decoded));
    }
  }

  // Super admin login
  bool loginSuperAdmin(String email, String password) {
    if (email == superAdminEmail && password == superAdminPassword) {
      _currentUserEmail = email;
      _currentUserRole = UserRole.superAdmin;
      _saveUserState();
      return true;
    }
    return false;
  }

  // User signup (returns generated OTPs)
  Map<String, String> signupUser(String name, String email, String number) {
    _pendingName = name;
    _pendingEmail = email;
    _pendingNumber = number;
    _generatedEmailOtp = _generateOtp();
    _generatedNumberOtp = _generateOtp();
    return {
      'emailOtp': _generatedEmailOtp!,
      'numberOtp': _generatedNumberOtp!,
    };
  }

  // User OTP verification
  bool verifyUserOtp(String emailOtp, String numberOtp) {
    if (emailOtp == _generatedEmailOtp && numberOtp == _generatedNumberOtp) {
      _users[_pendingEmail!] = _pendingNumber!;
      _currentUserEmail = _pendingEmail;
      _currentUserRole = UserRole.user;
      _saveUserState();
      _pendingEmail = null;
      _pendingNumber = null;
      _pendingName = null;
      _generatedEmailOtp = null;
      _generatedNumberOtp = null;
      return true;
    }
    return false;
  }

  // User login (OTP flow)
  String? loginUser(String email, String number) {
    if (_users.containsKey(email) && _users[email] == number) {
      _pendingEmail = email;
      _pendingNumber = number;
      _generatedEmailOtp = _generateOtp();
      _generatedNumberOtp = _generateOtp();
      return _generatedEmailOtp!; // For demo, return email OTP (number OTP is similar)
    }
    return null;
  }

  bool verifyLoginOtp(String emailOtp, String numberOtp) {
    if (emailOtp == _generatedEmailOtp && numberOtp == _generatedNumberOtp) {
      _currentUserEmail = _pendingEmail;
      _currentUserRole = UserRole.user;
      _saveUserState();
      _pendingEmail = null;
      _pendingNumber = null;
      _generatedEmailOtp = null;
      _generatedNumberOtp = null;
      return true;
    }
    return false;
  }

  void logout() {
    _currentUserEmail = null;
    _currentUserRole = null;
    _prefs.remove('currentUserEmail');
    _prefs.remove('currentUserRole');
  }

  void _saveUserState() {
    _prefs.setString('currentUserEmail', _currentUserEmail ?? '');
    _prefs.setString('currentUserRole', _currentUserRole?.toString() ?? '');
    _prefs.setString('users', _users.toString());
  }

  String _generateOtp() {
    final rand = Random();
    return (100000 + rand.nextInt(900000)).toString();
  }
} 