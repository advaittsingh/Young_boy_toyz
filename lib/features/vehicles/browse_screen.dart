import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/widgets/vehicle_card.dart';

class BrowseScreen extends StatefulWidget {
  final String? initialCollection;
  const BrowseScreen({super.key, this.initialCollection});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late String _selectedCollection;

  final List<String> _collections = [
    'All',
    'GS Designs',
    'YBT Collection',
    'Torque Tuner Edition',
    'Customs Workshop Collection',
  ];

  final List<Vehicle> _vehicles = [
    Vehicle(
      id: '1',
      title: 'GS Designs Supra',
      make: 'Toyota',
      model: 'Supra',
      year: 1998,
      price: 2500000,
      location: 'Mumbai, Maharashtra',
      category: 'GS Designs',
      images: ['https://via.placeholder.com/800x600'],
      description: 'GS Designs custom Supra.',
      modifications: ['Engine swap', 'Custom exhaust', 'Body kit'],
      specifications: {
        'Engine': '2JZ-GTE',
        'Power': '600 HP',
        'Transmission': 'Manual',
      },
      ownerId: '1',
      ownerName: 'John Doe',
      contactInfo: {
        'phone': '+919876543210',
        'instagram': '@johndoe',
        'youtube': 'https://youtube.com/@johndoe',
      },
      createdAt: DateTime.now(),
    ),
    Vehicle(
      id: '2',
      title: 'YBT Collection GTR',
      make: 'Nissan',
      model: 'GTR',
      year: 2012,
      price: 4500000,
      location: 'Delhi, India',
      category: 'YBT Collection',
      images: ['https://via.placeholder.com/800x600'],
      description: 'YBT Collection Nissan GTR.',
      modifications: ['Turbo upgrade', 'Widebody kit'],
      specifications: {
        'Engine': 'VR38DETT',
        'Power': '700 HP',
        'Transmission': 'Automatic',
      },
      ownerId: '2',
      ownerName: 'Jane Smith',
      contactInfo: {
        'phone': '+919812345678',
        'instagram': '@janesmith',
        'youtube': 'https://youtube.com/@janesmith',
      },
      createdAt: DateTime.now(),
    ),
    // Add more sample vehicles for each collection
  ];

  @override
  void initState() {
    super.initState();
    _selectedCollection = widget.initialCollection ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = _selectedCollection == 'All'
        ? _vehicles
        : _vehicles.where((v) => v.category == _selectedCollection).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Vehicles'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter by Collection:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCollection,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    border: OutlineInputBorder(),
                  ),
                  items: _collections.map((collection) {
                    return DropdownMenuItem(
                      value: collection,
                      child: Text(collection),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCollection = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = filteredVehicles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: VehicleCard(
                    vehicle: vehicle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 