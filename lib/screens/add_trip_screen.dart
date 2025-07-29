import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/database_service.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startOdometerController = TextEditingController();
  final _endOdometerController = TextEditingController();
  final _fuelFilledController = TextEditingController();
  final _fuelPriceController = TextEditingController();

  String _selectedVehicleType = 'Car';
  final List<String> _vehicleTypes = ['Car', 'Bike', 'Bus'];

  Trip? _calculatedTrip;

  @override
  void dispose() {
    _startOdometerController.dispose();
    _endOdometerController.dispose();
    _fuelFilledController.dispose();
    _fuelPriceController.dispose();
    super.dispose();
  }

  void _calculateTrip() {
    if (_formKey.currentState!.validate()) {
      final startOdometer = double.parse(_startOdometerController.text);
      final endOdometer = double.parse(_endOdometerController.text);
      final fuelFilled = double.parse(_fuelFilledController.text);
      final fuelPrice = double.parse(_fuelPriceController.text);

      setState(() {
        _calculatedTrip = Trip(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          vehicleType: _selectedVehicleType,
          startOdometer: startOdometer,
          endOdometer: endOdometer,
          fuelFilled: fuelFilled,
          fuelPrice: fuelPrice,
          date: DateTime.now(),
        );
      });
    }
  }

  void _saveTrip() async {
    if (_calculatedTrip != null) {
      await DatabaseService.addTrip(_calculatedTrip!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Trip'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle Type Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vehicle Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedVehicleType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items:
                            _vehicleTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedVehicleType = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Odometer Readings
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Odometer Readings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startOdometerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Start (km)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.speed),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter start odometer reading';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _endOdometerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'End (km)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.speed),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter end odometer reading';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                final end = double.parse(value);
                                final start =
                                    double.tryParse(
                                      _startOdometerController.text,
                                    ) ??
                                    0;
                                if (end <= start) {
                                  return 'End must be greater than start';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Fuel Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fuel Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _fuelFilledController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Fuel Filled (L)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.local_gas_station),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter fuel filled';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'Fuel filled must be greater than 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _fuelPriceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price per L (₹)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter fuel price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'Fuel price must be greater than 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Calculate Button
              ElevatedButton.icon(
                onPressed: _calculateTrip,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Results Display
              if (_calculatedTrip != null) ...[
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trip Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultRow(
                          'Distance Travelled',
                          '${_calculatedTrip!.distanceTravelled.toStringAsFixed(2)} km',
                        ),
                        _buildResultRow(
                          'Mileage',
                          '${_calculatedTrip!.mileage.toStringAsFixed(2)} km/l',
                        ),
                        _buildResultRow(
                          'Total Fuel Cost',
                          '₹${_calculatedTrip!.totalFuelCost.toStringAsFixed(2)}',
                        ),
                        _buildResultRow(
                          'Fuel Economy',
                          '₹${_calculatedTrip!.fuelEconomy.toStringAsFixed(2)}/km',
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saveTrip,
                            icon: const Icon(Icons.save),
                            label: const Text('Save Trip'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
