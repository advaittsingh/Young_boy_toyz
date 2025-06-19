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
  String _selectedSort = 'Default';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Map<String, String?> _filters = {
    'Category': null,
    'Make': null,
    'Model': null,
    'Location': null,
  };

  double _minPrice = 0;
  double _maxPrice = 10000000;
  RangeValues _priceRange = const RangeValues(0, 10000000);

  int _minYear = 1990;
  int _maxYear = DateTime.now().year;
  RangeValues _yearRange = const RangeValues(1990, 2025);

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
  ];

  List<Vehicle> get _filteredVehicles {
    List<Vehicle> filtered = _vehicles.where((v) {
      final inCategory = _filters['Category'] == null || v.category == _filters['Category'];
      final inMake = _filters['Make'] == null || v.make == _filters['Make'];
      final inModel = _filters['Model'] == null || v.model == _filters['Model'];
      final inLocation = _filters['Location'] == null || v.location == _filters['Location'];
      final inYear = v.year >= _yearRange.start.toInt() && v.year <= _yearRange.end.toInt();
      final inPrice = v.price >= _priceRange.start && v.price <= _priceRange.end;
      final matchesSearch = v.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return inCategory && inMake && inModel && inLocation && inYear && inPrice && matchesSearch;
    }).toList();

    if (_selectedSort == 'Price: Low to High') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Price: High to Low') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primaryBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              ..._filters.keys.map((key) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(key, style: const TextStyle(color: Colors.white)),
                  DropdownButtonFormField<String>(
                    value: _filters[key],
                    decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                    items: [null, ..._vehicles.map((v) => v.toMap()[key.toLowerCase()] as String)].toSet().map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value ?? 'All'),
                      );
                    }).toList(),
                    onChanged: (value) => setModalState(() => _filters[key] = value),
                  ),
                  const SizedBox(height: 12),
                ],
              )),
              const SizedBox(height: 16),
              const Text('Price Range', style: TextStyle(color: Colors.white)),
              RangeSlider(
                values: _priceRange,
                min: _minPrice,
                max: _maxPrice,
                divisions: 100,
                labels: RangeLabels('₹${_priceRange.start.toInt()}', '₹${_priceRange.end.toInt()}'),
                onChanged: (values) => setModalState(() => _priceRange = values),
              ),
              const Text('Year Range', style: TextStyle(color: Colors.white)),
              RangeSlider(
                values: _yearRange,
                min: _minYear.toDouble(),
                max: _maxYear.toDouble(),
                divisions: _maxYear - _minYear,
                labels: RangeLabels('${_yearRange.start.toInt()}', '${_yearRange.end.toInt()}'),
                onChanged: (values) => setModalState(() => _yearRange = values),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Vehicles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => ListView(
                shrinkWrap: true,
                children: [
                  ListTile(title: const Text('Default'), onTap: () => setState(() => _selectedSort = 'Default')),
                  ListTile(title: const Text('Price: Low to High'), onTap: () => setState(() => _selectedSort = 'Price: Low to High')),
                  ListTile(title: const Text('Price: High to Low'), onTap: () => setState(() => _selectedSort = 'Price: High to Low')),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search vehicles...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredVehicles.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: VehicleCard(vehicle: _filteredVehicles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension VehicleMapper on Vehicle {
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'make': make,
      'model': model,
      'year': year.toString(),
      'price': price.toString(),
      'location': location,
      'category': category,
    };
  }
}
