import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/models/vehicle.dart';
import '../../core/widgets/vehicle_card.dart';
import '../vehicles/browse_screen.dart';
import '../vehicles/submit_vehicle_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const HomeContent(),
    const BrowseScreen(),
    const SubmitVehicleScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Submit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppTheme.accentRed,
        unselectedItemColor: AppTheme.textGrey,
        backgroundColor: AppTheme.primaryBlack,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<String> _slideshowImages = [
    'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d', // Car
    'https://images.unsplash.com/photo-1519681393784-d120267933ba', // Car
    'https://images.unsplash.com/photo-1465101046530-73398c7f28ca', // Car
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70', // Car
    'https://images.unsplash.com/photo-1511918984145-48de785d4c4e', // Car
  ];
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Sample vehicles for demo
  final List<Vehicle> featuredVehicles = [
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
      specifications: {'Engine': '2JZ-GTE', 'Power': '600 HP', 'Transmission': 'Manual'},
      ownerId: '1',
      ownerName: 'John Doe',
      contactInfo: {'phone': '+919876543210', 'instagram': '@johndoe', 'youtube': 'https://youtube.com/@johndoe'},
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
      specifications: {'Engine': 'VR38DETT', 'Power': '700 HP', 'Transmission': 'Automatic'},
      ownerId: '2',
      ownerName: 'Jane Smith',
      contactInfo: {'phone': '+919812345678', 'instagram': '@janesmith', 'youtube': 'https://youtube.com/@janesmith'},
      createdAt: DateTime.now(),
    ),
  ];
  List<Vehicle> get gsCustomBuilds => featuredVehicles.where((v) => v.category == 'GS Designs').toList();
  List<Vehicle> get ybtBuilds => featuredVehicles.where((v) => v.category == 'YBT Collection').toList();

  void _goToBrowseWithFilter(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BrowseScreen(initialCollection: category),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // App Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48), // For symmetry
              Image.asset(
                'assets/images/LOGO.png',
                width: 250,
                height: 80,
                fit: BoxFit.contain,
              ),
              // const Text(
              //   'Young Boy Toyz',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              // ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
            ],
          ),
          // Slideshow (Carousel)
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 24),
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _slideshowImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        _slideshowImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                      ),
                    );
                  },
                ),
                // Dots Indicator
                Positioned(
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slideshowImages.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppTheme.accentRed : Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          // Categories
          Text(
            'Categories',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryCard(
                  icon: Icons.diamond,
                  iconColor: Colors.blue,
                  label: 'GS Designs',
                  onTap: () => _goToBrowseWithFilter('GS Designs'),
                ),
                const SizedBox(width: 12),
                _CategoryCard(
                  icon: Icons.star,
                  iconColor: AppTheme.accentRed,
                  label: 'YBT Collection',
                  onTap: () => _goToBrowseWithFilter('YBT Collection'),
                ),
                const SizedBox(width: 12),
                _CategoryCard(
                  icon: Icons.settings,
                  iconColor: Colors.orange,
                  label: 'Torque Tuner Edition',
                  onTap: () => _goToBrowseWithFilter('Torque Tuner Edition'),
                ),
                const SizedBox(width: 12),
                _CategoryCard(
                  icon: Icons.build,
                  iconColor: Colors.green,
                  label: 'Customs Workshop Collection',
                  onTap: () => _goToBrowseWithFilter('Customs Workshop Collection'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Featured Listings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Featured Listings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              TextButton(
                onPressed: () => _goToBrowseWithFilter('All'),
                child: Text('View All', style: TextStyle(color: AppTheme.accentRed)),
              ),
            ],
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = featuredVehicles[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  child: VehicleCard(vehicle: vehicle, height: 200),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          // GS Custom Builds
          Text(
            'GS Custom Builds',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gsCustomBuilds.length,
              itemBuilder: (context, index) {
                final vehicle = gsCustomBuilds[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  child: VehicleCard(vehicle: vehicle, height: 200),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          // YBT Builds
          Text(
            'YBT Builds',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ybtBuilds.length,
              itemBuilder: (context, index) {
                final vehicle = ybtBuilds[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  child: VehicleCard(vehicle: vehicle, height: 200),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textWhite, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
} 