import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/vehicle.dart';
import '../../theme/app_theme.dart';
import '../../features/vehicles/vehicle_detail_screen.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;
  final double? height;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double cardHeight = height ?? 170;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VehicleDetailScreen(vehicle: vehicle),
            ),
          );
        },
        child: SizedBox(
          height: cardHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: vehicle.images.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.secondaryBlack,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.secondaryBlack,
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vehicle.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${vehicle.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.accentRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppTheme.textGrey,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              vehicle.location,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.year.toString(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 