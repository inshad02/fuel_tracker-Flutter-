import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart';

class DatabaseService {
  static const String _tripBoxName = 'trips';
  static Box<Trip>? _tripBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TripAdapter());
    _tripBox = await Hive.openBox<Trip>(_tripBoxName);
  }

  static Future<void> addTrip(Trip trip) async {
    await _tripBox?.put(trip.id, trip);
  }

  static Future<void> deleteTrip(String id) async {
    await _tripBox?.delete(id);
  }

  static List<Trip> getAllTrips() {
    return _tripBox?.values.toList() ?? [];
  }

  static List<Trip> getTripsByVehicleType(String vehicleType) {
    return _tripBox?.values
            .where((trip) => trip.vehicleType == vehicleType)
            .toList() ??
        [];
  }

  static Trip? getTripById(String id) {
    return _tripBox?.get(id);
  }

  static Future<void> close() async {
    await _tripBox?.close();
  }

  static double getAverageMileage() {
    final trips = getAllTrips();
    if (trips.isEmpty) return 0.0;
    final totalMileage = trips.fold(0.0, (sum, trip) => sum + trip.mileage);
    return totalMileage / trips.length;
  }

  static double getAverageFuelEconomy() {
    final trips = getAllTrips();
    if (trips.isEmpty) return 0.0;
    final totalFuelEconomy = trips.fold(0.0, (sum, trip) => sum + trip.fuelEconomy);
    return totalFuelEconomy / trips.length;
  }

  static double getTotalDistance() {
    final trips = getAllTrips();
    return trips.fold(0.0, (sum, trip) => sum + trip.distanceTravelled);
  }

  static double getTotalFuelCost() {
    final trips = getAllTrips();
    return trips.fold(0.0, (sum, trip) => sum + trip.totalFuelCost);
  }
} 