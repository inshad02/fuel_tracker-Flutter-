import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';

class TripDetailScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final numberFormat = NumberFormat('#,##0.00');
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: _getVehicleColor(trip.vehicleType).withOpacity(0.15),
                        child: Icon(
                          _getVehicleIcon(trip.vehicleType),
                          size: 36,
                          color: _getVehicleColor(trip.vehicleType),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        trip.vehicleType,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dateFormat.format(trip.date),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        timeFormat.format(trip.date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Key Metrics
            Text(
              'Key Metrics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricBox(
                  context,
                  icon: Icons.route,
                  label: 'Distance',
                  value: '${numberFormat.format(trip.distanceTravelled)} km',
                  color: Colors.blue,
                ),
                _buildMetricBox(
                  context,
                  icon: Icons.speed,
                  label: 'Mileage',
                  value: '${numberFormat.format(trip.mileage)} km/l',
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricBox(
                  context,
                  icon: Icons.attach_money,
                  label: 'Fuel Cost',
                  value: currencyFormat.format(trip.totalFuelCost),
                  color: Colors.orange,
                ),
                _buildMetricBox(
                  context,
                  icon: Icons.trending_up,
                  label: 'Economy',
                  value: '${currencyFormat.format(trip.fuelEconomy)}/km',
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Input Details
            Text(
              'Input Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInputDetail(
                    'Start Odometer',
                    '${numberFormat.format(trip.startOdometer)} km',
                    Icons.speed,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputDetail(
                    'End Odometer',
                    '${numberFormat.format(trip.endOdometer)} km',
                    Icons.speed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInputDetail(
                    'Fuel Filled',
                    '${numberFormat.format(trip.fuelFilled)} L',
                    Icons.local_gas_station,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputDetail(
                    'Fuel Price',
                    '${currencyFormat.format(trip.fuelPrice)}/L',
                    Icons.attach_money,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Efficiency Analysis
            Text(
              'Efficiency Analysis',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildEfficiencyIndicator(
              'Mileage Efficiency',
              trip.mileage,
              _getMileageEfficiency(trip.mileage),
              'km/l',
            ),
            const SizedBox(height: 12),
            _buildEfficiencyIndicator(
              'Cost Efficiency',
              trip.fuelEconomy,
              _getCostEfficiency(trip.fuelEconomy),
              '₹/km',
              isCost: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputDetail(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyIndicator(
    String label,
    double value,
    String efficiency,
    String unit, {
    bool isCost = false,
  }) {
    Color color;
    IconData icon;

    switch (efficiency) {
      case 'Excellent':
        color = Colors.green;
        icon = Icons.trending_up;
        break;
      case 'Good':
        color = Colors.blue;
        icon = Icons.trending_flat;
        break;
      case 'Average':
        color = Colors.orange;
        icon = Icons.trending_down;
        break;
      case 'Poor':
        color = Colors.red;
        icon = Icons.trending_down;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${value.toStringAsFixed(2)} $unit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        efficiency,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMileageEfficiency(double mileage) {
    if (mileage >= 25) return 'Excellent';
    if (mileage >= 20) return 'Good';
    if (mileage >= 15) return 'Average';
    return 'Poor';
  }

  String _getCostEfficiency(double costPerKm) {
    if (costPerKm <= 2) return 'Excellent';
    if (costPerKm <= 4) return 'Good';
    if (costPerKm <= 6) return 'Average';
    return 'Poor';
  }

  Color _getVehicleColor(String vehicleType) {
    switch (vehicleType) {
      case 'Car':
        return Colors.blue;
      case 'Bike':
        return Colors.green;
      case 'Bus':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType) {
      case 'Car':
        return Icons.directions_car;
      case 'Bike':
        return Icons.motorcycle;
      case 'Bus':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }
} 