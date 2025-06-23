import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'auth_service.dart';

class DataExportService {
  static const String baseUrl = 'http://localhost:5001';

  /// Exports data as a JSON file and sends it via email to the logged-in user
  static Future<void> exportUserData(Map<String, dynamic> userData) async {
    try {
      // Get user email securely
      final email = await AuthService().getEmail();
      if (email == null) {
        throw Exception('No logged-in user email found.');
      }

      // Convert user data to JSON
      final jsonData = jsonEncode(userData);

      // Optionally write to local file (if needed for debugging or file sharing)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user_data.json');
      await file.writeAsString(jsonData);

      // Send data to backend API (optional step if you're emailing/exporting from server)
      final response = await http.post(
        Uri.parse('$baseUrl/export-data'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'data': userData,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to export data: ${response.body}');
      }

      print('✅ User data exported and emailed to $email');
    } catch (e) {
      print('❌ Data export error: $e');
      rethrow;
    }
  }
}
