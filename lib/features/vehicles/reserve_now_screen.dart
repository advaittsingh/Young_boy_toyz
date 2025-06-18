import 'package:flutter/material.dart';
import '../../../core/models/vehicle.dart';
import '../../theme/app_theme.dart';

class ReserveNowScreen extends StatefulWidget {
  final Vehicle vehicle;
  const ReserveNowScreen({super.key, required this.vehicle});

  @override
  State<ReserveNowScreen> createState() => _ReserveNowScreenState();
}

class _ReserveNowScreenState extends State<ReserveNowScreen> {
  int? _selectedOption;

  final List<_ReserveOption> _options = [
    _ReserveOption(label: 'Pay 2 lacs', value: 0, info: 'Pay a token amount of ₹2,00,000 to reserve your car. Fully refundable.'),
    _ReserveOption(label: 'Pay ₹ 48,00,000.00 (10%)', value: 1, info: 'Pay 10% of the car price to reserve. Amount is adjustable in final payment.'),
    _ReserveOption(label: 'Pay ₹ 4,80,00,000 (100%)', value: 2, info: 'Pay the full amount to reserve and complete your purchase.'),
  ];

  void _showInfoDialog(String info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBlack,
        title: const Text('Reservation Info', style: TextStyle(color: AppTheme.textWhite)),
        content: Text(info, style: const TextStyle(color: AppTheme.textWhite)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.accentRed)),
          ),
        ],
      ),
    );
  }

  void _onReserve() {
    if (_selectedOption == null) return;
    String message;
    switch (_selectedOption) {
      case 0:
        message = 'You have chosen to reserve with ₹2,00,000.';
        break;
      case 1:
        message = 'You have chosen to reserve with 10% payment.';
        break;
      case 2:
        message = 'You have chosen to pay the full amount.';
        break;
      default:
        message = 'Please select an option.';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBlack,
        title: const Text('Reservation Submitted', style: TextStyle(color: AppTheme.textWhite)),
        content: Text(message, style: const TextStyle(color: AppTheme.textWhite)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppTheme.accentRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reserve Your Own Luxury', style: TextStyle(color: AppTheme.textWhite)),
        centerTitle: false,
      ),
      backgroundColor: AppTheme.primaryBlack,
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          // Car image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  vehicle.images.isNotEmpty ? vehicle.images.first : '',
                  height: 180,
                  width: 320,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.secondaryBlack,
                    height: 180,
                    width: 320,
                    child: const Icon(Icons.directions_car, size: 60, color: AppTheme.textGrey),
                  ),
                ),
              ),
            ),
          ),
          // Car name and price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.textWhite)),
                const SizedBox(height: 4),
                Text('₹ ${vehicle.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.accentRed)),
              ],
            ),
          ),
          const Divider(height: 32, color: AppTheme.secondaryBlack),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Now that you've found your dream car, make sure nobody else gets their hands on it.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.textWhite),
                ),
                SizedBox(height: 8),
                Text(
                  "Please select how you'd like to reserve your car.",
                  style: TextStyle(color: AppTheme.textGrey, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Reservation options
          ..._options.map((option) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBlack,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: option.value,
                        groupValue: _selectedOption,
                        onChanged: (val) => setState(() => _selectedOption = val),
                        activeColor: AppTheme.accentRed,
                        fillColor: MaterialStateProperty.resolveWith<Color>((states) => AppTheme.accentRed),
                      ),
                      Expanded(
                        child: Text(option.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textWhite)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: AppTheme.textGrey),
                        onPressed: () => _showInfoDialog(option.info),
                      ),
                    ],
                  ),
                ),
              ),
              if (option.value != _options.last.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('OR', style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
                ),
            ],
          )),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ElevatedButton(
          onPressed: _selectedOption != null ? _onReserve : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            disabledBackgroundColor: AppTheme.secondaryBlack,
            disabledForegroundColor: AppTheme.textGrey,
          ),
          child: const Text('Reserve Now'),
        ),
      ),
    );
  }
}

class _ReserveOption {
  final String label;
  final int value;
  final String info;
  const _ReserveOption({required this.label, required this.value, required this.info});
} 