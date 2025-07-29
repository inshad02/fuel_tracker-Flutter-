// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 0;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String,
      vehicleType: fields[1] as String,
      startOdometer: fields[2] as double,
      endOdometer: fields[3] as double,
      fuelFilled: fields[4] as double,
      fuelPrice: fields[5] as double,
      date: fields[6] as DateTime,
    )
      ..distanceTravelled = fields[7] as double
      ..mileage = fields[8] as double
      ..totalFuelCost = fields[9] as double
      ..fuelEconomy = fields[10] as double;
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vehicleType)
      ..writeByte(2)
      ..write(obj.startOdometer)
      ..writeByte(3)
      ..write(obj.endOdometer)
      ..writeByte(4)
      ..write(obj.fuelFilled)
      ..writeByte(5)
      ..write(obj.fuelPrice)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.distanceTravelled)
      ..writeByte(8)
      ..write(obj.mileage)
      ..writeByte(9)
      ..write(obj.totalFuelCost)
      ..writeByte(10)
      ..write(obj.fuelEconomy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
