import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/vehicle.dart';

class CsvVehicleService {
  Future<List<Vehicle>> loadVehiclesFromCsv(String assetPath) async {
    final csvString = await rootBundle.loadString(assetPath);
    final csvRows = const CsvToListConverter(eol: '\n').convert(csvString);

    // Assuming first row is header
    final headers = csvRows.first.map((e) => e.toString()).toList();
    final dataRows = csvRows.skip(1);

    List<Vehicle> vehicles = [];

    for (var row in dataRows) {
      Map<String, dynamic> rowData = {};
      for (int i = 0; i < headers.length; i++) {
        rowData[headers[i]] = row[i];
      }

      // Map CSV data to Vehicle model fields
      vehicles.add(Vehicle(
        id: rowData['Registration Number']?.toString() ?? '',
        title: rowData['Car Model']?.toString() ?? '',
        make: '', // Not in CSV, can be parsed from model if needed
        model: '', // Not in CSV, can be parsed from model if needed
        year: int.tryParse(rowData['Registration Year']?.toString() ?? '') ?? 0,
        price: double.tryParse(rowData['Selling price']?.toString() ?? '')?.toInt() ?? 0,
        location: '', // Not in CSV
        category: '', // Not in CSV
        images: [], // No image URLs in CSV
        description: rowData['Car USP']?.toString() ?? '',
        modifications: [],
        specifications: {},
        ownerId: '',
        ownerName: rowData['Listed By']?.toString() ?? '',
        contactInfo: {},
        createdAt: DateTime.now(),
      ));
    }

    return vehicles;
  }
}
