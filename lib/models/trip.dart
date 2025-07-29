import 'package:hive/hive.dart';

part 'trip.g.dart';

@HiveType(typeId: 0)
class Trip extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String vehicleType;

  @HiveField(2)
  double startOdometer;

  @HiveField(3)
  double endOdometer;

  @HiveField(4)
  double fuelFilled;

  @HiveField(5)
  double fuelPrice;

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  double distanceTravelled;

  @HiveField(8)
  double mileage;

  @HiveField(9)
  double totalFuelCost;

  @HiveField(10)
  double fuelEconomy;

  Trip({
    required this.id,
    required this.vehicleType,
    required this.startOdometer,
    required this.endOdometer,
    required this.fuelFilled,
    required this.fuelPrice,
    required this.date,
  }) : distanceTravelled = endOdometer - startOdometer,
       mileage = (endOdometer - startOdometer) / fuelFilled,
       totalFuelCost = fuelFilled * fuelPrice,
       fuelEconomy = (fuelFilled * fuelPrice) / (endOdometer - startOdometer);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleType': vehicleType,
      'startOdometer': startOdometer,
      'endOdometer': endOdometer,
      'fuelFilled': fuelFilled,
      'fuelPrice': fuelPrice,
      'date': date.toIso8601String(),
      'distanceTravelled': distanceTravelled,
      'mileage': mileage,
      'totalFuelCost': totalFuelCost,
      'fuelEconomy': fuelEconomy,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      vehicleType: map['vehicleType'],
      startOdometer: map['startOdometer'].toDouble(),
      endOdometer: map['endOdometer'].toDouble(),
      fuelFilled: map['fuelFilled'].toDouble(),
      fuelPrice: map['fuelPrice'].toDouble(),
      date: DateTime.parse(map['date']),
    );
  }
} 