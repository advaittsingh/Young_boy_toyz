import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ValidationUtils {
  static bool isValidPhoneNumber(String phone) {
    // Indian phone number validation
    final phoneRegex = RegExp(r'^\+?[91]?[6-9]\d{9}\$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isValidInstagramHandle(String handle) {
    if (handle.isEmpty) return true; // Optional field
    final instagramRegex = RegExp(r'^@?[a-zA-Z0-9._]{1,30}\$');
    return instagramRegex.hasMatch(handle);
  }

  static bool isValidYoutubeChannel(String url) {
    if (url.isEmpty) return true; // Optional field
    final youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com\/(c\/|channel\/|user\/))?[a-zA-Z0-9\-_]{1,}\$');
    return youtubeRegex.hasMatch(url);
  }
} 