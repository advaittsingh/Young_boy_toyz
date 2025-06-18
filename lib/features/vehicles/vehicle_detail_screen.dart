import 'package:flutter/material.dart';
import '../../../core/models/vehicle.dart';
import '../../theme/app_theme.dart';
import '../../../core/services/vehicle_service.dart';
import 'reserve_now_screen.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;
  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final vehicleService = VehicleService();
    // Dummy data for demo
    final emi = '₹ 8,34,718/month';
    final similarCars = [
      Vehicle(
        id: '2',
        title: 'TOYOTA LAND CRUISER LC300',
        make: 'Toyota',
        model: 'Land Cruiser',
        year: 2022,
        price: 19500000,
        location: 'Delhi',
        category: 'GS Designs',
        images: ['https://via.placeholder.com/800x600'],
        description: '',
        modifications: [],
        specifications: {},
        ownerId: '',
        ownerName: '',
        contactInfo: {},
        createdAt: DateTime.now(),
      ),
      // Add more similar cars if needed
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppTheme.textWhite),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          // Title, price, EMI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.textWhite)),
                const SizedBox(height: 4),
                Text('₹ ${vehicle.price.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.accentRed, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('EMI Starts @ $emi', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          // Image carousel
          SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: vehicle.images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      vehicle.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.secondaryBlack,
                        child: const Icon(Icons.error, color: AppTheme.textGrey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Quick info cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoCard(label: '${vehicle.year}', sub: 'Model', icon: Icons.calendar_today),
                _InfoCard(label: '7000', sub: 'KMs', icon: Icons.speed),
                _InfoCard(label: 'Petrol', sub: 'Fuel Type', icon: Icons.local_gas_station),
                // Add more if needed
              ],
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textWhite)),
                const SizedBox(height: 8),
                Text(vehicle.description.isNotEmpty ? vehicle.description : '•', style: const TextStyle(fontSize: 16, color: AppTheme.textWhite)),
              ],
            ),
          ),
          // Full specification (key-value)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...vehicle.specifications.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.key}:',
                        style: const TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        e.value,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textWhite),
                        softWrap: true,
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          // Car history, certification, full spec buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _ActionButton(
                    icon: Icons.settings,
                    label: 'Car History',
                    onTap: () => vehicleService.showCarHistory(context, vehicle),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.verified,
                    label: 'YBT Certified',
                    onTap: () => vehicleService.showCertification(context, vehicle),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.list_alt,
                    label: 'Full Specification',
                    onTap: () => vehicleService.showFullSpecification(context, vehicle),
                  ),
                ],
              ),
            ),
          ),
          // EMI and insurance
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EMI Starts', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textWhite)),
                Text(emi, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentRed)),
                const Text('( for 60 months & interest rate 10.99% )', style: TextStyle(color: AppTheme.textGrey)),
                const SizedBox(height: 8),
                _ActionButton(
                  icon: Icons.calculate,
                  label: 'EMI Calculator',
                  onTap: () => vehicleService.showEmiCalculator(context, vehicle),
                ),
                const SizedBox(height: 16),
                const Text('Car Insurance', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textWhite)),
                const Text('Save upto 60%* on your car insurance', style: TextStyle(color: AppTheme.textGrey)),
                const SizedBox(height: 8),
                _ActionButton(
                  icon: Icons.shield,
                  label: 'Get Insurance Quotes',
                  onTap: () => vehicleService.showInsuranceQuotes(context, vehicle),
                ),
              ],
            ),
          ),
          // Similar cars
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: const Text('Similar Cars', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textWhite)),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: similarCars.length,
              itemBuilder: (context, index) {
                final car = similarCars[index];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(left: 16, right: 8),
                  child: Card(
                    color: AppTheme.secondaryBlack,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            car.images.first,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textWhite)),
                              Text('₹ ${car.price.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.accentRed)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 80), // For bottom bar spacing
        ],
      ),
      bottomNavigationBar: Container(
        color: AppTheme.primaryBlack,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReserveNowScreen(vehicle: vehicle),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentRed,
                  foregroundColor: AppTheme.textWhite,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Reserve this car'),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.call, color: Colors.white),
                onPressed: () => vehicleService.callOwner(context, vehicle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String sub;
  final IconData icon;
  const _InfoCard({required this.label, required this.sub, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.textWhite, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textWhite)),
        Text(sub, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.textGrey.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.textWhite, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppTheme.textWhite)),
          ],
        ),
      ),
    );
  }
} 