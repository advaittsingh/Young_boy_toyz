import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../core/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _newListingsEnabled = true;
  bool _priceUpdatesEnabled = true;
  bool _messagesEnabled = true;
  bool _offersEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Vehicle Notifications',
            children: [
              SwitchListTile(
                title: const Text('New Listings'),
                subtitle: const Text('Get notified when new vehicles are listed'),
                value: _newListingsEnabled,
                onChanged: (value) {
                  setState(() {
                    _newListingsEnabled = value;
                    if (value) {
                      _notificationService.showNewListingNotification('Modified Toyota Supra');
                    }
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Price Updates'),
                subtitle: const Text('Get notified when prices change on vehicles you\'re interested in'),
                value: _priceUpdatesEnabled,
                onChanged: (value) {
                  setState(() {
                    _priceUpdatesEnabled = value;
                    if (value) {
                      _notificationService.showPriceUpdateNotification('Modified Toyota Supra', '₹25,00,000');
                    }
                  });
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Communication',
            children: [
              SwitchListTile(
                title: const Text('Messages'),
                subtitle: const Text('Get notified when you receive new messages'),
                value: _messagesEnabled,
                onChanged: (value) {
                  setState(() {
                    _messagesEnabled = value;
                    if (value) {
                      _notificationService.showMessageNotification('John Doe');
                    }
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Offers'),
                subtitle: const Text('Get notified when you receive offers on your listings'),
                value: _offersEnabled,
                onChanged: (value) {
                  setState(() {
                    _offersEnabled = value;
                    if (value) {
                      _notificationService.showOfferNotification('Modified Toyota Supra', '₹24,00,000');
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Note: You can change these settings at any time. Some notifications may still be sent for important updates.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textGrey,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.accentRed,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
} 