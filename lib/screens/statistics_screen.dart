import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../services/database_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedVehicleFilter = 'All';
  final String _selectedTimeFilter = 'All Time';

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final numberFormat = NumberFormat('#,##0.00');

    final trips = _getFilteredTrips();
    final totalTrips = trips.length;
    final totalDistance = trips.fold(
      0.0,
      (sum, trip) => sum + trip.distanceTravelled,
    );
    final totalFuelCost = trips.fold(
      0.0,
      (sum, trip) => sum + trip.totalFuelCost,
    );
    final totalFuelUsed = trips.fold(0.0, (sum, trip) => sum + trip.fuelFilled);
    final avgMileage = totalFuelUsed > 0 ? totalDistance / totalFuelUsed : 0.0;
    final avgFuelEconomy =
        totalDistance > 0 ? totalFuelCost / totalDistance : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedVehicleFilter = value;
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'All',
                    child: Text('All Vehicles'),
                  ),
                  const PopupMenuItem(value: 'Car', child: Text('Car')),
                  const PopupMenuItem(value: 'Bike', child: Text('Bike')),
                  const PopupMenuItem(value: 'Bus', child: Text('Bus')),
                ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedVehicleFilter),
                  const Icon(Icons.filter_list),
                ],
              ),
            ),
          ),
        ],
      ),
      body:
          trips.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No data available',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add some trips to see statistics',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.analytics,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Overview',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildOverviewStat(
                                    'Total Trips',
                                    totalTrips.toString(),
                                    Icons.route,
                                    Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildOverviewStat(
                                    'Total Distance',
                                    '${numberFormat.format(totalDistance)} km',
                                    Icons.speed,
                                    Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildOverviewStat(
                                    'Total Fuel Used',
                                    '${numberFormat.format(totalFuelUsed)} L',
                                    Icons.local_gas_station,
                                    Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildOverviewStat(
                                    'Total Cost',
                                    currencyFormat.format(totalFuelCost),
                                    Icons.attach_money,
                                    Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Performance Metrics
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Performance Metrics',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildPerformanceMetric(
                              'Average Mileage',
                              '${numberFormat.format(avgMileage)} km/l',
                              _getMileageEfficiency(avgMileage),
                              Icons.speed,
                            ),
                            const SizedBox(height: 12),
                            _buildPerformanceMetric(
                              'Average Fuel Economy',
                              '${currencyFormat.format(avgFuelEconomy)}/km',
                              _getCostEfficiency(avgFuelEconomy),
                              Icons.trending_up,
                              isCost: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Vehicle-wise Statistics
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Vehicle-wise Statistics',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...['Car', 'Bike', 'Bus'].map((vehicleType) {
                              final vehicleTrips =
                                  trips
                                      .where(
                                        (t) => t.vehicleType == vehicleType,
                                      )
                                      .toList();
                              if (vehicleTrips.isEmpty)
                                return const SizedBox.shrink();

                              final vehicleDistance = vehicleTrips.fold(
                                0.0,
                                (sum, trip) => sum + trip.distanceTravelled,
                              );
                              final vehicleCost = vehicleTrips.fold(
                                0.0,
                                (sum, trip) => sum + trip.totalFuelCost,
                              );
                              final vehicleFuel = vehicleTrips.fold(
                                0.0,
                                (sum, trip) => sum + trip.fuelFilled,
                              );
                              final vehicleMileage =
                                  vehicleFuel > 0
                                      ? vehicleDistance / vehicleFuel
                                      : 0.0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildVehicleStat(
                                  vehicleType,
                                  vehicleTrips.length,
                                  vehicleDistance,
                                  vehicleCost,
                                  vehicleMileage,
                                  numberFormat,
                                  currencyFormat,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recent Trips
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Recent Trips',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...trips.take(5).map((trip) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _buildRecentTrip(
                                  trip,
                                  numberFormat,
                                  currencyFormat,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  List<Trip> _getFilteredTrips() {
    List<Trip> trips;
    if (_selectedVehicleFilter == 'All') {
      trips = DatabaseService.getAllTrips();
    } else {
      trips = DatabaseService.getTripsByVehicleType(_selectedVehicleFilter);
    }

    // Apply time filter
    final now = DateTime.now();
    switch (_selectedTimeFilter) {
      case 'Last 7 Days':
        trips =
            trips
                .where(
                  (trip) =>
                      trip.date.isAfter(now.subtract(const Duration(days: 7))),
                )
                .toList();
        break;
      case 'Last 30 Days':
        trips =
            trips
                .where(
                  (trip) =>
                      trip.date.isAfter(now.subtract(const Duration(days: 30))),
                )
                .toList();
        break;
      case 'Last 3 Months':
        trips =
            trips
                .where(
                  (trip) =>
                      trip.date.isAfter(now.subtract(const Duration(days: 90))),
                )
                .toList();
        break;
      default:
        // All Time - no filtering
        break;
    }

    return trips;
  }

  Widget _buildOverviewStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(
    String label,
    String value,
    String efficiency,
    IconData icon, {
    bool isCost = false,
  }) {
    Color color;
    switch (efficiency) {
      case 'Excellent':
        color = Colors.green;
        break;
      case 'Good':
        color = Colors.blue;
        break;
      case 'Average':
        color = Colors.orange;
        break;
      case 'Poor':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
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
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  Widget _buildVehicleStat(
    String vehicleType,
    int tripCount,
    double distance,
    double cost,
    double mileage,
    NumberFormat numberFormat,
    NumberFormat currencyFormat,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getVehicleColor(vehicleType).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getVehicleColor(vehicleType).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getVehicleIcon(vehicleType),
                color: _getVehicleColor(vehicleType),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                vehicleType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$tripCount trips',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildVehicleMetric(
                  'Distance',
                  '${numberFormat.format(distance)} km',
                ),
              ),
              Expanded(
                child: _buildVehicleMetric('Cost', currencyFormat.format(cost)),
              ),
              Expanded(
                child: _buildVehicleMetric(
                  'Mileage',
                  '${numberFormat.format(mileage)} km/l',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRecentTrip(
    Trip trip,
    NumberFormat numberFormat,
    NumberFormat currencyFormat,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _getVehicleColor(trip.vehicleType),
            child: Icon(
              _getVehicleIcon(trip.vehicleType),
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.vehicleType,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(trip.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${numberFormat.format(trip.distanceTravelled)} km',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                currencyFormat.format(trip.totalFuelCost),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
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
