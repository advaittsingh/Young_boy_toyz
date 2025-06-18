import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/vehicle.dart';

class VehicleService {
  static Database? _database;
  static final VehicleService _instance = VehicleService._internal();
  factory VehicleService() => _instance;
  VehicleService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'vehicles.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        price REAL,
        location TEXT,
        make TEXT,
        model TEXT,
        year INTEGER,
        mileage INTEGER,
        modifications TEXT,
        contactInfo TEXT,
        imageUrls TEXT
      )
    ''');
  }

  Future<int> saveVehicle(Map<String, dynamic> vehicle) async {
    final db = await database;
    return await db.insert('vehicles', vehicle);
  }

  Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await database;
    return await db.query('vehicles');
  }

  Future<String> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await image.copy('${directory.path}/$fileName');
    return savedImage.path;
  }

  Future<void> showCarHistory(BuildContext context, Vehicle vehicle) async {
    // TODO: Implement car history API call
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Car History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: ${vehicle.title}'),
            const SizedBox(height: 8),
            const Text('• First registration: January 2020'),
            const Text('• Previous owners: 2'),
            const Text('• Service history available'),
            const Text('• No accidents reported'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> showCertification(BuildContext context, Vehicle vehicle) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('YBT Certification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: ${vehicle.title}'),
            const SizedBox(height: 8),
            const Text('✓ Verified by YBT experts'),
            const Text('✓ Quality checked'),
            const Text('✓ Performance tested'),
            const Text('✓ Documentation verified'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> showFullSpecification(BuildContext context, Vehicle vehicle) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Full Specification'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle: ${vehicle.title}'),
              const SizedBox(height: 16),
              ...vehicle.specifications.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(e.value.toString()),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> showEmiCalculator(BuildContext context, Vehicle vehicle) async {
    final TextEditingController downPaymentController = TextEditingController();
    final TextEditingController tenureController = TextEditingController(text: '60');
    final TextEditingController interestRateController = TextEditingController(text: '10.99');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          double calculateEmi() {
            final price = vehicle.price;
            final downPayment = double.tryParse(downPaymentController.text) ?? 0;
            final tenure = double.tryParse(tenureController.text) ?? 60;
            final interestRate = double.tryParse(interestRateController.text) ?? 10.99;

            final principal = price - downPayment;
            final monthlyRate = interestRate / 12 / 100;
            final numerator = principal * monthlyRate * pow(1 + monthlyRate, tenure);
            final denominator = pow(1 + monthlyRate, tenure) - 1;
            final emi = denominator != 0 ? numerator / denominator : 0;

            return emi.toDouble();
          }

          return AlertDialog(
            title: const Text('EMI Calculator'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Vehicle Price: ₹${vehicle.price.toStringAsFixed(0)}'),
                const SizedBox(height: 16),
                TextField(
                  controller: downPaymentController,
                  decoration: const InputDecoration(
                    labelText: 'Down Payment',
                    prefixText: '₹',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: tenureController,
                  decoration: const InputDecoration(
                    labelText: 'Tenure (months)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: interestRateController,
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate (%)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Text(
                  'Monthly EMI: ₹${calculateEmi().toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> showInsuranceQuotes(BuildContext context, Vehicle vehicle) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insurance Quotes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: ${vehicle.title}'),
            const SizedBox(height: 16),
            const Text('Available Insurance Plans:'),
            const SizedBox(height: 8),
            _buildInsuranceCard('Comprehensive', '₹45,000/year', 'Full coverage with zero depreciation'),
            _buildInsuranceCard('Third Party', '₹15,000/year', 'Basic coverage for third-party damages'),
            _buildInsuranceCard('Zero Depreciation', '₹55,000/year', 'Premium coverage with zero depreciation'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceCard(String title, String price, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(price, style: const TextStyle(color: Colors.red)),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> reserveVehicle(BuildContext context, Vehicle vehicle) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reserve Vehicle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle: ${vehicle.title}'),
            const SizedBox(height: 8),
            const Text('Would you like to reserve this vehicle?'),
            const Text('A refundable deposit of ₹50,000 will be required.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reserve'),
          ),
        ],
      ),
    );

    if (result == true) {
      // TODO: Implement reservation API call
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle reserved successfully!')),
        );
      }
    }
  }

  Future<void> callOwner(BuildContext context, Vehicle vehicle) async {
    final phone = vehicle.contactInfo['phone'];
    if (phone != null) {
      // TODO: Implement phone call functionality
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Calling $phone...')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number not available')),
        );
      }
    }
  }
} 