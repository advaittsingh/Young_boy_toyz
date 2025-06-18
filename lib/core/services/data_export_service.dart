import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'auth_service.dart';

class DataExportService {
  static final DataExportService _instance = DataExportService._internal();
  factory DataExportService() => _instance;
  DataExportService._internal();

  Future<Map<String, dynamic>> _gatherUserData() async {
    final authService = AuthService();
    // TODO: Add more user data from other services as needed
    return {
      'user': {
        'email': authService.currentUserEmail,
        'role': authService.currentUserRole?.toString(),
      },
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': '1.0.0',
    };
  }

  Future<void> exportUserData() async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission is required to export data');
      }

      // Gather user data
      final userData = await _gatherUserData();
      final jsonData = jsonEncode(userData);

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/user_data_${DateTime.now().millisecondsSinceEpoch}.json');

      // Write data to file
      await file.writeAsString(jsonData);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My Young Boy Toyz Data Export',
      );
    } catch (e) {
      throw Exception('Failed to export data: ${e.toString()}');
    }
  }
} 