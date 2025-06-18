import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/models/vehicle.dart';
import '../../../core/widgets/vehicle_card.dart';
import '../settings/notification_settings_screen.dart';
import '../settings/privacy_screen.dart';
import '../faq/faq_screen.dart';
import '../support/help_support_screen.dart';
import '../../core/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data
    final user = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+91 98765 43210',
      'instagram': '@johndoe',
      'youtube': 'youtube.com/@johndoe',
      'bio': 'Car enthusiast and collector. Specializing in modified Japanese cars.',
      'joinedDate': 'January 2024',
      'listingsCount': 5,
      'favoritesCount': 12,
    };

    // Mock user's vehicle listings
    final userListings = [
      Vehicle(
        id: '1',
        title: 'Modified Toyota Supra MK4',
        make: 'Toyota',
        model: 'Supra',
        year: 1998,
        price: 2500000,
        location: 'Mumbai, Maharashtra',
        category: 'Vintage / Classics',
        images: ['https://via.placeholder.com/800x600'],
        description: 'Beautifully modified Supra with extensive engine work.',
        modifications: ['Engine swap', 'Custom exhaust', 'Body kit'],
        specifications: {
          'Engine': '2JZ-GTE',
          'Power': '600 HP',
          'Transmission': 'Manual',
        },
        ownerId: '1',
        ownerName: user['name'] as String,
        contactInfo: {
          'phone': user['phone'] as String,
          'instagram': user['instagram'] as String,
          'youtube': user['youtube'] as String,
        },
        createdAt: DateTime.now(),
      ),
      // Add more mock listings here
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(user['name'] as String),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryBlack,
                      AppTheme.primaryBlack.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.secondaryBlack,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user['bio'] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.email, color: AppTheme.textGrey),
                              const SizedBox(width: 8),
                              Text(
                                user['email'] as String,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: AppTheme.textGrey),
                              const SizedBox(width: 8),
                              Text(
                                user['phone'] as String,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppTheme.textGrey),
                              const SizedBox(width: 8),
                              Text(
                                'Joined ${user['joinedDate']}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            'Listings',
                            user['listingsCount'].toString(),
                            Icons.directions_car,
                          ),
                          _buildStatItem(
                            context,
                            'Favorites',
                            user['favoritesCount'].toString(),
                            Icons.favorite,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // My Listings Section
                  Text(
                    'My Listings',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userListings.length,
                    itemBuilder: (context, index) {
                      final vehicle = userListings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: VehicleCard(
                          vehicle: vehicle,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Settings Section
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Notifications'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationSettingsScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.question_answer),
                          title: const Text('FAQ'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FAQScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Privacy'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text('Help & Support'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Logout', style: TextStyle(color: Colors.red)),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AuthService().logout();
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/',
                                        (route) => false,
                                      );
                                    },
                                    child: const Text('Logout', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentRed),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentRed,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
} 