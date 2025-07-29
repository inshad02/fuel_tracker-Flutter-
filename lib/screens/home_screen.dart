import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../services/database_service.dart';
import 'add_trip_screen.dart';
import 'trip_detail_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Trip> _trips = [];
  String _selectedVehicleFilter = 'All';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _loadTrips();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadTrips() {
    setState(() {
      if (_selectedVehicleFilter == 'All') {
        _trips = DatabaseService.getAllTrips();
      } else {
        _trips = DatabaseService.getTripsByVehicleType(_selectedVehicleFilter);
      }
      _trips.sort((a, b) => b.date.compareTo(a.date));
    });
    if (mounted && _animationController != null) {
      _animationController.forward(from: 0);
    }
  }

  Future<void> _addNewTrip() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTripScreen()),
    );
    if (result == true) {
      _loadTrips();
    }
  }

  void _deleteTrip(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Trip'),
            content: const Text('Are you sure you want to delete this trip?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await DatabaseService.deleteTrip(trip.id);
      _loadTrips();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip deleted successfully!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final numberFormat = NumberFormat('#,##0.00');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Tracker'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedVehicleFilter = value;
              });
              _loadTrips();
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
                  Text(
                    _selectedVehicleFilter,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.filter_list, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.local_gas_station,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fuel Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Track your fuel efficiency',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient Header
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.local_gas_station,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Welcome Back!',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Track your fuel economy and mileage with ease.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Statistics Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child:
                      _trips.isNotEmpty
                          ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      'Total Distance',
                                      '${numberFormat.format(DatabaseService.getTotalDistance())} km',
                                      Icons.route,
                                      theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatCard(
                                      'Total Cost',
                                      currencyFormat.format(
                                        DatabaseService.getTotalFuelCost(),
                                      ),
                                      Icons.attach_money,
                                      Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      'Avg Mileage',
                                      '${numberFormat.format(DatabaseService.getAverageMileage())} km/l',
                                      Icons.speed,
                                      Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatCard(
                                      'Avg Economy',
                                      '${currencyFormat.format(DatabaseService.getAverageFuelEconomy())}/km',
                                      Icons.trending_up,
                                      Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'No trips yet',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add your first trip to see stats!',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),

            // Trip List or Empty State
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child:
                  _trips.isEmpty
                      ? _buildEmptyState(theme)
                      : Column(
                        children: List.generate(_trips.length, (index) {
                          final trip = _trips[index];
                          final animation =
                              (_animationController.isAnimating ||
                                      _animationController.isCompleted)
                                  ? Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(
                                        (index / _trips.length).clamp(0.0, 1.0),
                                        1.0,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  )
                                  : AlwaysStoppedAnimation(Offset.zero);

                          return SlideTransition(
                            position: animation,
                            child: AnimatedOpacity(
                              opacity: _animationController.value,
                              duration: const Duration(milliseconds: 500),
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                TripDetailScreen(trip: trip),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: _getVehicleColor(
                                      trip.vehicleType,
                                    ).withOpacity(0.15),
                                    child: Icon(
                                      _getVehicleIcon(trip.vehicleType),
                                      color: _getVehicleColor(trip.vehicleType),
                                      size: 28,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        trip.vehicleType,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(trip.date),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildTripStat(
                                            'Distance',
                                            '${numberFormat.format(trip.distanceTravelled)} km',
                                            theme,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildTripStat(
                                            'Mileage',
                                            '${numberFormat.format(trip.mileage)} km/l',
                                            theme,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildTripStat(
                                            'Cost',
                                            currencyFormat.format(
                                              trip.totalFuelCost,
                                            ),
                                            theme,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        _deleteTrip(trip);
                                      }
                                    },
                                    itemBuilder:
                                        (context) => [
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: FloatingActionButton.extended(
          onPressed: _addNewTrip,
          icon: const Icon(Icons.add, size: 28),
          label: const Text(
            'Add Trip',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
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
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildTripStat(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_filled,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.18),
            ),
            const SizedBox(height: 24),
            Text(
              'No trips recorded yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first trip',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Fuel Tracker'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuel Economy & Mileage Tracker',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Version 1.0.0'),
                SizedBox(height: 8),
                Text(
                  'Track your vehicle\'s fuel efficiency and mileage with detailed analytics and insights.',
                ),
                SizedBox(height: 16),
                Text(
                  'Features:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('• Support for Car, Bike, and Bus'),
                Text('• Mileage calculation (km/l)'),
                Text('• Fuel economy tracking (₹/km)'),
                Text('• Trip history and statistics'),
                Text('• Data persistence with Hive'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
